# cython: c_string_type=unicode, c_string_encoding=utf8

cimport slurm
cimport common
import common
from libc.stdint cimport uint8_t, uint16_t, uint32_t, uint64_t
from common cimport to_charptr, to_unicode, make_time_str, get_job_std, list_2_charptr
from common import to_uint16, to_uint32, to_uint64, mins2time_str, secs2time_str, uid2name, gid2name, from_uint16, from_uint32, from_uint64, parse_time, time_str2mins, time_str2secs, group2gid, user2uid
from os import WIFSIGNALED, WIFEXITED, WTERMSIG, WEXITSTATUS, getcwd


def filter_all(objs, **kwargs):

    filtered = []

    for obj in objs:
        for attr, val in kwargs.items():
            obj_val = None

            try:
                obj_val = getattr(obj, attr)
            except AttributeError:
                pass

            if obj_val is not None:
                if val == obj_val and obj not in filtered:
                    filtered.append(obj)

    return filtered


cdef class JobDescription:
    cdef public:
        account
        acct_gather_frequency
        array # Form: x-y:STEP:MAX_PARALLEL
        batch_features
        burst_buffer
        burst_buffer_file
        begin_time
        work_dir
        cluster_constraints
        clusters
        comment
        constraints
        container
        contiguous
        core_spec
        cpu_freq
        cpus_per_task
        deadline_time
        delay_boot_time
        dependencies
        distribution
        stderr
        nodes_exclude
        exclusive
        environment
        environment_file
        sockets_per_node
        cores_per_socket
        threads_per_core
        get_user_env
        group
        gpu_bind
        gpu_freq
        gpus
        gpus_per_node
        gpus_per_socket
        gpus_per_task
        gres_binding_enforce
        hint
        hold
        stdin
        name
        kill_on_invalid_dep
        licenses
        mail_type
        mail_user
        mcs_label
        mem_per_node
        mem_bind
        mem_per_cpu
        mem_per_gpu
        mincpus
        network
        nice
        kill_on_node_fail
        requeue
        nodefile
        nodelist
        node_count
        ntasks
        ntasks_per_core
        ntasks_per_gpu
        ntasks_per_node
        ntasks_per_socket
        open_mode
        stdout
        overcommit
        oversubscribe
        partition
        power
        priority
        profile
        propagate_limits
        qos
        reboot
        reservations
        script_body
        script_path
        script_args
        signal
        signal_time
        spread_job
        switches
        switches_max_wait
        thread_spec
        time_limit
        time_limit_min
        tmp
        user
        use_min_nodes
        wait_all_nodes
        wckey
        job_id
        cpus_per_tres
        export_env

    def __init__(self, **opts):
        for k, v in opts.items():
            setattr(self, k, v)


cdef class JobStep:
    pass


