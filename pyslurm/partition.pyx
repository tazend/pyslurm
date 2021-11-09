# cython: c_string_type=unicode, c_string_encoding=utf8

cimport slurm
cimport common
import common
from libc.stdint cimport uint8_t, uint16_t, uint32_t, uint64_t
from libc.string cimport memset
from common cimport flag16_2_bool, to_charptr, to_unicode
from common import inf16, inf32, inf64, from_uint16, from_uint32, from_uint64

cdef class Partition:
    cdef:
        public allow_alloc_nodes
        public allow_accounts
        public allow_groups
        public allow_qos
        public deny_accounts
        public deny_qos
        public alternate
        public qos
        public nodes
        public priority_tier
        public priority_job_factor
        public grace_time
        public is_default
        public billing_weights
        public root_only
        public hidden
        public req_resv
        public disable_root_jobs
        public lln
        public exclusive_user
        public cpu_bind
        public default_time
        public job_defaults
        public oversubscribe
        public max_time
        public preempt_mode
        public state
        public def_mem_per_cpu
        public max_mem_per_cpu
        public def_mem_per_node
        public max_mem_per_node
        public max_cpus_per_node
        public max_nodes
        public min_nodes
        public over_time_limit
        public tres
        readonly resume_timeout
        readonly suspend_timeout
        readonly cr_type
        readonly name
        readonly total_cpus
        readonly total_nodes
        readonly cluster_name

    def __cinit__(self, name, **opts):
        # Initialize like slurm_init_part_desc_msg
        # Useful for the update function
        self.default_time = slurm.NO_VAL
        self.def_mem_per_cpu = slurm.NO_VAL64
        self.grace_time = slurm.NO_VAL
        self.max_cpus_per_node = slurm.NO_VAL
        self.max_mem_per_cpu = slurm.NO_VAL64
        self.max_nodes = slurm.NO_VAL
        self.min_nodes = slurm.NO_VAL
        self.max_time = slurm.NO_VAL
        self.over_time_limit = slurm.NO_VAL16
        self.priority_tier = slurm.NO_VAL16
        self.priority_job_factor = slurm.NO_VAL16
        self.state = slurm.NO_VAL16
        self.preempt_mode = slurm.NO_VAL16

    def __init__(self, name, **opts):
        if name.casefold() == "default":
            raise ValueError("PartitionName can't be 'DEFAULT'")
        self.name = name

        for k, v in opts.items():
            setattr(self, k, v)

    def dict(self):
        out = {}
        for a in dir(self):
            attr = getattr(self, a)
            if not a.startswith("_") and not callable(attr):
                out.update({a: attr})

        return out

    @staticmethod
    def get():
        cdef:
            slurm.partition_info_msg_t *part_info_ptr = NULL
            slurm.partition_info_t *record = NULL
            uint32_t i
            dict partitions = {}

        _load_part_info(&part_info_ptr, slurm.SHOW_ALL)

        record = part_info_ptr.partition_array
        for i in range(part_info_ptr.record_count):

            p = _parse_record(&record[i])
            partitions.update({ p.name: p })

        _free_part_info(part_info_ptr)

        return partitions

    def update(self, **changes):
        cdef slurm.update_part_msg_t record
        slurm.slurm_init_part_desc_msg(&record)

        # Either don't do anything if no changes
        # specified or maybe throw error.
        if not changes:
            return

        # Only update what is explicitly requested
        # Prevents useless work for controller
        tmp = Partition(self.name, **changes)
        _parse_args(&record, tmp)

        if slurm.slurm_update_partition(&record):
            raise ValueError(common.get_last_slurm_error())

        # Apply changes if successful
        for k, v in changes.items():
            setattr(self, k, v)

    def create(self):
        cdef slurm.update_part_msg_t record
        slurm.slurm_init_part_desc_msg(&record)

        _parse_args(&record, self)

        if slurm.slurm_create_partition(&record):
            raise ValueError(common.get_last_slurm_error())

    def delete(self):
        cdef slurm.delete_part_msg_t del_msg

        memset(&del_msg, 0, sizeof(del_msg))
        del_msg.name = self.name

        if slurm.slurm_delete_partition(&del_msg):
            raise ValueError(common.get_last_slurm_error())

    def disable_sched(self):
        self.update(state="down")

    def disable_submit(self):
        self.update(state="drain")


cdef _free_part_info(slurm.partition_info_msg_t *part_info_ptr):
    if part_info_ptr is not NULL:
        slurm.slurm_free_partition_info_msg(part_info_ptr)
        part_info_ptr = NULL


