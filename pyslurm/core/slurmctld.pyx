#########################################################################
# slurmctld.pyx - pyslurm slurmctld api
#########################################################################
# Copyright (C) 2024 Toni Harzendorf <toni.harzendorf@gmail.com>
#
# This file is part of PySlurm
#
# PySlurm is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.

# PySlurm is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with PySlurm; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
#
# cython: c_string_type=unicode, c_string_encoding=default
# cython: language_level=3

from pyslurm.core.error import verify_rpc, RPCError
from pyslurm.utils.uint import *
from pyslurm.utils.ctime import _raw_time
from pyslurm.core.job.util import cpu_freq_int_to_str
from pyslurm.utils.helpers import instance_to_dict
from pyslurm.utils import cstr


cdef class Config:

    def __cinit__(self):
        self.ptr = NULL

    def __init__(self, job_id):
        raise RuntimeError("Cannot instantiate class directly")

    def __dealloc__(self):
        slurm_free_ctl_conf(self.ptr)
        self.ptr = NULL

    @staticmethod
    def load():
        cdef Config conf = Config.__new__(Config)
        verify_rpc(slurm_load_ctl_conf(0, &conf.ptr))
        return conf

    def as_dict(self):
        """Slurmctld config formatted as a dictionary.

        Returns:
            (dict): slurmctld config as a dict

        Examples:
            >>> import pyslurm
            >>> config = pyslurm.slurmctld.Config.load()
            >>> config_dict = config.as_dict()
        """
        return instance_to_dict(self)

    # https://github.com/SchedMD/slurm/blob/76158287e5376d72fcfdcc0f6b036ee5a9fb94e5/slurm/slurm.h#L2804
    # Keep in order

    @property
    def accounting_storage_tres(self):
        return cstr.to_list(self.ptr.accounting_storage_tres)

    @property
    def accounting_storage_enforce(self):
        cdef char tmp[128]
        slurm_accounting_enforce_string(self.ptr.accounting_storage_enforce,
                                        tmp, sizeof(tmp))
        out = cstr.to_unicode(tmp)
        if not out or out == "none":
            return []

        return out.upper().split(",")

    @property
    def accounting_storage_backup_host(self):
        return cstr.to_unicode(self.ptr.accounting_storage_backup_host)

    @property
    def accounting_storage_external_hosts(self):
        return cstr.to_list(self.ptr.accounting_storage_ext_host)

    @property
    def accounting_storage_host(self):
        return cstr.to_list(self.ptr.accounting_storage_host)

    @property
    def accounting_storage_parameters(self):
        return cstr.to_dict(self.ptr.accounting_storage_params)

    @property
    def accounting_storage_password(self):
        return cstr.to_unicode(self.ptr.accounting_storage_pass)

    @property
    def accounting_storage_port(self):
        return u16_parse(self.ptr.accounting_storage_port)

    @property
    def accounting_storage_type(self):
        return cstr.to_unicode(self.ptr.accounting_storage_type)

    @property
    def accounting_storage_user(self):
        return cstr.to_unicode(self.ptr.accounting_storage_user)

    # TODO: void *acct_gather_conf put into own class?

    @property
    def accounting_gather_energy_type(self):
        return cstr.to_unicode(self.ptr.acct_gather_energy_type)

    @property
    def accounting_gather_profile_type(self):
        return cstr.to_unicode(self.ptr.acct_gather_profile_type)

    @property
    def accounting_gather_interconnect_type(self):
        return cstr.to_unicode(self.ptr.acct_gather_interconnect_type)

    @property
    def accounting_gather_filesystem_type(self):
        return cstr.to_unicode(self.ptr.acct_gather_filesystem_type)

    @property
    def accounting_gather_node_frequency(self):
        return u16_parse(self.ptr.acct_gather_node_freq)

    @property
    def auth_alt_types(self):
        # ?
        return cstr.to_list(self.ptr.authalttypes)

    @property
    def auth_info(self):
        # ?
        return cstr.to_list(self.ptr.authinfo)

    @property
    def auth_alt_params(self):
        # ?
        return cstr.to_list(self.ptr.authalt_params)

    @property
    def auth_type(self):
        return cstr.to_unicode(self.ptr.authtype)

    @property
    def batch_start_timeout(self):
        # seconds
        return u16_parse(self.ptr.batch_start_timeout)

    @property
    def burst_buffer_type(self):
        return cstr.to_unicode(self.ptr.bb_type)

    @property
    def bcast_exclude_paths(self):
        return cstr.to_list(self.ptr.bcast_exclude)

    @property
    def bcast_parameters(self):
        return cstr.to_list(self.ptr.bcast_parameters)

    @property
    def boot_time(self):
        return _raw_time(self.ptr.boot_time)

    # TODO: void *cgroup_conf put into own class?

    @property
    def cli_filter_plugins(self):
        return cstr.to_list(self.ptr.cli_filter_plugins)

    @property
    def core_spec_plugin(self):
        return cstr.to_unicode(self.ptr.core_spec_plugin)

    @property
    def cluster_name(self):
        return cstr.to_unicode(self.ptr.cluster_name)

    @property
    def communication_parameters(self):
        return cstr.to_list(self.ptr.comm_params)

    @property
    def complete_wait_time(self):
        # seconds
        return u16_parse(self.ptr.complete_wait)

    # TODO: conf_flags?
    # TODO: **control_addr
    # TODO: **control_machine

    @property
    def default_cpu_frequency(self):
        return cpu_freq_int_to_str(self.ptr.cpu_freq_def)