cdef class Job:
    cdef public:
        # FIXME: Resolve bitflags
        account
        admin_comment
        alloc_node
        accrue_time
        array_job_id
        array_task_id
        array_max_tasks
        assoc_id
        batch_features
        is_batch_job
        boards_per_node
        burst_buffer
        burst_buffer_state
        cluster
        cluster_features
        command
        comment
        contiguous
        core_spec
        thread_spec
        cores_per_socket
        billable_tres
        cpus_per_task
        cpus_per_tres
        cpu_freq_min
        cpu_freq_max
        cpu_freq_gov
        cron_time
        is_cron_job
        deadline_time
        delay_boot
        dependency
        derived_exit_code
        derived_exit_code_signal
        exit_code
        exit_code_signal
        eligible_time
        end_time
        features
        federation_origin
        federation_siblings_active
        federation_siblings_viable
        gres
        nodes
        nodes_sched
        nodes_excluded
        nodes_required
        nodes_requested
        nodes_count
        batch_host
        mail_type
        mail_user
        licenses
        max_cpus
        mcs_label
        mem_per_tres
        name
        network
        nice
        ntasks_per_core
        ntasks_per_tres
        ntasks_per_node
        ntasks_per_socket
        ntasks_per_board
        ntasks
        num_cpus
        partition
        mem_per_cpu
        mem_per_node
        min_cpus_per_node
        tmp_disk_per_node
        preempt_time
        preemptable_time
        pre_suspension_time
        priority
        qos
        reboot
        required_switch
        requeue
        reservation_name
        allow_node_share
        site_factor
        sockets_per_board
        sockets_per_node
        state_reason
        time_limit
        time_limit_min
        threads_per_core
        tres_freq
        tres_bind
        tres_alloc
        tres_req
        tres_per_job
        tres_per_node
        tres_per_socket
        tres_per_task
        tres
        wckey
        work_dir
        user
        user_id
        group
        group_id
        het_job_id
        het_job_offset
        het_job_id_set
        job_id
        state
        last_sched_eval
        resize_time
        restarts
        start_time
        submit_time
        suspend_time
        system_comment
        run_time
        oversubscribe
        stdin
        stderr
        stdout
        switches
        switches_wait_time_max
        power
        gres_enforce_bind
        kill_on_invalid_dependent
        spread_job


    def __init__(self, **opts):
        for k, v in opts.items():
            setattr(self, k, v)


    def dict(self):
        cdef dict out = {}
        for a in dir(self):
            attr = getattr(self, a)
            if not a.startswith("_") and not callable(attr):
                out.update({a: attr})

        return out


    @staticmethod
    def get():
        cdef:
            slurm.job_info_msg_t *job_info_ptr = NULL
            slurm.slurm_job_info_t *record = NULL
            uint32_t record_cnt
            dict jobs = {}

        _load_job_info(&job_info_ptr, slurm.SHOW_ALL)

        record = job_info_ptr.job_array
        for record_cnt in range(job_info_ptr.record_count):

            job = _parse_record(&record[record_cnt])
            jobs.update({ job.job_id: job })

        _free_job_info(job_info_ptr)

        return jobs


    @staticmethod
    def submit(job_opts):
        cdef:
            slurm.job_desc_msg_t job_desc_msg
            slurm.submit_response_msg_t *resp = NULL

        slurm.slurm_init_job_desc_msg(&job_desc_msg)
        _create_job_record(job_opts, &job_desc_msg)

        if slurm.slurm_submit_batch_job(&job_desc_msg, &resp):
            raise ValueError(common.get_last_slurm_error())

        # slurm.slurm_free_submit_response_response_msg(resp)
        # FIXME: free job_desc_msg_t after submission


    @staticmethod
    def modify(job_desc):
        pass


    @property
    def script(self):
        pass


cdef _free_job_info(slurm.job_info_msg_t *job_ptr):
    if job_ptr is not NULL:
        slurm.slurm_free_job_info_msg(job_ptr)
        job_ptr = NULL


cdef int _load_job_info(slurm.job_info_msg_t **job_info_ptr,
                         uint16_t flags) except? -1:
    cdef:
        slurm.job_info_msg_t *new_job_ptr = NULL
        int rc = slurm.SLURM_SUCCESS
        slurm.time_t last_update = 0

    rc = slurm.slurm_load_jobs(last_update, &new_job_ptr, flags)

    if rc != slurm.SLURM_SUCCESS:
        _free_job_info(new_job_ptr)
        raise ValueError(common.get_last_slurm_error())

    job_info_ptr[0] = new_job_ptr


cdef _parse_batch_script(opts, slurm.job_desc_msg_t *desc):
    if not opts.script_body:
        with open(opts.script_path, "r") as script:
            opts.script_body = script.read()

    if not len(opts.script_body):
        raise ValueError("Script is empty!")

    # FIXME: add further checks to ensure a valid script

    desc.script = to_charptr(opts.script_body)

    # Script path must be alaways first in argv
    # Only necessary if batch script is read from file
    if opts.script_path:
        if opts.script_args:
            opts.script_args.insert(0, opts.script_path)
        else:
            opts.script_args = [opts.script_path]


cdef _get_envcount(char **env):
    cdef int envc = 0
    while env and env[envc]:
        envc+=1

    return envc


cdef _get_workdir(JobDescription opts):
    if not opts.work_dir:
        opts.work_dir = str(getcwd())

    if not opts.work_dir:
        raise ValueError("Couldn't get current Working directory.")

    return opts.work_dir