cdef int _load_part_info(slurm.partition_info_msg_t **part_info_ptr,
                         uint16_t flags) except? -1:
    cdef:
        slurm.partition_info_msg_t *new_part_ptr = NULL
        int rc = slurm.SLURM_SUCCESS
        slurm.time_t last_update = 0

    rc = slurm.slurm_load_partitions(last_update, &new_part_ptr, flags)

    if rc != slurm.SLURM_SUCCESS:
        _free_part_info(new_part_ptr)
        raise ValueError(common.get_last_slurm_error())

    part_info_ptr[0] = new_part_ptr


cdef _check_time(v):
    if v is None or v == slurm.NO_VAL:
        return slurm.NO_VAL

    time = slurm.slurm_time_str2mins(str(v))

    if time < 0 and time != slurm.INFINITE:
        raise ValueError("Invalid Time Value {:s}", str(v))

    return time


cdef _parse_time(uint32_t time):
    cdef char time_line[32]

    if time == slurm.NO_VAL:
        return None
    elif time != slurm.INFINITE:
        slurm.slurm_secs2time_str(
            time * 60,
            time_line,
            sizeof(time_line)
            )

        return time_line
    else:
        return "unlimited"


cdef _parse_mem(uint64_t mem):
    if mem & slurm.MEM_PER_CPU:
        if mem != slurm.MEM_PER_CPU:
            return (mem & (~slurm.MEM_PER_CPU))
    elif mem != 0:
        return mem
    else:
        return "unlimited"


cdef int _parse_args(slurm.update_part_msg_t *msg, src) except? -1:

    msg.name                = to_charptr(src.name)
    msg.alternate           = to_charptr(src.alternate)
    msg.max_time            = _check_time(src.max_time)
    msg.default_time        = _check_time(src.default_time)
    msg.max_cpus_per_node   = inf32(src.max_cpus_per_node)
    msg.max_nodes           = src.max_nodes
    msg.min_nodes           = src.min_nodes
    msg.over_time_limit     = inf16(src.over_time_limit)
    msg.priority_job_factor = src.priority_job_factor
    msg.priority_tier       = src.priority_tier
    msg.nodes               = to_charptr(src.nodes)
    msg.allow_groups        = to_charptr(src.allow_groups)
    msg.allow_qos           = to_charptr(src.allow_qos)
    msg.deny_qos            = to_charptr(src.deny_qos)
    msg.deny_accounts       = to_charptr(src.allow_accounts)
    msg.deny_accounts       = to_charptr(src.deny_accounts)
    msg.allow_alloc_nodes   = to_charptr(src.allow_alloc_nodes)
    msg.grace_time          = src.grace_time
    msg.def_mem_per_cpu     = inf64(src.def_mem_per_cpu) | slurm.MEM_PER_CPU
    msg.max_mem_per_cpu     = inf64(src.max_mem_per_cpu) | slurm.MEM_PER_CPU
    # msg.def_mem_per_cpu = inf64(v)
    # msg.max_mem_per_cpu = inf64(v)
    # msg.preempt_mode = .. TODO
    # msg.job_defaults_str = TODO
    # msg.tres_billing_weights = TODO

    if src.state == "inactive":
        msg.state_up = slurm.PARTITION_INACTIVE
    elif src.state == "down":
        msg.state_up = slurm.PARTITION_DOWN
    elif src.state == "up":
        msg.state_up = slurm.PARTITION_UP
    elif src.state == "drain":
        msg.state_up = slurm.PARTITION_DRAIN
    else:
        # Error?
        pass

    if src.oversubscribe:
        oversub = str(src.oversubscribe).split(":")
        mode = oversub[0].casefold()
        shares = None if not len(oversub) else int(oversub[1])

        if mode == "no":
            msg.max_share = 1

        elif mode == "exclusive":
            msg.max_share = 0

        elif mode == "yes":
            if shares:
                msg.max_share = shares
            else:
                msg.max_share = 4

        elif mode == "force":
            if shares:
                msg.max_share = shares | slurm.SHARED_FORCE
            else:
                msg.max_share = 4 | slurm.SHARED_FORCE
        else:
            # Error?
            pass

    # Parse Flags
    if src.is_default:
        msg.flags |= slurm.PART_FLAG_DEFAULT
    elif src.is_default is not None:
        msg.flags |= slurm.PART_FLAG_DEFAULT_CLR

    if src.disable_root_jobs:
        msg.flags |= slurm.PART_FLAG_NO_ROOT
    elif src.disable_root_jobs is not None:
        msg.flags |= slurm.PART_FLAG_NO_ROOT_CLR

    if src.exclusive_user:
        msg.flags |= slurm.PART_FLAG_EXCLUSIVE_USER
    elif src.exclusive_user is not None:
        msg.flags |= slurm.PART_FLAG_EXC_USER_CLR

    if src.root_only:
        msg.flags |= slurm.PART_FLAG_ROOT_ONLY
    elif src.root_only is not None:
        msg.flags |= slurm.PART_FLAG_ROOT_ONLY_CLR

    if src.lln:
        msg.flags |= slurm.PART_FLAG_LLN
    elif src.lln is not None:
        msg.flags |= slurm.PART_FLAG_LLN_CLR

    if src.hidden:
        msg.flags |= slurm.PART_FLAG_HIDDEN
    elif src.hidden is not None:
        msg.flags |= slurm.PART_FLAG_HIDDEN_CLR

    if src.req_resv:
        msg.flags |= slurm.PART_FLAG_REQ_RESV
    elif src.req_resv is not None:
        msg.flags |= slurm.PART_FLAG_REQ_RESV_CLR