#    TODO
#    @property
#    def cpu_frequency_governors(self):
#        pass

    @property
    def credential_type(self):
        return cstr.to_unicode(self.ptr.cred_type)

    @property
    def debug_flags(self):
        return _debug_flags_int_to_list(self.ptr.debug_flags)

    @property
    def default_memory_per_cpu(self):
        return _get_memory(self.ptr.def_mem_per_cpu, per_cpu=True)

    @property
    def default_memory_per_node(self):
        return _get_memory(self.ptr.def_mem_per_cpu, per_cpu=False)

    @property
    def dependency_parameters(self):
        return cstr.to_list(self.ptr.dependency_params)

    @property
    def eio_timeout(self):
        # seconds
        return u16_parse(self.ptr.eio_timeout)

    @property
    def enforce_partition_limits(self):
        return _enforce_part_limits_int_to_str(self.ptr.enforce_part_limits)

    @property
    def epilog(self):
        return cstr.to_unicode(self.ptr.epilog)

    @property
    def epilog_msg_time(self):
        # ms
        return u32_parse(self.ptr.epilog_msg_time)

    @property
    def epilog_slurmctld(self):
        return cstr.to_unicode(self.ptr.epilog_slurmctld)

    @property
    def external_sensors_type(self):
        return cstr.to_unicode(self.ptr.ext_sensors_type)

    @property
    def external_sensors_frequency(self):
        return u16_parse(self.ptr.ext_sensors_freq)

    # TODO: void *ext_sensors_conf put into own class?

    @property
    def federation_parameters(self):
        return cstr.to_list(self.ptr.fed_params)

    @property
    def first_job_id(self):
        return u32_parse(self.ptr.first_job_id)

    @property
    def fair_share_dampening_factor(self):
        return u16_parse(self.ptr.fs_dampening_factor)

    # getnameinfo_cache_timeout

    @property
    def get_environment_timeout(self):
        return u16_parse(self.ptr.get_env_timeout)

    @property
    def gres_types(self):
        return cstr.to_list(self.ptr.gres_plugins)

    @property
    def group_update_time(self):
        return u16_parse(self.ptr.group_time)

    @property
    def group_update_force(self):
        return u16_parse_bool(self.ptr.group_force)

    @property
    def default_gpu_frequency(self):
        return cstr.to_unicode(self.ptr.gpu_freq_def)

    # TODO: hash_val

    @property
    def health_check_interval(self):
        return u16_parse(self.ptr.health_check_interval)

    @property
    def health_check_node_state(self):
        return _health_check_node_state_int_to_list(
                self.ptr.health_check_node_state)

    @property
    def health_check_program(self):
        return cstr.to_unicode(self.ptr.health_check_program)

    @property
    def inactive_limit(self):
        # seconds
        return u16_parse(self.ptr.inactive_limit)

    @property
    def interactive_step_options(self):
        return cstr.to_unicode(self.ptr.interactive_step_opts)

    @property
    def job_accounting_gather_frequency(self):
        return cstr.to_dict(self.ptr.job_acct_gather_freq)

    @property
    def job_accounting_gather_type(self):
        return cstr.to_unicode(self.ptr.job_acct_gather_type)

    @property
    def job_accounting_gather_parameters(self):
        return cstr.to_list(self.ptr.job_acct_gather_params)

    # TODO: job_acct_oom_kill

    @property
    def job_completion_host(self):
        return cstr.to_unicode(self.ptr.job_comp_host)

    @property
    def job_completion_location(self):
        return cstr.to_unicode(self.ptr.job_comp_loc)

    @property
    def job_completion_parameters(self):
        return cstr.to_list(self.ptr.job_comp_params)

