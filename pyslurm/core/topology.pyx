#########################################################################
# topology.pyx - slurm topology api
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

from typing import Union, Any
from pyslurm.utils import cstr
from pyslurm.utils.uint import u32_parse, u16_parse
from pyslurm import settings
from pyslurm import xcollections
from pyslurm.utils.helpers import instance_to_dict
from pyslurm.utils.enums import SlurmEnum
from pyslurm.core.error import RPCError, verify_rpc


class TopologyType(SlurmEnum):
    DEFAULT = "DEFAULT", slurm.TOPOLOGY_PLUGIN_DEFAULT
    TORUS3D = "TORUS3D", slurm.TOPOLOGY_PLUGIN_3DTORUS
    TREE    = "TREE",    slurm.TOPOLOGY_PLUGIN_TREE
    BLOCK   = "BLOCK",   slurm.TOPOLOGY_PLUGIN_BLOCK


cdef class Topology(dict):

    def __dealloc__(self):
        slurm_free_topo_info_msg(self.info)
        self.info = NULL

    def __cinit__(self):
        self.info = NULL

    def __init__(self, entries=None):
        super().__init__()

    @staticmethod
    def load():
        """Load all Reservations in the system.

        Returns:
            (pyslurm.Reservations): Collection of [pyslurm.Reservation][]
                objects.

        Raises:
            (pyslurm.RPCError): When getting all the Reservations from the
                slurmctld failed.
        """
        cdef:
            Topology entries = Topology()
            dynamic_plugin_data_t *info = NULL

        verify_rpc(slurm_load_topo(&entries.info))

        info = entries.info.topo_info
        if info.plugin_id == TopologyType.TREE._flag:
            entries._process_tree_topo()
            entries._type = TopologyType.TREE
        elif info.plugin_id == TopologyType.BLOCK._flag:
            entries._process_block_topo()
            entries._type = TopologyType.BLOCK

        return entries

    def _process_tree_topo(self):
        cdef:
            topo_info_tree_response_msg_t *info = <topo_info_tree_response_msg_t*>self.info.topo_info.data
            TopologyTreeEntry entry

        if not info:
            return

        memset(&self.tree_tmp_info, 0, sizeof(topo_info_t))
        for cnt in range(info.record_count):
            entry = TopologyTreeEntry.from_ptr(&info.topo_array[cnt])
            info.topo_array[cnt] =  self.tree_tmp_info
            self[entry.switch_name] = entry

        info.record_count = 0

    def _process_block_topo(self):
        cdef:
            topo_info_block_response_msg_t *info = <topo_info_block_response_msg_t*>self.info.topo_info.data
            TopologyBlockEntry entry

        if not info:
            return

        memset(&self.block_tmp_info, 0, sizeof(topo_info_block_t))
        for cnt in range(info.record_count):
            entry = TopologyBlockEntry.from_ptr(&info.topo_array[cnt])
            info.topo_array[cnt] =  self.block_tmp_info
            self[entry.name] = entry

        info.record_count = 0

    @property
    def type(self):
        return self._type


cdef class TopologyTreeEntry:

    def __cinit__(self):
        self.ptr = NULL

    def __init__(self, name=None, **kwargs):
        self._alloc_impl()
        self.name = name
        self.cluster = settings.LOCAL_CLUSTER
        for k, v in kwargs.items():
            setattr(self, k, v)

    def _alloc_impl(self):
        if not self.ptr:
            self.ptr = <topo_info_t*>try_xmalloc(sizeof(topo_info_t))
            if not self.ptr:
                raise MemoryError("xmalloc failed for topo_info_t")

    def __dealloc__(self):
        xfree(self.ptr.name)
        xfree(self.ptr.nodes)
        xfree(self.ptr.switches)
        xfree(self.ptr)

    def __repr__(self):
        return f'pyslurm.{self.__class__.__name__}({self.switch_name})'

    @staticmethod
    cdef TopologyTreeEntry from_ptr(topo_info_t *in_ptr):
        cdef TopologyTreeEntry wrap = TopologyTreeEntry.__new__(TopologyTreeEntry)
        wrap._alloc_impl()
        wrap.cluster = settings.LOCAL_CLUSTER
        memcpy(wrap.ptr, in_ptr, sizeof(topo_info_t))
        return wrap

    def to_dict(self):
        """Reservation information formatted as a dictionary.

        Returns:
            (dict): Reservation information as dict

        Examples:
            >>> import pyslurm
            >>> resv = pyslurm.Reservation.load("maintenance")
            >>> resv_dict = resv.to_dict()
            >>> print(resv_dict)
        """
        return instance_to_dict(self)

    @property
    def switch_name(self):
        return cstr.to_unicode(self.ptr.name)

    @property
    def switches(self):
        return cstr.to_unicode(self.ptr.switches)

    @property
    def nodes(self):
        return cstr.to_unicode(self.ptr.nodes)

    @property
    def link_speed(self):
        return u32_parse(self.ptr.link_speed, zero_is_noval=False)

    @property
    def level(self):
        return u32_parse(self.ptr.level, zero_is_noval=False)


cdef class TopologyBlockEntry:

    def __cinit__(self):
        self.ptr = NULL

    def __init__(self):
        pass

    def _alloc_impl(self):
        if not self.ptr:
            self.ptr = <topo_info_block_t*>try_xmalloc(sizeof(topo_info_block_t))
            if not self.ptr:
                raise MemoryError("xmalloc failed for topo_info_block_t")

    def __dealloc__(self):
        xfree(self.ptr.name)
        xfree(self.ptr.nodes)
        xfree(self.ptr)

    def __repr__(self):
        return f'pyslurm.{self.__class__.__name__}({self.name})'

    @staticmethod
    cdef TopologyBlockEntry from_ptr(topo_info_block_t *in_ptr):
        cdef TopologyBlockEntry wrap = TopologyBlockEntry.__new__(TopologyBlockEntry)
        wrap._alloc_impl()
        wrap.cluster = settings.LOCAL_CLUSTER
        memcpy(wrap.ptr, in_ptr, sizeof(topo_info_block_t))
        return wrap

    def to_dict(self):
        """Reservation information formatted as a dictionary.

        Returns:
            (dict): Reservation information as dict

        Examples:
            >>> import pyslurm
            >>> resv = pyslurm.Reservation.load("maintenance")
            >>> resv_dict = resv.to_dict()
            >>> print(resv_dict)
        """
        return instance_to_dict(self)

    @property
    def name(self):
        return cstr.to_unicode(self.ptr.name)

    @property
    def nodes(self):
        return cstr.to_unicode(self.ptr.nodes)

    @property
    def index(self):
        return u16_parse(self.ptr.block_index, zero_is_noval=False)

    @property
    def is_aggregated(self):
        return self.ptr.aggregated

    @property
    def size(self):
        return self.ptr.size
