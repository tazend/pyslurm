# cython: c_string_type=unicode, c_string_encoding=utf8

from grp import getgrgid
from pwd import getpwuid

cdef int conf_list_2_dict(dict conf, slurm.List conf_list) except? -1:
    cdef:
        slurm.ListIterator list_iter = NULL
        slurm.config_key_pair_t *conf_key_pair = NULL
        int list_count = 0
        int i = 0
        dict conf_dict = {}

    list_count = slurm.slurm_list_count(conf_list)

    if conf_list is not NULL and list_count:
        list_iter = slurm.slurm_list_iterator_create(conf_list)

        for i in range(list_count):

            conf_key_pair = <slurm.config_key_pair_t *>slurm.slurm_list_next(list_iter)
            name = conf_key_pair.name.decode()

            if conf_key_pair.value is not NULL:
                value = conf_key_pair.value.decode()

                if value == "(null)":
                    value = None
            else:
                value = None

            conf_dict[name] = value

        slurm.slurm_list_iterator_destroy(list_iter)

    conf.clear()
    conf.update(conf_dict)

cdef void free_ctl_conf(slurm.slurm_conf_t *conf_ptr):
    if conf_ptr is not NULL:
        slurm.slurm_free_ctl_conf(conf_ptr)
        conf_ptr = NULL

cdef int load_slurm_conf(slurm.slurm_conf_t **conf_ptr) except? -1:
    cdef:
        int rc = slurm.SLURM_SUCCESS
        slurm.slurm_conf_t *new_conf_ptr = NULL

        # We don't really care giving this in as input here
        # so it can just be 0
        slurm.time_t last_update = 0

    rc = slurm.slurm_load_ctl_conf(last_update, &new_conf_ptr)

    if rc != slurm.SLURM_SUCCESS:
        free_ctl_conf(new_conf_ptr)
        raise ValueError(get_last_slurm_error())

    conf_ptr[0] = new_conf_ptr


def errno_2_str(errno):
    return to_unicode(slurm.slurm_strerror(errno))


def get_last_slurm_error():
    rc = slurm.slurm_get_errno()

    if rc == slurm.SLURM_SUCCESS:
        return (rc, 'Success')
    else:
        return (rc, errno_2_str(rc))


def inf16(val):
    if not val or val == "unlimited":
        return slurm.INFINITE16
    else:
        return val


def inf32(val):
    if not val or val == "unlimited":
        return slurm.INFINITE
    else:
        return val


def inf64(val):
    if not val or val == "unlimited":
        return slurm.INFINITE64
    else:
        return val


cdef char *to_charptr(s):
    """Convert Unicode to char*"""
    if s and len(s):
        return s
    else:
        return NULL


cdef to_unicode(char *s, default=None):
    """Convert a char* to Unicode"""
    if s and s[0] != "\0":
        if s == <bytes>"None":
            return None

        return s
    else:
        return default


cdef flag16_2_bool(uint16_t flags, uint16_t flag):
    if flags & flag:
        return True
    else:
        return False


def from_uint16(val, on_inf=None, on_noval=None, noval=slurm.NO_VAL16):
    if val == noval:
        return on_noval
    elif val == slurm.INFINITE16:
        return on_inf
    else:
        return val


def from_uint32(val, on_inf=None, on_noval=None, noval=slurm.NO_VAL):
    if val == noval:
        return on_noval
    elif val == slurm.INFINITE:
        return on_inf
    else:
        return val


def from_uint64(val, on_inf=None, on_noval=None, noval=slurm.NO_VAL64):
    if val == noval:
        return on_noval
    elif val == slurm.INFINITE64:
        return on_inf
    else:
        return val


cdef char *list_2_charptr(vals, delim=","):
    if vals and len(vals):
        return to_charptr(delim.join(vals))
    else:
        return NULL


cdef charptr_2_list(char *vals, delim=","):
    ret = to_unicode(vals, "")
    return ret.split(delim)


def secs2time_str(val, default=None, noval=slurm.NO_VAL):
    """Parse Time in Seconds to SLURM Timestring Representation"""
    cdef char time_line[32]

    if val == noval:
        return default
    elif val != slurm.INFINITE:
        slurm.slurm_secs2time_str(
            <uint32_t>val,
            time_line,
            sizeof(time_line)
            )

        return to_unicode(time_line)
    else:
        return "unlimited"


def mins2time_str(val, default=None, noval=slurm.NO_VAL):
    """Parse Time in Minutes to SLURM Timestring Representation"""
    cdef char time_line[32]

    if val == noval:
        return default
    elif val != slurm.INFINITE:
        slurm.slurm_mins2time_str(
            <uint32_t>val,
            time_line,
            sizeof(time_line)
            )

        return to_unicode(time_line)
    else:
        return "unlimited"


cdef make_time_str(time_t *time):
    cdef char time_str[32]

    # slurm_make_time_str returns 'Unknown' if 0 or slurm.INFINITE
    slurm.slurm_make_time_str(time, time_str, sizeof(time_str))

    return to_unicode(time_str)


cdef get_job_std(slurm.slurm_job_info_t *job, what):
    # go with 1024 maxpathlen for now
    cdef char tmp_path[1024]

    if what == "stdout":
        slurm.slurm_get_job_stdout(tmp_path, sizeof(tmp_path), job)
    elif what == "stderr":
        slurm.slurm_get_job_stderr(tmp_path, sizeof(tmp_path), job)
    elif what == "stdin":
        slurm.slurm_get_job_stdin(tmp_path, sizeof(tmp_path), job)
    else:
        return None

    return to_unicode(tmp_path)


def uid2name(uid):
    try:
        name = getpwuid(uid).pw_name
        return name
    except KeyError:
        return None


def gid2name(gid):
    try:
        name = getgrgid(gid).gr_name
        return name
    except KeyError:
        return None