#    @property
#    def job_completion_password(self):
#        return cstr.to_unicode(self.ptr.job_comp_pass)

    @property
    def job_completion_port(self):
        return u32_parse(self.ptr.job_comp_port)

    @property
    def job_completion_type(self):
        return cstr.to_unicode(self.ptr.job_comp_type)

    @property
    def job_completion_user(self):
        return cstr.to_unicode(self.ptr.job_comp_user)

    @property
    def job_container_type(self):
        return cstr.to_unicode(self.ptr.job_container_plugin)

#    @property
#    def default_cpus_per_gpu(self):
#       TODO: parse job_defaults_list

    @property
    def job_file_append(self):
        return u16_parse_bool(self.ptr.job_file_append)

    @property
    def job_requeue(self):
        return u16_parse_bool(self.ptr.job_requeue)

    @property
    def job_submit_plugins(self):
        return cstr.to_list(self.ptr.job_submit_plugins)

    @property
    def keepalive_interval(self):
        return u32_parse(self.ptr.keepalive_interval)

    @property
    def keepalive_probes(self):
        return u32_parse(self.ptr.keepalive_probes)

    @property
    def keepalive_time(self):
        return u32_parse(self.ptr.keepalive_time)

    @property
    def kill_on_bad_exit(self):
        return u16_parse_bool(self.ptr.kill_on_bad_exit)

    @property
    def kill_wait(self):
        # seconds
        return u16_parse(self.ptr.kill_wait)

    @property
    def launch_parameters(self):
        return cstr.to_list(self.ptr.launch_params)

    @property
    def licenses(self):
        return cstr.to_dict(self.ptr.licenses, delim1=",",
                            delim2=":", def_value=1)

    @property
    def log_time_format(self):
        return _log_fmt_int_to_str(self.ptr.log_fmt)

    @property
    def mail_domain(self):
        return cstr.to_unicode(self.ptr.mail_domain)

    @property
    def mail_program(self):
        return cstr.to_unicode(self.ptr.mail_prog)

    @property
    def max_array_size(self):
        return u32_parse(self.ptr.max_array_sz)

    @property
    def max_batch_requeue(self):
        return u32_parse(self.ptr.max_batch_requeue)

    @property
    def max_dbd_msgs(self):
        return u32_parse(self.ptr.max_dbd_msgs)

    @property
    def max_job_count(self):
        return u32_parse(self.ptr.max_job_cnt)

    @property
    def max_job_id(self):
        return u32_parse(self.ptr.max_job_id)

    @property
    def max_memory_per_cpu(self):
        return _get_memory(self.ptr.max_mem_per_cpu, per_cpu=True)

    @property
    def max_memory_per_node(self):
        return _get_memory(self.ptr.max_mem_per_cpu, per_cpu=False)

    @property
    def max_node_count(self):
        return u32_parse(self.ptr.max_node_cnt)

    @property
    def max_step_count(self):
        return u32_parse(self.ptr.max_step_cnt)

    @property
    def max_tasks_per_node(self):
        return u32_parse(self.ptr.max_tasks_per_node)

    @property
    def mcs_plugin(self):
        return cstr.to_unicode(self.ptr.mcs_plugin)

    @property
    def mcs_parameters(self):
        return cstr.to_list(self.ptr.mcs_plugin_params)

    @property
    def min_job_age(self):
        return u32_parse(self.ptr.min_job_age)

    # TODO: void *mpi_conf put into own class?

    @property
    def mpi_default(self):
        return cstr.to_unicode(self.ptr.mpi_default)

    @property
    def mpi_parameters(self):
        return cstr.to_unicode(self.ptr.mpi_params)

    @property
    def message_timeout(self):
        return u16_parse(self.ptr.msg_timeout)

    # TODO: u32 next_job_id

    # TODO: void *node_features_conf put into own class?

    @property
    def node_features_plugins(self):
        return cstr.to_list(self.ptr.node_features_plugins)

    # TODO: node_prefix

    @property
    def over_time_limit(self):
        return u16_parse(self.ptr.over_time_limit)

    @property
    def plugin_path(self):
        return cstr.to_unicode(self.ptr.plugindir)

    @property
    def plugin_stack_config(self):
        return cstr.to_unicode(self.ptr.plugstack)

    @property
    def power_parameters(self):
        return cstr.to_list(self.ptr.power_parameters)

    @property
    def power_plugin(self):
        return cstr.to_unicode(self.ptr.power_plugin)

    @property
    def preempt_exempt_time(self):
        # seconds?
        return _raw_time(self.ptr.preempt_exempt_time)

    @property
    def preempt_mode(self):
        cdef char *tmp = slurm_preempt_mode_string(self.ptr.preempt_mode)
        return cstr.to_unicode(tmp)

    @property
    def prep_parameters(self):
        return cstr.to_list(self.ptr.prep_params)

    @property
    def prep_plugins(self):
        return cstr.to_list(self.ptr.prep_plugins)

    @property
    def priority_decay_half_life(self):
        # seconds
        return u32_parse(self.ptr.priority_decay_hl)

    @property
    def priority_calc_period(self):
        # seconds
        return u32_parse(self.ptr.priority_calc_period)

    @property
    def priority_favor_small(self):
        return u16_parse_bool(self.ptr.priority_favor_small)

    @property
    def priority_flags(self):
        return _priority_flags_int_to_list(self.ptr.priority_flags)

    @property
    def priortiy_max_age(self):
        # seconds?
        return u32_parse(self.ptr.priority_max_age)

    @property
    def priority_parameters(self):
        return cstr.to_unicode(self.ptr.priority_params)

    @property
    def priority_usage_reset_period(self):
        return _priority_reset_int_to_str(self.ptr.priority_reset_period)

    @property
    def priority_type(self):
        return cstr.to_unicode(self.ptr.priority_type)

    @property
    def priority_weight_age(self):
        return u32_parse(self.ptr.priority_weight_age)

    @property
    def priority_weight_assoc(self):
        return u32_parse(self.ptr.priority_weight_assoc)

    @property
    def priority_weight_fair_share(self):
        return u32_parse(self.ptr.priority_weight_fs)

    @property
    def priority_weight_job_size(self):
        return u32_parse(self.ptr.priority_weight_js)

    @property
    def priority_weight_partition(self):
        return u32_parse(self.ptr.priority_weight_part)

    @property
    def priority_weight_qos(self):
        return u32_parse(self.ptr.priority_weight_qos)

    @property
    def priority_weight_tres(self):
        return cstr.to_dict(self.ptr.priority_weight_tres)

    @property
    def private_data(self):
        return _private_data_int_to_list(self.ptr.private_data)

    @property
    def proctrack_type(self):
        return cstr.to_unicode(self.ptr.proctrack_type)

    @property
    def prolog(self):
        return cstr.to_unicode(self.ptr.prolog)

    @property
    def prolog_epilog_timeout(self):
        # seconds
        return u16_parse(self.ptr.prolog_epilog_timeout)

    @property
    def prolog_slurmctld(self):
        return cstr.to_unicode(self.ptr.prolog_slurmctld)

    @property
    def propagate_prio_process(self):
        return u16_parse(self.ptr.propagate_prio_process, zero_is_noval=False)

    @property
    def prolog_flags(self):
        return _prolog_flags_int_to_list(self.ptr.prolog_flags)

    @property
    def propagate_resource_limits(self):
        return cstr.to_list(self.ptr.propagate_rlimits)

    @property
    def propagate_resource_limits_except(self):
        return cstr.to_list(self.ptr.propagate_rlimits_except)

    @property
    def reboot_program(self):
        return cstr.to_unicode(self.ptr.reboot_program)

    @property
    def reconfig_flags(self):
        return _reconfig_flags_int_to_list(self.ptr.reconfig_flags)

    @property
    def requeue_exit(self):
        return cstr.to_unicode(self.ptr.requeue_exit)

    @property
    def requeue_exit_hold(self):
        return cstr.to_unicode(self.ptr.requeue_exit_hold)

    @property
    def resume_fail_program(self):
        return cstr.to_unicode(self.ptr.resume_fail_program)

    @property
    def resume_program(self):
        return cstr.to_unicode(self.ptr.resume_program)

    @property
    def resume_rate(self):
        return u16_parse(self.ptr.resume_rate)

    @property
    def resume_timeout(self):
        return u16_parse(self.ptr.resume_timeout)

    @property
    def reservation_epilog(self):
        return cstr.to_unicode(self.ptr.resv_epilog)

    @property
    def reservation_over_run(self):
        # minutes
        return u16_parse(self.ptr.resv_over_run)

    @property
    def reservation_prolog(self):
        return cstr.to_unicode(self.ptr.resv_prolog)

    @property
    def return_to_service(self):
        return u16_parse(self.ptr.ret2service, zero_is_noval=False)

    @property
    def scheduler_log_file(self):
        return cstr.to_unicode(self.ptr.sched_logfile)

    @property
    def scheduler_log_level(self):
        return u16_parse(self.ptr.sched_log_level, zero_is_noval=False)

    @property
    def scheduler_parameters(self):
        return cstr.to_list(self.ptr.sched_params)

    @property
    def scheduler_time_slice(self):
        # seconds
        return u16_parse(self.ptr.sched_time_slice)

    @property
    def scheduler_type(self):
        return cstr.to_unicode(self.ptr.schedtype)

    @property
    def scron_parameters(self):
        return cstr.to_list(self.ptr.scron_params)

    @property
    def select_type(self):
        return cstr.to_unicode(self.ptr.select_type)

