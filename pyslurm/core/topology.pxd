#########################################################################
# topology.pxd - slurm topology api
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
from libcpp cimport bool
from pyslurm cimport slurm
from pyslurm.slurm cimport (
    topo_info_t,
    topo_info_response_msg_t,
    slurm_free_topo_info_msg,
    dynamic_plugin_data_t,
    slurm_load_topo,
    xfree,
    try_xmalloc,
)

from pyslurm.utils cimport cstr


ctypedef struct topo_info_tree_response_msg_t:
    uint32_t record_count
    topo_info_t *topo_array


ctypedef struct topo_info_block_response_msg_t:
    uint32_t record_count
    topo_info_block_t *topo_array


ctypedef struct topo_info_block_t:
    bool aggregated
    uint16_t block_index
    char *name
    char *nodes
    uint32_t size


cdef class Topology(dict):
    """A [`Multi Cluster`][pyslurm.xcollections.MultiClusterMap] collection of [pyslurm.Reservation][] objects.

    Args:
        reservations (Union[list[str], dict[str, pyslurm.Reservation], str], optional=None):
            Reservations to initialize this collection with.
    """
    cdef:
        topo_info_response_msg_t *info
        topo_info_t tree_tmp_info
        topo_info_block_t block_tmp_info
        _type


cdef class TopologyTreeEntry:
    """A Topology Tree Entry in the Slurm topology.conf."""
    cdef:
        topo_info_t *ptr

    cdef readonly cluster

    @staticmethod
    cdef TopologyTreeEntry from_ptr(topo_info_t *in_ptr)


cdef class TopologyBlockEntry:
    """A Topology Block Entry in the Slurm topology.conf."""
    cdef:
        topo_info_block_t *ptr

    cdef readonly cluster

    @staticmethod
    cdef TopologyBlockEntry from_ptr(topo_info_block_t *in_ptr)
