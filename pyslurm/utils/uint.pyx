#########################################################################
# common/uint.pyx - functions dealing with parsing uint types
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


cpdef u8(val, inf=False, noval=slurm.NO_VAL8, on_noval=slurm.NO_VAL8, zero_is_noval=True):
    """Try to convert arbitrary 'val' to uint8_t"""
    if val is None or (val == 0 and zero_is_noval) or val == noval:
        return on_noval
    elif inf and (val == "UNLIMITED" or val == "unlimited"):
        return slurm.INFINITE8
    else:
        if isinstance(val, str) and val.isdigit():
            return <uint8_t>int(val)

        return <uint8_t>val


cpdef u8_parse(uint8_t val, on_inf="UNLIMITED", on_noval=None, noval=slurm.NO_VAL8, zero_is_noval=True):
    """Convert uint8_t to Python int (with a few situational parameters)"""
    if val == noval or (val == 0 and zero_is_noval):
        return on_noval
    elif val == slurm.INFINITE8:
        return on_inf
    else:
        return val


cpdef u16(val, inf=False, noval=slurm.NO_VAL16, on_noval=slurm.NO_VAL16, zero_is_noval=True):
    """Try to convert arbitrary 'val' to uint16_t"""
    if val is None or (val == 0 and zero_is_noval) or val == noval:
        return on_noval
    elif inf and (val == "UNLIMITED" or val == "unlimited"):
        return slurm.INFINITE16
    else:
        if isinstance(val, str) and val.isdigit():
            return <uint16_t>int(val)

        return <uint16_t>val


cpdef u16_parse(uint16_t val, on_inf="UNLIMITED", on_noval=None, noval=slurm.NO_VAL16, zero_is_noval=True):
    """Convert uint16_t to Python int (with a few situational parameters)"""
    if val == noval or (val == 0 and zero_is_noval):
        return on_noval
    elif val == slurm.INFINITE16:
        return on_inf
    else:
        return val


cpdef u32(val, inf=False, noval=slurm.NO_VAL, on_noval=slurm.NO_VAL, zero_is_noval=True):
    """Try to convert arbitrary 'val' to uint32_t"""
    if val is None or (val == 0 and zero_is_noval) or val == noval:
        return on_noval
    elif inf and (val == "UNLIMITED" or val == "unlimited"):
        return slurm.INFINITE
    else:
        if isinstance(val, str) and val.isdigit():
            return <uint32_t>int(val)

        return <uint32_t>val


cpdef u32_parse(uint32_t val, on_inf="UNLIMITED", on_noval=None, noval=slurm.NO_VAL, zero_is_noval=True):
    """Convert uint32_t to Python int (with a few situational parameters)"""
    if val == noval or (val == 0 and zero_is_noval):
        return on_noval
    elif val == slurm.INFINITE:
        return on_inf
    else:
        return val


cpdef u64(val, inf=False, noval=slurm.NO_VAL64, on_noval=slurm.NO_VAL64, zero_is_noval=True):
    """Try to convert arbitrary 'val' to uint64_t"""
    if val is None or (val == 0 and zero_is_noval) or val == noval:
        return on_noval
    elif inf and (val == "UNLIMITED" or val == "unlimited"):
        return slurm.INFINITE64
    else:
        if isinstance(val, str) and val.isdigit():
            return <uint64_t>int(val)

        return <uint64_t>val


cpdef u64_parse(uint64_t val, on_inf="UNLIMITED", on_noval=None, noval=slurm.NO_VAL64, zero_is_noval=True):
    """Convert uint64_t to Python int (with a few situational parameters)"""
    if val == noval or (val == 0 and zero_is_noval):
        return on_noval
    elif val == slurm.INFINITE64:
        return on_inf
    else:
        return val


cpdef u8_bool(val):
    if val is None:
        return slurm.NO_VAL8
    elif val:
        return 1
    else:
        return 0


cpdef u16_bool(val):
    if val is None:
        return slurm.NO_VAL16
    elif val:
        return 1
    else:
        return 0


cdef u8_parse_bool(uint8_t val):
    if not val or val == slurm.NO_VAL8:
        return False 

    return True


cdef u16_parse_bool(uint16_t val):
    if not val or val == slurm.NO_VAL16:
        return False 

    return True


cdef u64_set_bool_flag(uint64_t *flags, boolean, flag_val):
    if boolean:
        flags[0] |= flag_val
    else:
        flags[0] &= ~flag_val


cdef u64_parse_bool_flag(uint64_t flags, flag):
    if flags == slurm.NO_VAL:
        return False

    if flags & flag:
        return True
    else:
        return False


cdef u16_set_bool_flag(uint16_t *flags, boolean, flag_val):
    if boolean:
        flags[0] |= flag_val
    else:
        flags[0] &= ~flag_val


cdef u16_parse_bool_flag(uint16_t flags, flag):
    if flags == slurm.NO_VAL16:
        return False

    if flags & flag:
        return True
    else:
        return False