#    @property
#    def select_type_parameters(self):
#       TODO
#       pass

    @property
    def priority_site_factor_plugin(self):
        return cstr.to_unicode(self.ptr.site_factor_plugin)

    @property
    def priority_site_factor_parameters(self):
        return cstr.to_unicode(self.ptr.site_factor_params)

    @property
    def slurm_conf_path(self):
        return cstr.to_unicode(self.ptr.slurm_conf)

    @property
    def slurm_user_id(self):
        return self.ptr.slurm_user_id

    @property
    def slurm_user_name(self):
        return cstr.to_unicode(self.ptr.slurm_user_name)

    @property
    def slurmd_user_id(self):
        return self.ptr.slurm_user_id

    @property
    def slurmd_user_name(self):
        return cstr.to_unicode(self.ptr.slurmd_user_name)

    # TODO: char *slurmctld_addr

    @property
    def slurmctld_log_level(self):
        return _log_level_int_to_str(self.ptr.slurmctld_debug)

    @property
    def slurmctld_log_file(self):
        return cstr.to_unicode(self.ptr.slurmctld_logfile)

    @property
    def slurmctld_pid_file(self):
        return cstr.to_unicode(self.ptr.slurmctld_pidfile)

    @property
    def slurmctld_port(self):
        port = self.ptr.slurmctld_port
        if self.ptr.slurmctld_port_count > 1:
            # Slurmctld port can be a range actually, calculated by using the
            # number of ports in use that slurm conf reports for slurmctld
            last_port = port + self.ptr.slurmctld_port_count - 1
            port = f"{port}-{last_port}"

        return str(port)

    @property
    def slurmctld_primary_off_program(self):
        return cstr.to_unicode(self.ptr.slurmctld_primary_off_prog)

    @property
    def slurmctld_primary_on_program(self):
        return cstr.to_unicode(self.ptr.slurmctld_primary_on_prog)

    @property
    def slurmctld_syslog_level(self):
        return _log_level_int_to_str(self.ptr.slurmctld_syslog_debug)

    @property
    def slurmctld_timeout(self):
        # seconds
        return u16_parse(self.ptr.slurmctld_timeout)

    @property
    def slurmctld_parameters(self):
        return cstr.to_list(self.ptr.slurmctld_params)

    @property
    def slurmd_log_level(self):
        return _log_level_int_to_str(self.ptr.slurmd_debug)

    @property
    def slurmd_log_file(self):
        return cstr.to_unicode(self.ptr.slurmd_logfile)

    @property
    def slurmd_parameters(self):
        return cstr.to_list(self.ptr.slurmd_params)

    @property
    def slurmd_pid_file(self):
        return cstr.to_unicode(self.ptr.slurmd_pidfile)

    @property
    def slurmd_port(self):
        return self.ptr.slurmd_port

    @property
    def slurmd_spool_directory(self):
        return cstr.to_unicode(self.ptr.slurmd_spooldir)

    @property
    def slurmd_syslog_level(self):
        return _log_level_int_to_str(self.ptr.slurmd_syslog_debug)

    @property
    def slurmd_timeout(self):
        return u16_parse(self.ptr.slurmd_timeout)

    @property
    def srun_epilog(self):
        return cstr.to_unicode(self.ptr.srun_epilog)

    @property
    def srun_port_range(self):
        if not self.ptr.srun_port_range:
            return None

        low = self.ptr.srun_port_range[0]
        high = self.ptr.srun_port_range[0]
        return f"{low}-{high}"

    @property
    def srun_prolog(self):
        return cstr.to_unicode(self.ptr.srun_prolog)

    @property
    def state_save_location(self):
        return cstr.to_unicode(self.ptr.state_save_location)

    @property
    def suspend_exclude_nodes(self):
        return cstr.to_unicode(self.ptr.suspend_exc_nodes)

    @property
    def suspend_exclude_partitions(self):
        return cstr.to_unicode(self.ptr.suspend_exc_parts)

    @property
    def suspend_exclude_states(self):
        return cstr.to_list(self.ptr.suspend_exc_states)

    @property
    def suspend_program(self):
        return cstr.to_unicode(self.ptr.suspend_program)

    @property
    def suspend_rate(self):
        return u16_parse(self.ptr.suspend_rate)

    @property
    def suspend_time(self):
        return u32_parse(self.ptr.suspend_time)

    @property
    def suspend_timeout(self):
        return u16_parse(self.ptr.suspend_timeout)

    @property
    def switch_type(self):
        return cstr.to_unicode(self.ptr.switch_type)

    @property
    def switch_parameters(self):
        return cstr.to_list(self.ptr.switch_param)

    @property
    def task_epilog(self):
        return cstr.to_unicode(self.ptr.task_epilog)

    @property
    def task_plugin(self):
        return cstr.to_unicode(self.ptr.task_plugin)