cdef _parse_record(slurm.partition_info_t *info):
    cdef char cpu_bind[128]

    # Create Partition Instance
    p                     = Partition(name=to_unicode(info.name))
    p.allow_groups        = to_unicode(info.allow_groups, "all")
    p.allow_accounts      = to_unicode(info.allow_accounts, "all")
    p.deny_accounts       = to_unicode(info.deny_accounts, "")
    p.allow_qos           = to_unicode(info.allow_qos, "all")
    p.deny_qos            = to_unicode(info.deny_qos, "all")
    p.allow_alloc_nodes   = to_unicode(info.allow_alloc_nodes, "all")
    p.alternate           = to_unicode(info.alternate)
    p.qos                 = to_unicode(info.qos_char)
    p.max_nodes           = from_uint32(info.max_nodes, on_inf="unlimited")
    p.min_nodes           = from_uint32(info.min_nodes, 1)
    p.max_cpus_per_node   = from_uint32(info.max_cpus_per_node, on_inf="unlimited")
    p.priority_job_factor = info.priority_job_factor
    p.priority_tier       = info.priority_tier
    p.grace_time          = info.grace_time
    p.total_cpus          = info.total_cpus
    p.total_nodes         = info.total_nodes
    p.cr_type             = slurm.select_type_param_string(info.cr_type)
    p.max_time            = _parse_time(info.max_time)
    p.default_time        = _parse_time(info.default_time)
    p.over_time_limit     = from_uint16(info.over_time_limit)
    p.def_mem_per_cpu     = _parse_mem(info.def_mem_per_cpu)
    p.def_mem_per_node    = _parse_mem(info.def_mem_per_cpu)
    p.max_mem_per_cpu     = _parse_mem(info.max_mem_per_cpu)
    p.max_mem_per_node    = _parse_mem(info.max_mem_per_cpu)
    p.nodes               = to_unicode(info.nodes, "").split(",")
    p.is_default          = flag16_2_bool(info.flags, slurm.PART_FLAG_DEFAULT)
    p.disable_root_jobs   = flag16_2_bool(info.flags, slurm.PART_FLAG_NO_ROOT)
    p.exclusive_user      = flag16_2_bool(info.flags, slurm.PART_FLAG_EXCLUSIVE_USER)
    p.lln                 = flag16_2_bool(info.flags, slurm.PART_FLAG_LLN)
    p.root_only           = flag16_2_bool(info.flags, slurm.PART_FLAG_ROOT_ONLY)
    p.req_resv            = flag16_2_bool(info.flags, slurm.PART_FLAG_REQ_RESV)

    if info.cpu_bind:
        slurm.slurm_sprint_cpu_bind_type(
            cpu_bind,
            <slurm.cpu_bind_type_t>info.cpu_bind
        )
        p.cpu_bind = cpu_bind.split(",")

    force = info.max_share & slurm.SHARED_FORCE
    val = info.max_share & (~slurm.SHARED_FORCE)
    if val == 0:
        p.oversubscribe = "exclusive"
    elif force:
        p.oversubscribe = "force:{:d}".format(val)
    elif val != 1:
        p.oversubscribe = "yes:{:d}".format(val)

    if info.preempt_mode == slurm.NO_VAL16:
        # TODO: Load from config
        pass

    if info.state_up == slurm.PARTITION_UP:
        p.state = "up"
    elif info.state_up == slurm.PARTITION_DOWN:
        p.state = "down"
    elif info.state_up == slurm.PARTITION_INACTIVE:
        p.state = "inactive"
    elif info.state_up == slurm.PARTITION_DRAIN:
        p.state = "drain"
    else:
        p.state = "unknown"

    # TODO:
    # p.job_defaults =
    # p.tres

    if info.billing_weights_str:
        p.billing_weights = info.billing_weights_str

    return p

