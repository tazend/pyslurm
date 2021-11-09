cimport slurm
cimport common
from libc.stdint cimport uint8_t, uint16_t, uint32_t, uint64_t
import common

def takeover(int backup_ctl=1):
    cdef:
        slurm.slurm_conf_t *conf_ptr = NULL
        int rc = slurm.SLURM_SUCCESS
        uint16_t ctl_cnt = 0

    common.load_slurm_conf(&conf_ptr)
    ctl_cnt = conf_ptr.control_cnt
    common.free_ctl_conf(conf_ptr)

    if ctl_cnt <= 1:
        raise ValueError("No Backup controller configured.")

    if backup_ctl < 1 or backup_ctl >= ctl_cnt:
        raise ValueError("Invalid backup controller index.")

    rc = slurm.slurm_takeover(backup_ctl)

    if rc != slurm.SLURM_SUCCESS:
        err = common.errno_2_str(rc)
        raise ValueError(rc, err)

    return rc

def reconfigure():
    cdef:
        int rc = slurm.SLURM_SUCCESS

    rc = slurm.slurm_reconfigure()

    if rc != slurm.SLURM_SUCCESS:
        raise ValueError(rc, common.errno_2_str(rc))

    return rc

def print_config():
    pass

def config():
    cdef:
        slurm.slurm_conf_t *conf_ptr = NULL
        slurm.time_t last_update = 0
        slurm.List conf_list = NULL
        dict conf = {}
        dict general = {}
        dict cgroup = {}
        dict acct_gather = {}
        dict plugstack = {}
        dict ext_sensor = {}
        dict select = {}
        dict node_features = {}

    # Load the slurm config
    common.load_slurm_conf(&conf_ptr)
    last_update = conf_ptr.last_update

    # Convert config to key/value pairs
    conf_list = <slurm.List>slurm.slurm_ctl_conf_2_key_pairs(conf_ptr)

    # Parse Configs
    common.conf_list_2_dict(general, conf_list)
    common.conf_list_2_dict(cgroup, <slurm.List>conf_ptr.cgroup_conf)
    common.conf_list_2_dict(acct_gather, <slurm.List>conf_ptr.acct_gather_conf)
    common.conf_list_2_dict(ext_sensor, <slurm.List>conf_ptr.ext_sensors_conf)
    common.conf_list_2_dict(node_features, <slurm.List>conf_ptr.node_features_conf)
    common.conf_list_2_dict(plugstack, <slurm.List>conf_ptr.slurmctld_plugstack_conf)
    common.conf_list_2_dict(select, <slurm.List>conf_ptr.select_conf_key_pairs)

    # Organize config
    conf.update({ "general": general })
    conf.update({ "cgroup": cgroup })
    conf.update({ "acct_gather": acct_gather })
    conf.update({ "ext_sensor": ext_sensor })
    conf.update({ "node_features": node_features })
    conf.update({ "plugstack": plugstack })
    conf.update({ "select" : select })

    conf["general"]["LastUpdate"] = last_update

    # Free config related stuff
    slurm.FREE_NULL_LIST(conf_list)
    common.free_ctl_conf(conf_ptr)

    return conf

def ping(int controller=0):
    cdef:
        slurm.slurm_conf_t *conf_ptr = NULL
        int rc = slurm.SLURM_SUCCESS
        uint16_t ctl_cnt = 0

    common.load_slurm_conf(&conf_ptr)
    ctl_cnt = conf_ptr.control_cnt

    common.free_ctl_conf(conf_ptr)

    # Need to make sure that slurm_ping calls with a valid
    # index, otherwise program might crash
    if controller < 0 or controller >= ctl_cnt:
        raise ValueError("Specified Controller doesn't exist.")

    rc = slurm.slurm_ping(controller)
    err = common.errno_2_str(rc)

    return (rc, err)

def shutdown(int option=0):
    cdef:
        int rc = slurm.SLURM_SUCCESS

    if option < 0 or option > 2:
        raise ValueError("Specified options is not valid")

    rc = slurm.slurm_shutdown(option)

    if rc != slurm.SLURM_SUCCESS:
        raise ValueError(rc, common.errno_2_str(rc))

    return rc

def abort():
    return(shutdown(1))

def set_debug_level(str debug_level):
    cdef:
        int rc = slurm.SLURM_SUCCESS
        dict levels = {
            "quiet": 0,
            "fatal": 1,
            "error": 2,
            "info": 3,
            "verbose": 4,
            "debug": 5,
            "debug2": 6,
            "debug3": 7,
            "debug4": 8,
            "debug5": 9,
        }

    rc = slurm.slurm_set_debug_level(levels[debug_level])

    if rc != slurm.SLURM_SUCCESS:
        err = common.errno_2_str(rc)
        raise ValueError(rc, err)

    return rc

def toggle_schedlog(enable=False):
    cdef:
        int rc = slurm.SLURM_SUCCESS
        str err = "No Error"

    # It will set the errno
    slurm.slurm_set_schedlog_level(int(enable == True))

    rc, err = common.get_last_slurm_error()

    if rc != slurm.SLURM_SUCCESS:
        raise ValueError(rc, err)

    return rc

def set_debug_flags(list to_add, list to_remove):
    cdef:
        uint64_t debug_flags_plus = 0
        uint64_t debug_flags_minus = 0
        uint64_t flags = 0
        int rc = slurm.SLURM_SUCCESS

    for f in to_add:
        if slurm.debug_str2flags(f.encode('UTF-8'), &flags) != rc:
            raise ValueError("Wrong debug flag")

        debug_flags_plus |= flags

    for f in to_remove:
        if slurm.debug_str2flags(f.encode('UTF-8'), &flags) != rc:
            raise ValueError("Wrong debug flag")

        debug_flags_minus |= flags


    rc = slurm.slurm_set_debugflags(debug_flags_plus,
                                    debug_flags_minus)

    if rc != slurm.SLURM_SUCCESS:
        raise ValueError(rc, common.errno_2_str(rc))

    return rc