cdef _set_job_bitflags(JobDescription opts, slurm.job_desc_msg_t *desc):
    if opts.kill_on_invalid_dep:
        desc.bitflags |= slurm.KILL_INV_DEP

    if desc.num_tasks != slurm.NO_VAL:
        desc.bitflags |= slurm.JOB_NTASKS_SET


cdef _set_open_mode(mode, slurm.job_desc_msg_t *desc):
    if mode == "append":
        desc.open_mode = slurm.OPEN_MODE_APPEND
    elif mode == "truncate":
        desc.open_mode = slurm.OPEN_MODE_TRUNCATE


cdef _get_shared_flag(exclusive):
    if not exclusive:
        return slurm.NO_VAL16
    elif exclusive == "oversubscribe":
        return slurm.JOB_SHARED_OK
    elif exclusive == "user":
        return slurm.JOB_SHARED_USER
    elif exclusive == "mcs":
        return slurm.JOB_SHARED_MCS
    elif exclusive == "yes":
        return slurm.JOB_SHARED_NONE


cdef _set_job_argv(opts, slurm.job_desc_msg_t *desc):
    desc.argc = len(opts.script_args)
    desc.argv = <char**>slurm.xmalloc(desc.argc * sizeof(char*))

    for idx, opt in enumerate(opts.script_args):
        desc.argv[idx] = to_charptr(opt)


cdef _set_job_env(JobDescription opts, slurm.job_desc_msg_t *desc):
    desc.environment = NULL

    if opts.export_env is None or opts.export_env == "all":
        slurm.slurm_env_array_merge(
            &desc.environment, <const char **>slurm.environ
        )
    elif opts.export_env == "none":
        # FIXME: env_array_merge_slurm is not exported
        # in libslurm (only libslurmfull)
        #
        #        desc.environment = slurm.slurm_env_array_create()
        #        slurm.slurm_env_array_merge_slurm(
        #            &desc.environment, <const char **>slurm.environ
        #        )
        opts.get_user_env = False
    else:
        pass

    if opts.get_user_env:
        slurm.slurm_env_array_overwrite(
            &desc.environment, "SLURM_GET_USER_ENV", "1"
        )

    desc.env_size = _get_envcount(desc.environment)