#    @property
#    def task_plugin_parameters(self):
#        TODO: slurm_sprint_cpu_bind_type
#        return

    @property
    def task_prolog(self):
        return cstr.to_unicode(self.ptr.task_prolog)

    @property
    def tcp_timeout(self):
        return u16_parse(self.ptr.tcp_timeout)

    @property
    def temporary_filesystem(self):
        return cstr.to_unicode(self.ptr.tmp_fs)

    @property
    def topology_parameters(self):
        return cstr.to_list(self.ptr.topology_param)

    @property
    def topology_plugin(self):
        return cstr.to_unicode(self.ptr.topology_plugin)

    @property
    def tree_width(self):
        return u16_parse(self.ptr.tree_width)

    @property
    def unkillable_step_program(self):
        return cstr.to_unicode(self.ptr.unkillable_program)

    @property
    def unkillable_step_timeout(self):
        return u16_parse(self.ptr.unkillable_timeout)

    @property
    def version(self):
        return cstr.to_unicode(self.ptr.version)

    @property
    def virtual_memory_size_factor(self):
        return u16_parse(self.ptr.vsize_factor)

    @property
    def wait_time(self):
        return u16_parse(self.ptr.wait_time)

    @property
    def x11_parameters(self):
        return cstr.to_unicode(self.ptr.x11_params)


