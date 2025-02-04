#########################################################################
# frontend.pyx - slurm frontend api
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
from pyslurm.utils import ctime
from pyslurm.utils.uint import u32_parse
from pyslurm import settings
from pyslurm import xcollections
from pyslurm.utils.helpers import instance_to_dict, uid_to_name
from pyslurm.core.node import _node_state_from_str
from pyslurm.utils.ctime import _raw_time
from pyslurm.core.error import RPCError verify_rpc


cdef class Frontends(dict):

    def __dealloc__(self):
        slurm_free_front_end_info_msg(self.info)
        self.info = NULL

    def __cinit__(self):
        self.info = NULL

    def __init__(self):
        super().__init__()

    @staticmethod
    def load():
        """Load all Frontends in the system.

        Returns:
            (pyslurm.Frontends): Collection of [pyslurm.Frontend][]
                objects.

        Raises:
            (pyslurm.RPCError): When getting all the Frontends from the
                slurmctld failed.
        """
        cdef:
            Frontends frontends = Frontends()
            Frontend frontend

        verify_rpc(slurm_load_front_end(0, &frontends.info))

        memset(&frontends.tmp_info, 0, sizeof(front_end_info_t))
        for cnt in range(frontends.info.record_count):
            frontend = Frontend.from_ptr(&frontends.info.front_end_array[cnt])
            frontends.info.front_end_array[cnt] = frontends.tmp_info
            frontends[frontend.name] = frontend

        frontends.info.record_count = 0
        return frontends



cdef class Frontend:

    def __cinit__(self):
        self.info = NULL
        self.umsg = NULL

    def __init__(self, name=None, **kwargs):
        self._alloc_impl()
        self.name = name
        self.cluster = settings.LOCAL_CLUSTER
        for k, v in kwargs.items():
            setattr(self, k, v)

    def _alloc_impl(self):
        self._alloc_info()
        self._alloc_umsg()

    def _alloc_info(self):
        if not self.info:
            self.info = <front_end_info_t*>try_xmalloc(sizeof(front_end_info_t))
            if not self.info:
                raise MemoryError("xmalloc failed for front_end_info_t")

    def _alloc_umsg(self):
        if not self.umsg:
            self.umsg = <update_front_end_msg_t*>try_xmalloc(sizeof(update_front_end_msg_t))
            if not self.umsg:
                raise MemoryError("xmalloc failed for update_front_end_msg_t")
            slurm_init_update_front_end_msg(self.umsg)

    def _dealloc_umsg(self):
        slurm_free_update_front_end_msg(self.umsg)
        self.umsg = NULL

    def _dealloc_impl(self):
        self._dealloc_umsg()
        slurm_free_front_end_info_members(self.info)
        xfree(self.info)
        self.info = NULL

    def __dealloc__(self):
        self._dealloc_impl()

    def __setattr__(self, name, val):
        self._alloc_umsg()
        Frontend.__dict__[name].__set__(self, val)

    def __repr__(self):
        return f'pyslurm.{self.__class__.__name__}({self.name})'

    @staticmethod
    cdef Frontend from_ptr(front_end_info_t *in_ptr):
        cdef Frontend wrap = Frontend.__new__(Frontend)
        wrap._alloc_info()
        wrap.cluster = settings.LOCAL_CLUSTER
        memcpy(wrap.info, in_ptr, sizeof(front_end_info_t))
        return wrap

    def _error_or_name(self):
        if not self.name:
            raise RPCError(msg="No Frontend name was specified. "
                           "Did you set the `name` attribute on the "
                           "Frontend instance?")
        return self.name

    def to_dict(self):
        """Frontend information formatted as a dictionary.

        Returns:
            (dict): Frontend information as dict

        Examples:
            >>> import pyslurm
            >>> frontend = pyslurm.Frontend.load("frontend")
            >>> frontend_dict = frontend.to_dict()
            >>> print(frontend_dict)
        """
        return instance_to_dict(self)

    @staticmethod
    def load(name):
        """Load information for a specific Frontend.

        Args:
            name (str):
                The name of the Frontend to load.

        Returns:
            (pyslurm.Frontend): Returns a new Frontend instance.

        Raises:
            (pyslurm.RPCError): If requesting the Frontend information from
                the slurmctld was not successful.

        Examples:
            >>> import pyslurm
            >>> frontend = pyslurm.Frontend.load("frontend-node")
        """
        frontend = Frontends.load().get(name)
        if not frontend:
            raise RPCError(msg=f"Frontend '{name}' doesn't exist")

        return frontend

    def modify(self, Frontend changes=None):
        """Modify a Frontend.

        Args:
            changes (pyslurm.Frontend, optional=None):
                Another Frontend object that contains all the changes to
                apply. This is optional - you can also directly modify a
                Frontend object and just call `modify()`, and the changes
                will be sent to `slurmctld`.

        Raises:
            (pyslurm.RPCError): When updating the Frontend was not
                successful.

        Examples:
            >>> import pyslurm
            >>>
            >>> frontend = pyslurm.Frontend.load("frontend-node1")
            >>> frontend.state = "DRAIN"
            >>> frontend.reason = "A Problem"
            >>>
            >>> # Now send the changes to the Controller:
            >>> frontend.modify()
        """
        cdef Frontend updates = changes if changes is not None else self
        if not updates.umsg:
            return

        updates._alloc_umsg()
        cstr.fmalloc(&updates.umsg.name, self._error_or_name())
        verify_rpc(slurm_update_front_end(updates.umsg))

        # Make sure we clean the object from any previous changes.
        updates._dealloc_umsg()

    @property
    def name(self):
        return cstr.to_unicode(self.info.name)

    @name.setter
    def name(self, val):
        cstr.fmalloc2(&self.info.name, &self.umsg.name, val)

    @property
    def denied_groups(self):
        return cstr.to_list(self.ptr.deny_groups, ["ALL"])

    @property
    def denied_users(self):
        return cstr.to_list(self.ptr.deny_users, ["ALL"])

    @property
    def allowed_groups(self):
        return cstr.to_list(self.ptr.allow_groups, ["ALL"])

    @property
    def allowed_users(self):
        return cstr.to_list(self.ptr.allow_users, ["ALL"])

    @property
    def boot_time(self):
        return _raw_time(self.info.boot_time)

    @property
    def reason_time(self):
        return _raw_time(self.info.reason_time)

    @property
    def reason(self):
        return cstr.to_unicode(self.info.reason)

    @reason.setter
    def reason(self, val):
        cstr.fmalloc2(&self.info.reason, &self.umsg.reason, val)

    @property
    def reason_user(self):
        return uid_to_name(self.info.reason_uid, err_on_invalid=False)

    @property
    def slurmd_start_time(self):
        return _raw_time(self.info.slurmd_start_time)

    @property
    def slurm_version(self):
        return cstr.to_unicode(self.info.version)

    @property
    def _node_state(self):
        idle_cpus = self.idle_cpus
        state = self.info.node_state

        if idle_cpus and idle_cpus != self.effective_cpus:
            # If we aren't idle but also not allocated, then set state to
            # MIXED.
            state &= slurm.NODE_STATE_FLAGS
            state |= slurm.NODE_STATE_MIXED

        return state

    @property
    def state(self):
        cdef char* state = slurm_node_state_string_complete(self._node_state)
        state_str = cstr.to_unicode(state)
        xfree(state)
        return state_str

    @state.setter
    def state(self, val):
        self.umsg.node_state = self.info.node_state = _node_state_from_str(val)