cdef _create_job_record(JobDescription opts, slurm.job_desc_msg_t *desc):
    # FIXME(?): Maybe use xstrdup for char* related stuff here?

    desc.account = to_charptr(opts.account)
    desc.acctg_freq = to_charptr(opts.acct_gather_frequency)
    desc.array_inx = to_charptr(opts.array)
    desc.batch_features = to_charptr(opts.batch_features)
    desc.begin_time = parse_time(opts.begin_time)
    _set_job_bitflags(opts, desc)
    # FIXME: support loading from burst buffer file?
    desc.burst_buffer = to_charptr(opts.burst_buffer)
    desc.clusters = to_charptr(opts.clusters)
    desc.cluster_features = to_charptr(opts.cluster_constraints)
    desc.comment = to_charptr(opts.comment)
    desc.contiguous = 1 if opts.contiguous else 0
    desc.core_spec = to_uint16(opts.core_spec)
    # desc.cpu_bind is unused
    # desc.cpu_bind_type is unused
    desc.work_dir = to_charptr(_get_workdir(opts))
    # _set_cpu_freq(desc)
    desc.cpus_per_tres = to_charptr(opts.cpus_per_tres)
    desc.deadline = parse_time(opts.deadline_time)
    desc.delay_boot = time_str2secs(opts.delay_boot_time)
    desc.dependency = to_charptr(opts.dependencies)
    desc.exc_nodes = to_charptr(opts.nodes_exclude)
    desc.features = to_charptr(opts.constraints)
    desc.group_id = group2gid(opts.group) if opts.group else slurm.NO_VAL
    desc.job_id = to_uint32(opts.job_id)
    desc.kill_on_node_fail = 1 if opts.kill_on_node_fail else 0
    desc.licenses = to_charptr(opts.licenses)
    # FIXME: need to implement parse_mail_type
    # desc.mail_type
    desc.mail_user = to_charptr(opts.mail_user)
    desc.mcs_label = to_charptr(opts.mcs_label)
    # _set_mem_bind() mem_bind, mem_bind_type
    # desc.mem_per_tres -> mem_per_gpu
    desc.name = to_charptr(opts.name)
    desc.network = to_charptr(opts.network)
    desc.nice = slurm.NICE_OFFSET + opts.nice if opts.nice else slurm.NO_VAL
    desc.num_tasks = to_uint32(opts.ntasks)
    _set_open_mode(opts.open_mode, desc)
    # desc.overcommit FIXME
    desc.partition = to_charptr(opts.partition)
    # desc.power_flags = get_power_flag(opts.power)
    # desc.prefer = to_charptr(opts.prefer) 21.08 only
    desc.priority = 0 if opts.hold else to_uint32(opts.priority)
    # desc.profile = get_acctg_profile()
    desc.qos = to_charptr(opts.qos)
    desc.reboot = 1 if opts.reboot else slurm.NO_VAL16
    desc.req_nodes = to_charptr(opts.nodelist)
    desc.requeue = 1 if opts.requeue else slurm.NO_VAL16
    desc.reservation = to_charptr(opts.reservations)
    _parse_batch_script(opts, desc)
    desc.shared = _get_shared_flag(opts.exclusive)

    # Would need to provide spank hooks here?
    # desc.spank_job_env_size
    # des.spank_job_env

    # FIXME: need to create a function that parses the input and
    # translates to valid task disk states
    # _set_task_distribution

    desc.time_limit = time_str2mins(opts.time_limit)
    desc.time_min = time_str2mins(opts.time_limit_min)
    desc.user_id = user2uid(opts.user) if opts.user else slurm.NO_VAL

    # FIXME: parse gpu_bindings tres_bind_verify_cmdline
    # desc.gpu_bind =

    desc.cpus_per_task = to_uint16(opts.cpus_per_task)
    desc.sockets_per_node = to_uint16(opts.sockets_per_node)
    desc.cores_per_socket = to_uint16(opts.cores_per_socket)
    desc.threads_per_core = to_uint16(opts.threads_per_core)
    desc.ntasks_per_node = to_uint16(opts.ntasks_per_node)
    desc.ntasks_per_socket = to_uint16(opts.ntasks_per_socket)
    desc.ntasks_per_core = to_uint16(opts.ntasks_per_core)
    desc.ntasks_per_tres = to_uint16(opts.ntasks_per_gpu)

    # FIXME: --mem, --mem-per-cpu, --mem-per-gpu mut. exclusive
    # _set_job_memory(opts, desc)

    desc.req_switch = to_uint32(opts.switches)
    desc.std_in = to_charptr(opts.stdin)
    desc.std_err = to_charptr(opts.stderr)
    desc.std_out = to_charptr(opts.stdout)
    desc.wait4switch = time_str2secs(opts.switches_max_wait)
    desc.wckey = to_charptr(opts.wckey)

    # desc.min_cpus

    _set_job_argv(opts, desc)
    _set_job_env(opts, desc)


    # UPDATE ONLY
    # desc.admin_comment =
    # desc.end_time =


