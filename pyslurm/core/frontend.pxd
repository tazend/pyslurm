#########################################################################
# reservation.pxd - interface to work with reservations in slurm
#########################################################################
# Copyright (C) 2025 Toni Harzendorf <toni.harzendorf@gmail.com>
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

from libc.string cimport memcpy, memset
from libc.stdint cimport uint8_t, uint16_t, uint32_t, uint64_t
from libc.stdlib cimport free
from pyslurm cimport slurm
from pyslurm.slurm cimport (
    front_end_info_t,
    front_end_info_msg_t,
    update_front_end_msg_t,
    slurm_free_front_end_info_msg,
    slurm_load_front_end,
    slurm_update_front_end,
    slurm_init_update_front_end_msg,
    slurm_node_state_string_complete,
    xfree,
    try_xmalloc,
)
from pyslurm.utils cimport cstr
from pyslurm.utils cimport ctime
from pyslurm.utils.ctime cimport time_t
from pyslurm.utils.uint cimport (
    u32,
    u32_parse,
    u64_parse_bool_flag,
    u64_set_bool_flag,
)
from pyslurm.xcollections cimport MultiClusterMap


cdef extern void slurm_free_update_front_end_msg(update_front_end_msg_t *msg)
cdef extern void slurm_free_front_end_info_members(front_end_info_t *front_end)


cdef class Frontends(dict):
    cdef:
        front_end_info_msg_t *info
        front_end_info_t tmp_info


cdef class Frontend:
    cdef:
        front_end_info_t *info
        update_front_end_msg_t *umsg

    cdef readonly cluster

    @staticmethod
    cdef Frontend from_ptr(front_end_info_t *in_ptr)
