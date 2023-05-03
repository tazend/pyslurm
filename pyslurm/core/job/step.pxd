#########################################################################
# job/step.pxd - interface to retrieve slurm job step informations
#########################################################################
# Copyright (C) 2023 Toni Harzendorf <toni.harzendorf@gmail.com>
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

from libc.stdint cimport uint8_t, uint16_t, uint32_t, uint64_t
from .job cimport Job

from pyslurm cimport slurm
from pyslurm.slurm cimport (
    job_step_info_t,
    slurm_get_job_steps,
    job_step_info_response_msg_t,
    step_update_request_msg_t,
    slurm_free_job_step_info_response_msg,
    slurm_init_update_step_msg,
    slurm_free_update_step_msg,
    slurm_free_job_step_info_response_msg,
    slurm_free_job_step_info_members,
    slurm_update_step,
    slurm_signal_job_step,
    slurm_kill_job_step,
    slurm_job_state_string,
    xfree,
    try_xmalloc,
)

cdef class JobSteps(dict):
    """A collection of :obj:`JobStep` objects for a given Job.

    Args:
        job (Union[Job, int]):
            A Job for which the Steps should be loaded.

    Raises:
        RPCError: When getting the Job steps from the slurmctld failed.
        MemoryError: If malloc fails to allocate memory.
    """

    cdef:
        job_step_info_response_msg_t *info
        job_step_info_t tmp_info

    @staticmethod
    cdef JobSteps _load(Job job)

    cdef dict _get_info(self, uint32_t job_id, int flags)
        

cdef class JobStep:
    """A Slurm Jobstep

    Args:
        job (Union[Job, int], optional):
            The Job this Step belongs to.
        step (Union[int, str], optional):
            Step-ID for this JobStep object.

    Raises:
        MemoryError: If malloc fails to allocate memory.

    Attributes:
        id (Union[str, int]):
            The id for this step.
        job_id (int):
            The id for the Job this step belongs to.
        name (str):
            Name of the step.
        user_id (int):
            User ID who owns this step.
        user_name (str):
            Name of the User who owns this step.
        time_limit (int):
            Time limit in Minutes for this step.
        network (str):
            Network specification for the step.
        cpu_frequency_min (Union[str, int]):
            Minimum CPU-Frequency requested.
        cpu_frequency_max (Union[str, int]):
            Maximum CPU-Frequency requested.
        cpu_frequency_governor (Union[str, int]):
            CPU-Frequency Governor requested.
        reserved_ports (str):
            Reserved ports for the step.
        cluster (str):
            Name of the cluster this step runs on.
        srun_host (str):
            Name of the host srun was executed on.
        srun_process_id (int):
            Process ID of the srun command.
        container (str):
            Path to the container OCI.
        allocated_nodes (str):
            Nodes the Job is using.
        start_time (int):
            Time this step started, as unix timestamp.
        run_time (int):
            Seconds this step has been running for.
        partition (str):
            Name of the partition this step runs in.
        state (str):
            State the step is in.
        allocated_cpus (int):
            Number of CPUs this step uses in total.
        ntasks (int):
            Number of tasks this step uses.
        distribution (dict):
            Task distribution specification for the step.
        command (str):
            Command that was specified with srun.
        slurm_protocol_version (int):
            Slurm protocol version in use.
    """

    cdef:
        job_step_info_t *ptr
        step_update_request_msg_t *umsg

    @staticmethod
    cdef JobStep from_ptr(job_step_info_t *in_ptr)
