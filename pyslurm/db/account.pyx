#########################################################################
# account.pyx - pyslurm slurmdbd account api
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

from pyslurm.core.error import RPCError
from pyslurm.utils.helpers import (
    instance_to_dict,
    user_to_uid,
)
from pyslurm.utils.uint import *
from pyslurm.db.connection import _open_conn_or_error
from pyslurm import settings
from pyslurm import xcollections


cdef class Accounts(MultiClusterMap):

    def __init__(self, accounts=None):
        super().__init__(data=accounts,
                         typ="Accounts",
                         val_type=Account,
                         id_attr=Account.name,
                         key_type=str)

    @staticmethod
    def load(AccountFilter db_filter=None, Connection db_connection=None):
        cdef:
            Accounts out = Accounts()
            Account account
            AccountFilter cond = db_filter
            SlurmList account_data
            SlurmListItem account_ptr
            Connection conn
            SlurmList assoc_data
            SlurmListItem assoc_ptr
            Association assoc
            QualitiesOfService qos_data
            TrackableResources tres_data

        if not db_filter:
            cond = AccountFilter()

        if cond.with_assocs is not False:
            cond.with_assocs = True

        cond._create()

        conn = _open_conn_or_error(db_connection)

        account_data = SlurmList.wrap(slurmdb_accounts_get(conn.ptr, cond.ptr))

        if account_data.is_null:
            raise RPCError(msg="Failed to get Account data from slurmdbd.")

        qos_data = QualitiesOfService.load(db_connection=conn,
                                           name_is_key=False)
        tres_data = TrackableResources.load(db_connection=conn,
                                            name_is_key=False)

        for account_ptr in SlurmList.iter_and_pop(account_data):
            account = Account.from_ptr(<slurmdb_account_rec_t*>account_ptr.data)

            cluster = account.cluster
            if cluster not in out.data:
                out.data[cluster] = {}
            out.data[cluster][account.name] = account

            assoc_data = SlurmList.wrap(account.ptr.assoc_list, owned=False)
            for assoc_ptr in SlurmList.iter_and_pop(assoc_data):
                assoc = Association.from_ptr(<slurmdb_assoc_rec_t*>assoc_ptr.data)
                assoc.qos_data = qos_data
                assoc.tres_data = tres_data
                _parse_assoc_ptr(assoc)
                account.associations.append(assoc)

        return out


cdef class AccountFilter:

    def __cinit__(self):
        self.ptr = NULL

    def __init__(self, **kwargs):
        for k, v in kwargs.items():
            setattr(self, k, v)

    def __dealloc__(self):
        self._dealloc()

    def _dealloc(self):
        slurmdb_destroy_account_cond(self.ptr)
        self.ptr = NULL

    def _alloc(self):
        self._dealloc()
        self.ptr = <slurmdb_account_cond_t*>try_xmalloc(sizeof(slurmdb_account_cond_t))
        if not self.ptr:
            raise MemoryError("xmalloc failed for slurmdb_account_cond_t")

        memset(self.ptr, 0, sizeof(slurmdb_account_cond_t))

        self.ptr.assoc_cond = <slurmdb_assoc_cond_t*>try_xmalloc(sizeof(slurmdb_assoc_cond_t))
        if not self.ptr.assoc_cond:
            raise MemoryError("xmalloc failed for slurmdb_assoc_cond_t")

    def _parse_flag(self, val, flag_val):
        if val:
            self.ptr.flags |= flag_val

    def _create(self):
        self._alloc()
        cdef slurmdb_account_cond_t *ptr = self.ptr

        make_char_list(&ptr.assoc_cond.acct_list, self.names)
        self._parse_flag(self.with_assocs, slurm.SLURMDB_ACCT_FLAG_WASSOC)
        self._parse_flag(self.with_deleted, slurm.SLURMDB_ACCT_FLAG_DELETED)
        self._parse_flag(self.with_coordinators, slurm.SLURMDB_ACCT_FLAG_WCOORD)


cdef class Account:

    def __cinit__(self):
        self.ptr = NULL

    def __init__(self, name=None, **kwargs):
        self._alloc_impl()
        self.name = name
        self._init_defaults()
        for k, v in kwargs.items():
            setattr(self, k, v)

    def _init_defaults(self):
        self.cluster = settings.LOCAL_CLUSTER
        self.associations = []
        self.coordinators = []

    def __dealloc__(self):
        self._dealloc_impl()

    def _dealloc_impl(self):
        slurmdb_destroy_account_rec(self.ptr)
        self.ptr = NULL

    def _alloc_impl(self):
        if not self.ptr:
            self.ptr = <slurmdb_account_rec_t*>try_xmalloc(
                    sizeof(slurmdb_account_rec_t))
            if not self.ptr:
                raise MemoryError("xmalloc failed for slurmdb_account_rec_t")

            memset(self.ptr, 0, sizeof(slurmdb_account_rec_t))

    def __repr__(self):
        return f'pyslurm.db.{self.__class__.__name__}({self.name})'

    @staticmethod
    cdef Account from_ptr(slurmdb_account_rec_t *in_ptr):
        cdef Account wrap = Account.__new__(Account)
        wrap.ptr = in_ptr
        wrap._init_defaults()
        return wrap

    def to_dict(self):
        """Database Account information formatted as a dictionary.

        Returns:
            (dict): Database Account information as dict.
        """
        return instance_to_dict(self)

    def __eq__(self, other):
        if isinstance(other, Account):
            return self.name == other.name and self.cluster == other.cluster
        return NotImplemented

    @property
    def name(self):
        return cstr.to_unicode(self.ptr.name)

    @property
    def description(self):
        return cstr.to_unicode(self.ptr.description)

    @property
    def organization(self):
        return cstr.to_unicode(self.ptr.organization)

    @property
    def is_deleted(self):
        if self.ptr.flags & slurm.SLURMDB_ACCT_FLAG_DELETED:
            return True
        return False

    # TODO: extract the association of this account