# Maybe at some point we can just use libslurmfull instead of having to
# implement these parser functions ourselves.

# https://github.com/SchedMD/slurm/blob/01a3aac7c59c9b32a9dd4e395aa5a97a8aea4f08/slurm/slurm.h#L2661
# Keep order and naming scheme in sync with:
# https://slurm.schedmd.com/slurm.conf.html#OPT_DebugFlags
def _debug_flags_int_to_list(flags):
    out = []

    if (flags & slurm.DEBUG_FLAG_ACCRUE):
        out.append('Accrue')

    if (flags & slurm.DEBUG_FLAG_AGENT):
        out.append('Agent')

    if (flags & slurm.DEBUG_FLAG_BACKFILL):
        out.append('Backfill')

    if (flags & slurm.DEBUG_FLAG_BACKFILL_MAP):
        out.append('BackfillMap')

    if (flags & slurm.DEBUG_FLAG_BURST_BUF):
        out.append('BurstBuffer')

    if (flags & slurm.DEBUG_FLAG_CGROUP):
        out.append('Cgroup')

    if (flags & slurm.DEBUG_FLAG_CPU_BIND):
        out.append('CPU_Bind')

    if (flags & slurm.DEBUG_FLAG_CPU_FREQ):
        out.append('CpuFrequency')

    if (flags & slurm.DEBUG_FLAG_DATA):
        out.append('Data')

    if (flags & slurm.DEBUG_FLAG_DEPENDENCY):
        out.append('Dependency')

    if (flags & slurm.DEBUG_FLAG_ENERGY):
        out.append('Energy')

    if (flags & slurm.DEBUG_FLAG_EXT_SENSORS):
        out.append('ExtSensors')

    if (flags & slurm.DEBUG_FLAG_FEDR):
        out.append('Federation')

    if (flags & slurm.DEBUG_FLAG_FRONT_END):
        out.append('FrontEnd')

    if (flags & slurm.DEBUG_FLAG_GRES):
        out.append('Gres')

    if (flags & slurm.DEBUG_FLAG_HETJOB):
        out.append('Hetjob')

    if (flags & slurm.DEBUG_FLAG_INTERCONNECT):
        out.append('Interconnect')

    if (flags & slurm.DEBUG_FLAG_GANG):
        out.append('Gang')

    if (flags & slurm.DEBUG_FLAG_JAG):
        out.append('JobAccountGather')

    if (flags & slurm.DEBUG_FLAG_JOBCOMP):
        out.append('JobComp')

    if (flags & slurm.DEBUG_FLAG_JOB_CONT):
        out.append('JobContainer')

    if (flags & slurm.DEBUG_FLAG_LICENSE):
        out.append('License')

    if (flags & slurm.DEBUG_FLAG_MPI):
        out.append('MPI')

    if (flags & slurm.DEBUG_FLAG_NET):
        out.append('Network')

    if (flags & slurm.DEBUG_FLAG_NET_RAW):
        out.append('NetworkRaw')

    if (flags & slurm.DEBUG_FLAG_NODE_FEATURES):
        out.append('NodeFeatures')

    if (flags & slurm.DEBUG_FLAG_NO_CONF_HASH):
        out.append('NO_CONF_HASH')

    if (flags & slurm.DEBUG_FLAG_POWER):
        out.append('Power')

    if (flags & slurm.DEBUG_FLAG_PRIO):
        out.append('Priority')

    if (flags & slurm.DEBUG_FLAG_PROFILE):
        out.append('Profile')

    if (flags & slurm.DEBUG_FLAG_PROTOCOL):
        out.append('Protocol')

    if (flags & slurm.DEBUG_FLAG_RESERVATION):
        out.append('Reservation')

    if (flags & slurm.DEBUG_FLAG_ROUTE):
        out.append('Route')

    if (flags & slurm.DEBUG_FLAG_SCRIPT):
        out.append('Script')

    if (flags & slurm.DEBUG_FLAG_SELECT_TYPE):
        out.append('SelectType')

    if (flags & slurm.DEBUG_FLAG_STEPS):
        out.append('Steps')

    if (flags & slurm.DEBUG_FLAG_SWITCH):
        out.append('Switch')

    if (flags & slurm.DEBUG_FLAG_TIME_CRAY):
        out.append('TimeCray')

    if (flags & slurm.DEBUG_FLAG_TRACE_JOBS):
        out.append('TraceJobs')

    if (flags & slurm.DEBUG_FLAG_TRIGGERS):
        out.append('Triggers')

    if (flags & slurm.DEBUG_FLAG_WORKQ):
        out.append('WorkQueue')

    return out