cdef _parse_record(slurm.slurm_job_info_t *info):
    cdef:
        Job j = None
        common.time_t run_time
        common.time_t end_time

    j = Job(name=to_unicode(info.name))
    j.job_id = info.job_id
    j.assoc_id = from_uint32(info.assoc_id)
    j.account = to_unicode(info.account)
    j.user_id = info.user_id
    j.user = to_unicode(info.user_name) if info.user_name else uid2name(j.user_id)
    j.group_id = info.group_id
    j.group = gid2name(j.group_id)
    j.priority = from_uint32(info.priority)
    j.nice = int(info.nice) - slurm.NICE_OFFSET
    j.qos = to_unicode(info.qos)
    j.state = to_unicode(slurm.slurm_job_state_string(info.job_state))
    j.requeue = True if info.requeue else False
    j.restarts = info.restart_cnt
    j.is_batch_job = True if info.batch_flag else False
    j.reboot = True if info.reboot else False
    j.dependency = to_unicode(info.dependency)
    j.time_limit = mins2time_str(info.time_limit, "PartitionLimit")
    j.time_limit_min = mins2time_str(info.time_min, noval=0)
    j.submit_time = make_time_str(&info.submit_time)
    j.eligible_time = make_time_str(&info.eligible_time)
    j.accrue_time = make_time_str(&info.accrue_time)
    j.start_time = make_time_str(&info.start_time)
    j.resize_time = make_time_str(&info.resize_time)
    j.deadline_time = make_time_str(&info.deadline)
    j.preemptable_time = make_time_str(&info.preemptable_time)
    j.suspend_time = make_time_str(&info.suspend_time)
    j.pre_suspension_time = secs2time_str(info.pre_sus_time)
    j.last_sched_eval = make_time_str(&info.last_sched_eval)
    j.partition = to_unicode(info.partition)
    j.alloc_node = to_unicode(info.alloc_node)
    j.nodes_requested = to_unicode(info.req_nodes)
    j.nodes_excluded = to_unicode(info.exc_nodes)
    j.nodes = to_unicode(info.nodes)
    j.nodes_sched = to_unicode(info.sched_nodes)
    j.batch_features = to_unicode(info.batch_features)
    j.batch_host = to_unicode(info.batch_host)
    j.federation_origin = to_unicode(info.fed_origin_str)
    j.federation_siblings_active = from_uint64(info.fed_siblings_active)
    j.federation_siblings_viable = from_uint64(info.fed_siblings_viable)
    j.ntasks = info.num_tasks
    j.cpus_per_task = from_uint16(info.cpus_per_task)
    j.boards_per_node = from_uint16(info.boards_per_node)
    j.sockets_per_board = from_uint16(info.sockets_per_board)
    j.cores_per_socket = from_uint16(info.cores_per_socket)
    j.threads_per_core = from_uint16(info.threads_per_core)
    j.sockets_per_node = from_uint16(info.sockets_per_node)
    j.ntasks_per_node = from_uint16(info.ntasks_per_node)
    j.ntasks_per_board = from_uint16(info.ntasks_per_board)
    j.ntasks_per_socket = from_uint16(info.ntasks_per_socket)
    j.ntasks_per_core = from_uint16(info.ntasks_per_core)
    j.ntasks_per_tres = from_uint16(info.ntasks_per_tres)
    j.delay_boot = secs2time_str(info.delay_boot)
    j.features = to_unicode(info.features)
    j.cluster = to_unicode(info.cluster)
    j.cluster_features = to_unicode(info.cluster_features)
    j.reservation_name = to_unicode(info.resv_name)
    j.oversubscribe = to_unicode(slurm.slurm_job_share_string(info.shared)).casefold()
    j.contiguous = True if info.contiguous else False
    j.licenses = to_unicode(info.licenses)
    j.network = to_unicode(info.network)
    j.command = to_unicode(info.command)
    j.work_dir = to_unicode(info.work_dir)
    j.admin_comment = to_unicode(info.admin_comment)
    j.system_comment = to_unicode(info.system_comment)
    j.comment = to_unicode(info.comment)
    j.stdin = get_job_std(info, "stdin")
    j.stderr = get_job_std(info, "stderr")
    j.stdout = get_job_std(info, "stdout")
    j.switches = from_uint32(info.req_switch)
    j.switches_wait_time_max = secs2time_str(info.wait4switch)
    j.burst_buffer = to_unicode(info.burst_buffer)
    j.burst_buffer_state = to_unicode(info.burst_buffer_state)
    j.cpu_freq_min = from_uint32(info.cpu_freq_min)
    j.cpu_freq_max = from_uint32(info.cpu_freq_max)
    j.cpu_freq_gov = from_uint32(info.cpu_freq_gov)
    j.cpus_per_tres = to_unicode(info.cpus_per_tres)
    j.mem_per_tres = to_unicode(info.mem_per_tres)
    j.tres_bind = to_unicode(info.tres_bind)
    j.tres_freq = to_unicode(info.tres_freq)
    j.tres_per_job = to_unicode(info.tres_per_job)
    j.tres_per_node = to_unicode(info.tres_per_node)
    j.tres_per_socket = to_unicode(info.tres_per_socket)
    j.tres_per_task = to_unicode(info.tres_per_task)
    j.wckey = to_unicode(info.wckey) if slurm.slurm_get_track_wckey() else None
    j.mail_user = to_unicode(info.mail_user)
    j.het_job_id = from_uint32(info.het_job_id, noval=0)
    j.het_job_offset = from_uint32(info.het_job_offset, noval=0)
    j.het_job_id_set = to_unicode(info.het_job_id_set)
    j.array_job_id = from_uint32(info.array_job_id, noval=0)
    j.array_max_tasks = from_uint32(info.array_max_tasks, noval=0)
    j.tmp_disk_per_node = from_uint32(info.pn_min_tmp_disk)

    # FIXME: Needs print_mail_type function implemented
    j.mail_type = None

    if info.time_limit == slurm.INFINITE and info.end_time > common.time(NULL):
        j.end_time = "Unknown"
    else:
        j.end_time = make_time_str(&info.end_time)

    if info.tres_alloc_str:
        j.tres = to_unicode(info.tres_alloc_str)
    else:
        j.tres = to_unicode(info.tres_req_str)

    if info.core_spec == slurm.NO_VAL16:
        j.core_spec = None
    elif info.core_spec & slurm.CORE_SPEC_THREAD:
        j.thread_spec = info.core_spec & (~slurm.CORE_SPEC_THREAD)
    else:
        j.core_spec = info.core_spec

    # FIXME: Provide detailed output (-d option to scontrol)
    # The mapping of how much Resources are allocated on which node

    if info.pn_min_memory & slurm.MEM_PER_CPU:
        info.pn_min_memory &= (~slurm.MEM_PER_CPU)
        j.mem_per_cpu = from_uint64(info.pn_min_memory)
    else:
        j.mem_per_node = from_uint64(info.pn_min_memory)

    if info.bitflags & slurm.GRES_DISABLE_BIND:
        j.gres_enforce_bind = False
    elif info.bitflags & slurm.GRES_ENFORCE_BIND:
        j.gres_enforce_bind = True

    if info.bitflags & slurm.KILL_INV_DEP:
        j.kill_on_invalid_dependent = True
    elif info.bitflags & slurm.NO_KILL_INV_DEP:
        j.kill_on_invalid_dependent = False

    if info.bitflags & slurm.SPREAD_JOB:
        j.spread_job = True
    else:
        j.spread_job = False

    # FIXME: Implement power_flags_str function
    j.power = None

    # FIXME: Implement Cronjob support
    j.is_cron_job = None

    if slurm.IS_JOB_PENDING(info):
        run_time = 0
    elif slurm.IS_JOB_SUSPENDED(info):
        run_time = info.pre_sus_time
    else:
        if slurm.IS_JOB_RUNNING(info) or info.end_time == 0:
            end_time = common.time(NULL)
        else:
            end_time = info.end_time

        if info.suspend_time:
            run_time = <common.time_t>common.difftime(
                end_time, info.suspend_time + info.pre_sus_time
            )
        else:
            run_time = <common.time_t>common.difftime(end_time, info.start_time)

    j.run_time = secs2time_str(run_time)

    if info.array_task_str:
        # use range?
        j.array_task_id = to_unicode(info.array_task_str)
    else:
        j.array_task_id = from_uint32(info.array_task_id, noval=0)

    # FIXME: NumNodes can possibly be a range, e.g: NumNodes=x-y
    if slurm.IS_JOB_PENDING(info):
        if info.max_nodes and info.max_nodes < info.num_nodes:
            pass

    # FIXME: NumCPUs can also be a range, e.g: NumCPUs=x-y
    # j.num_cpus

    if info.state_desc:
        j.state_reason = to_unicode(info.state_desc)
    else:
        j.state_reason = to_unicode(
            slurm.slurm_job_reason_string(info.state_reason)
        )


    # FIXME: fails sometimes?
    #    _get_job_exit_codes(j, info)

    return j


cdef _get_job_exit_codes(j, slurm.slurm_job_info_t *info):
    if WIFSIGNALED(info.exit_code):
        j.exit_code_signal = WTERMSIG(info.exit_code)
    elif WIFEXITED(info.exit_code):
        j.exit_code = WEXITSTATUS(info.exit_code)

    if WIFSIGNALED(info.derived_ec):
        j.derived_exit_code_signal = WTERMSIG(info.derived_ec)
    elif WIFEXITED(info.derived_ec):
        j.derived_exit_code = WEXITSTATUS(info.derived_ec)
