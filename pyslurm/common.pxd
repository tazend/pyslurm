cimport slurm
from libc.stdint cimport uint16_t, uint32_t, uint64_t

cdef extern from 'time.h' nogil:
    ctypedef long time_t
    double difftime(time_t time1, time_t time2)
    time_t time(time_t *t)

cdef int conf_list_2_dict(dict, slurm.List) except? -1
cdef int load_slurm_conf(slurm.slurm_conf_t **conf_ptr) except? -1
cdef void free_ctl_conf(slurm.slurm_conf_t *conf_ptr)
cdef char *list_2_charptr(vals, delim=*)
cdef charptr_2_list(char *vals, delim=*)
cdef flag16_2_bool(uint16_t flags, uint16_t flag)
cdef char *to_charptr(s)
cdef to_unicode(char *s, default=*)
cdef make_time_str(time_t *time)
cdef get_job_std(slurm.slurm_job_info_t *job, what)