def _debug_flags_str_to_int(flags):
    pass


# https://github.com/SchedMD/slurm/blob/01a3aac7c59c9b32a9dd4e395aa5a97a8aea4f08/slurm/slurm.h#L621
def _enforce_part_limits_int_to_str(limits):
    if limits == slurm.PARTITION_ENFORCE_NONE:
        return "NONE"
    elif limits == slurm.PARTITION_ENFORCE_ALL:
        return "ALL"
    elif limits == slurm.PARTITION_ENFORCE_ANY:
        return "ANY"

    return None


# https://github.com/SchedMD/slurm/blob/01a3aac7c59c9b32a9dd4e395aa5a97a8aea4f08/slurm/slurm.h#L2741
def _health_check_node_state_int_to_list(state):
    out = []

    if state & slurm.HEALTH_CHECK_CYCLE:
        # Can be combined with states according to slurm conf docs
        out.append("CYCLE")

    if state & slurm.HEALTH_CHECK_NODE_ANY:
        # Can't be combined with the other states, since it includes them all.
        out.append("ANY")
        return out

    if state & slurm.HEALTH_CHECK_NODE_IDLE:
        out.append("IDLE")

    if state & slurm.HEALTH_CHECK_NODE_ALLOC:
        out.append("MIXED")

    if state & slurm.HEALTH_CHECK_NODE_MIXED:
        out.append("MIXED")

    if state & slurm.HEALTH_CHECK_NODE_NONDRAINED_IDLE:
        out.append("NONDRAINED_IDLE")

    return out


def _log_fmt_int_to_str(flag):
    if flag == slurm.LOG_FMT_ISO8601_MS:
        return "iso8601_ms"
    elif flag == slurm.LOG_FMT_ISO8601:
        return "iso8601"
    elif flag == slurm.LOG_FMT_RFC5424_MS:
        return "rfc5424_ms"
    elif flag == slurm.LOG_FMT_RFC5424:
        return "rfc5424"
    elif flag == slurm.LOG_FMT_CLOCK:
        return "clock"
    elif flag == slurm.LOG_FMT_SHORT:
        return "short"
    elif flag == slurm.LOG_FMT_THREAD_ID:
        return "thread_id"
    elif flag == slurm.LOG_FMT_RFC3339:
        return "rfc3339"
    else:
        return None


def _priority_flags_int_to_list(flags):
    # TODO
    return []


def _priority_reset_int_to_str(flags):
    # TODO
    return None


def _private_data_int_to_list(flags):
    # TODO
    return []


def _prolog_flags_int_to_list(flags):
    # TODO
    return []


def _reconfig_flags_int_to_list(flags):
    # TODO
    return []


def _log_level_int_to_str(flags):
    # TODO
    return None


def _get_memory(value, per_cpu):
    if value != slurm.NO_VAL64:
        if value & slurm.MEM_PER_CPU and per_cpu:
            if value == slurm.MEM_PER_CPU:
                return UNLIMITED
            return u64_parse(value & (~slurm.MEM_PER_CPU))

        # For these values, Slurm interprets 0 as being equal to
        # INFINITE/UNLIMITED
        elif value == 0 and not per_cpu:
            return UNLIMITED

        elif not value & slurm.MEM_PER_CPU and not per_cpu:
            return u64_parse(value)

    return None
