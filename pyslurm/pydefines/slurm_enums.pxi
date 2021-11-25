# EXPOSE slurm.h ENUMS TO PYTHON SPACE

# enum job_states

JOB_PENDING    = slurm.JOB_PENDING
JOB_RUNNING    = slurm.JOB_RUNNING
JOB_SUSPENDED  = slurm.JOB_SUSPENDED
JOB_COMPLETE   = slurm.JOB_COMPLETE
JOB_CANCELLED  = slurm.JOB_CANCELLED
JOB_FAILED     = slurm.JOB_FAILED
JOB_TIMEOUT    = slurm.JOB_TIMEOUT
JOB_NODE_FAIL  = slurm.JOB_NODE_FAIL
JOB_PREEMPTED  = slurm.JOB_PREEMPTED
JOB_BOOT_FAIL  = slurm.JOB_BOOT_FAIL
JOB_DEADLINE   = slurm.JOB_DEADLINE
JOB_OOM        = slurm.JOB_OOM
JOB_END        = slurm.JOB_END

# end enum job_states

# enum job_state_reason

WAIT_NO_REASON                          = slurm.WAIT_NO_REASON
WAIT_PRIORITY                           = slurm.WAIT_PRIORITY
WAIT_DEPENDENCY                         = slurm.WAIT_DEPENDENCY
WAIT_RESOURCES                          = slurm.WAIT_RESOURCES
WAIT_PART_NODE_LIMIT                    = slurm.WAIT_PART_NODE_LIMIT
WAIT_PART_TIME_LIMIT                    = slurm.WAIT_PART_TIME_LIMIT
WAIT_PART_DOWN                          = slurm.WAIT_PART_DOWN
WAIT_PART_INACTIVE                      = slurm.WAIT_PART_INACTIVE
WAIT_HELD                               = slurm.WAIT_HELD
WAIT_TIME                               = slurm.WAIT_TIME
WAIT_LICENSES                           = slurm.WAIT_LICENSES
WAIT_ASSOC_JOB_LIMIT                    = slurm.WAIT_ASSOC_JOB_LIMIT
WAIT_ASSOC_RESOURCE_LIMIT               = slurm.WAIT_ASSOC_RESOURCE_LIMIT
WAIT_ASSOC_TIME_LIMIT                   = slurm.WAIT_ASSOC_TIME_LIMIT
WAIT_RESERVATION                        = slurm.WAIT_RESERVATION
WAIT_NODE_NOT_AVAIL                     = slurm.WAIT_NODE_NOT_AVAIL
WAIT_HELD_USER                          = slurm.WAIT_HELD_USER
WAIT_FRONT_END                          = slurm.WAIT_FRONT_END
FAIL_DOWN_PARTITION                     = slurm.FAIL_DOWN_PARTITION
FAIL_DOWN_NODE                          = slurm.FAIL_DOWN_NODE
FAIL_BAD_CONSTRAINTS                    = slurm.FAIL_BAD_CONSTRAINTS
FAIL_SYSTEM                             = slurm.FAIL_SYSTEM
FAIL_LAUNCH                             = slurm.FAIL_LAUNCH
FAIL_EXIT_CODE                          = slurm.FAIL_EXIT_CODE
FAIL_TIMEOUT                            = slurm.FAIL_TIMEOUT
FAIL_INACTIVE_LIMIT                     = slurm.FAIL_INACTIVE_LIMIT
FAIL_ACCOUNT                            = slurm.FAIL_ACCOUNT
FAIL_QOS                                = slurm.FAIL_QOS
WAIT_QOS_THRES                          = slurm.WAIT_QOS_THRES
WAIT_QOS_JOB_LIMIT                      = slurm.WAIT_QOS_JOB_LIMIT
WAIT_QOS_RESOURCE_LIMIT                 = slurm.WAIT_QOS_RESOURCE_LIMIT
WAIT_QOS_TIME_LIMIT                     = slurm.WAIT_QOS_TIME_LIMIT
WAIT_BLOCK_MAX_ERR                      = slurm.WAIT_BLOCK_MAX_ERR
WAIT_BLOCK_D_ACTION                     = slurm.WAIT_BLOCK_D_ACTION
WAIT_CLEANING                           = slurm.WAIT_CLEANING
WAIT_PROLOG                             = slurm.WAIT_PROLOG
WAIT_QOS                                = slurm.WAIT_QOS
WAIT_ACCOUNT                            = slurm.WAIT_ACCOUNT
WAIT_DEP_INVALID                        = slurm.WAIT_DEP_INVALID
WAIT_QOS_GRP_CPU                        = slurm.WAIT_QOS_GRP_CPU
WAIT_QOS_GRP_CPU_MIN                    = slurm.WAIT_QOS_GRP_CPU_MIN
WAIT_QOS_GRP_CPU_RUN_MIN                = slurm.WAIT_QOS_GRP_CPU_RUN_MIN
WAIT_QOS_GRP_JOB                        = slurm.WAIT_QOS_GRP_JOB
WAIT_QOS_GRP_MEM                        = slurm.WAIT_QOS_GRP_MEM
WAIT_QOS_GRP_NODE                       = slurm.WAIT_QOS_GRP_NODE
WAIT_QOS_GRP_SUB_JOB                    = slurm.WAIT_QOS_GRP_SUB_JOB
WAIT_QOS_GRP_WALL                       = slurm.WAIT_QOS_GRP_WALL
WAIT_QOS_MAX_CPU_PER_JOB                = slurm.WAIT_QOS_MAX_CPU_PER_JOB
WAIT_QOS_MAX_CPU_MINS_PER_JOB           = slurm.WAIT_QOS_MAX_CPU_MINS_PER_JOB
WAIT_QOS_MAX_NODE_PER_JOB               = slurm.WAIT_QOS_MAX_NODE_PER_JOB
WAIT_QOS_MAX_WALL_PER_JOB               = slurm.WAIT_QOS_MAX_WALL_PER_JOB
WAIT_QOS_MAX_CPU_PER_USER               = slurm.WAIT_QOS_MAX_CPU_PER_USER
WAIT_QOS_MAX_JOB_PER_USER               = slurm.WAIT_QOS_MAX_JOB_PER_USER
WAIT_QOS_MAX_NODE_PER_USER              = slurm.WAIT_QOS_MAX_NODE_PER_USER
WAIT_QOS_MAX_SUB_JOB                    = slurm.WAIT_QOS_MAX_SUB_JOB
WAIT_QOS_MIN_CPU                        = slurm.WAIT_QOS_MIN_CPU
WAIT_ASSOC_GRP_CPU                      = slurm.WAIT_ASSOC_GRP_CPU
WAIT_ASSOC_GRP_CPU_MIN                  = slurm.WAIT_ASSOC_GRP_CPU_MIN
WAIT_ASSOC_GRP_CPU_RUN_MIN              = slurm.WAIT_ASSOC_GRP_CPU_RUN_MIN
WAIT_ASSOC_GRP_JOB                      = slurm.WAIT_ASSOC_GRP_JOB
WAIT_ASSOC_GRP_MEM                      = slurm.WAIT_ASSOC_GRP_MEM
WAIT_ASSOC_GRP_NODE                     = slurm.WAIT_ASSOC_GRP_NODE
WAIT_ASSOC_GRP_SUB_JOB                  = slurm.WAIT_ASSOC_GRP_SUB_JOB
WAIT_ASSOC_GRP_WALL                     = slurm.WAIT_ASSOC_GRP_WALL
WAIT_ASSOC_MAX_JOBS                     = slurm.WAIT_ASSOC_MAX_JOBS
WAIT_ASSOC_MAX_CPU_PER_JOB              = slurm.WAIT_ASSOC_MAX_CPU_PER_JOB
WAIT_ASSOC_MAX_CPU_MINS_PER_JOB         = slurm.WAIT_ASSOC_MAX_CPU_MINS_PER_JOB
WAIT_ASSOC_MAX_NODE_PER_JOB             = slurm.WAIT_ASSOC_MAX_NODE_PER_JOB
WAIT_ASSOC_MAX_WALL_PER_JOB             = slurm.WAIT_ASSOC_MAX_WALL_PER_JOB
WAIT_ASSOC_MAX_SUB_JOB                  = slurm.WAIT_ASSOC_MAX_SUB_JOB
WAIT_MAX_REQUEUE                        = slurm.WAIT_MAX_REQUEUE
WAIT_ARRAY_TASK_LIMIT                   = slurm.WAIT_ARRAY_TASK_LIMIT
WAIT_BURST_BUFFER_RESOURCE              = slurm.WAIT_BURST_BUFFER_RESOURCE
WAIT_BURST_BUFFER_STAGING               = slurm.WAIT_BURST_BUFFER_STAGING
FAIL_BURST_BUFFER_OP                    = slurm.FAIL_BURST_BUFFER_OP
WAIT_POWER_NOT_AVAIL                    = slurm.WAIT_POWER_NOT_AVAIL
WAIT_POWER_RESERVED                     = slurm.WAIT_POWER_RESERVED
WAIT_ASSOC_GRP_UNK                      = slurm.WAIT_ASSOC_GRP_UNK
WAIT_ASSOC_GRP_UNK_MIN                  = slurm.WAIT_ASSOC_GRP_UNK_MIN
WAIT_ASSOC_GRP_UNK_RUN_MIN              = slurm.WAIT_ASSOC_GRP_UNK_RUN_MIN
WAIT_ASSOC_MAX_UNK_PER_JOB              = slurm.WAIT_ASSOC_MAX_UNK_PER_JOB
WAIT_ASSOC_MAX_UNK_PER_NODE             = slurm.WAIT_ASSOC_MAX_UNK_PER_NODE
WAIT_ASSOC_MAX_UNK_MINS_PER_JOB         = slurm.WAIT_ASSOC_MAX_UNK_MINS_PER_JOB
WAIT_ASSOC_MAX_CPU_PER_NODE             = slurm.WAIT_ASSOC_MAX_CPU_PER_NODE
WAIT_ASSOC_GRP_MEM_MIN                  = slurm.WAIT_ASSOC_GRP_MEM_MIN
WAIT_ASSOC_GRP_MEM_RUN_MIN              = slurm.WAIT_ASSOC_GRP_MEM_RUN_MIN
WAIT_ASSOC_MAX_MEM_PER_JOB              = slurm.WAIT_ASSOC_MAX_MEM_PER_JOB
WAIT_ASSOC_MAX_MEM_PER_NODE             = slurm.WAIT_ASSOC_MAX_MEM_PER_NODE
WAIT_ASSOC_MAX_MEM_MINS_PER_JOB         = slurm.WAIT_ASSOC_MAX_MEM_MINS_PER_JOB
WAIT_ASSOC_GRP_NODE_MIN                 = slurm.WAIT_ASSOC_GRP_NODE_MIN
WAIT_ASSOC_GRP_NODE_RUN_MIN             = slurm.WAIT_ASSOC_GRP_NODE_RUN_MIN
WAIT_ASSOC_MAX_NODE_MINS_PER_JOB        = slurm.WAIT_ASSOC_MAX_NODE_MINS_PER_JOB
WAIT_ASSOC_GRP_ENERGY                   = slurm.WAIT_ASSOC_GRP_ENERGY
WAIT_ASSOC_GRP_ENERGY_MIN               = slurm.WAIT_ASSOC_GRP_ENERGY_MIN
WAIT_ASSOC_GRP_ENERGY_RUN_MIN           = slurm.WAIT_ASSOC_GRP_ENERGY_RUN_MIN
WAIT_ASSOC_MAX_ENERGY_PER_JOB           = slurm.WAIT_ASSOC_MAX_ENERGY_PER_JOB
WAIT_ASSOC_MAX_ENERGY_PER_NODE          = slurm.WAIT_ASSOC_MAX_ENERGY_PER_NODE
WAIT_ASSOC_MAX_ENERGY_MINS_PER_JOB      = slurm.WAIT_ASSOC_MAX_ENERGY_MINS_PER_JOB
WAIT_ASSOC_GRP_GRES                     = slurm.WAIT_ASSOC_GRP_GRES
WAIT_ASSOC_GRP_GRES_MIN                 = slurm.WAIT_ASSOC_GRP_GRES_MIN
WAIT_ASSOC_GRP_GRES_RUN_MIN             = slurm.WAIT_ASSOC_GRP_GRES_RUN_MIN
WAIT_ASSOC_MAX_GRES_PER_JOB             = slurm.WAIT_ASSOC_MAX_GRES_PER_JOB
WAIT_ASSOC_MAX_GRES_PER_NODE            = slurm.WAIT_ASSOC_MAX_GRES_PER_NODE
WAIT_ASSOC_MAX_GRES_MINS_PER_JOB        = slurm.WAIT_ASSOC_MAX_GRES_MINS_PER_JOB
WAIT_ASSOC_GRP_LIC                      = slurm.WAIT_ASSOC_GRP_LIC
WAIT_ASSOC_GRP_LIC_MIN                  = slurm.WAIT_ASSOC_GRP_LIC_MIN
WAIT_ASSOC_GRP_LIC_RUN_MIN              = slurm.WAIT_ASSOC_GRP_LIC_RUN_MIN
WAIT_ASSOC_MAX_LIC_PER_JOB              = slurm.WAIT_ASSOC_MAX_LIC_PER_JOB
WAIT_ASSOC_MAX_LIC_MINS_PER_JOB         = slurm.WAIT_ASSOC_MAX_LIC_MINS_PER_JOB
WAIT_ASSOC_GRP_BB                       = slurm.WAIT_ASSOC_GRP_BB
WAIT_ASSOC_GRP_BB_MIN                   = slurm.WAIT_ASSOC_GRP_BB_MIN
WAIT_ASSOC_GRP_BB_RUN_MIN               = slurm.WAIT_ASSOC_GRP_BB_RUN_MIN
WAIT_ASSOC_MAX_BB_PER_JOB               = slurm.WAIT_ASSOC_MAX_BB_PER_JOB
WAIT_ASSOC_MAX_BB_PER_NODE              = slurm.WAIT_ASSOC_MAX_BB_PER_NODE
WAIT_ASSOC_MAX_BB_MINS_PER_JOB          = slurm.WAIT_ASSOC_MAX_BB_MINS_PER_JOB
WAIT_QOS_GRP_UNK                        = slurm.WAIT_QOS_GRP_UNK
WAIT_QOS_GRP_UNK_MIN                    = slurm.WAIT_QOS_GRP_UNK_MIN
WAIT_QOS_GRP_UNK_RUN_MIN                = slurm.WAIT_QOS_GRP_UNK_RUN_MIN
WAIT_QOS_MAX_UNK_PER_JOB                = slurm.WAIT_QOS_MAX_UNK_PER_JOB
WAIT_QOS_MAX_UNK_PER_NODE               = slurm.WAIT_QOS_MAX_UNK_PER_NODE
WAIT_QOS_MAX_UNK_PER_USER               = slurm.WAIT_QOS_MAX_UNK_PER_USER
WAIT_QOS_MAX_UNK_MINS_PER_JOB           = slurm.WAIT_QOS_MAX_UNK_MINS_PER_JOB
WAIT_QOS_MIN_UNK                        = slurm.WAIT_QOS_MIN_UNK
WAIT_QOS_MAX_CPU_PER_NODE               = slurm.WAIT_QOS_MAX_CPU_PER_NODE
WAIT_QOS_GRP_MEM_MIN                    = slurm.WAIT_QOS_GRP_MEM_MIN
WAIT_QOS_GRP_MEM_RUN_MIN                = slurm.WAIT_QOS_GRP_MEM_RUN_MIN
WAIT_QOS_MAX_MEM_MINS_PER_JOB           = slurm.WAIT_QOS_MAX_MEM_MINS_PER_JOB
WAIT_QOS_MAX_MEM_PER_JOB                = slurm.WAIT_QOS_MAX_MEM_PER_JOB
WAIT_QOS_MAX_MEM_PER_NODE               = slurm.WAIT_QOS_MAX_MEM_PER_NODE
WAIT_QOS_MAX_MEM_PER_USER               = slurm.WAIT_QOS_MAX_MEM_PER_USER
WAIT_QOS_MIN_MEM                        = slurm.WAIT_QOS_MIN_MEM
WAIT_QOS_GRP_ENERGY                     = slurm.WAIT_QOS_GRP_ENERGY
WAIT_QOS_GRP_ENERGY_MIN                 = slurm.WAIT_QOS_GRP_ENERGY_MIN
WAIT_QOS_GRP_ENERGY_RUN_MIN             = slurm.WAIT_QOS_GRP_ENERGY_RUN_MIN
WAIT_QOS_MAX_ENERGY_PER_JOB             = slurm.WAIT_QOS_MAX_ENERGY_PER_JOB
WAIT_QOS_MAX_ENERGY_PER_NODE            = slurm.WAIT_QOS_MAX_ENERGY_PER_NODE
WAIT_QOS_MAX_ENERGY_PER_USER            = slurm.WAIT_QOS_MAX_ENERGY_PER_USER
WAIT_QOS_MAX_ENERGY_MINS_PER_JOB        = slurm.WAIT_QOS_MAX_ENERGY_MINS_PER_JOB
WAIT_QOS_MIN_ENERGY                     = slurm.WAIT_QOS_MIN_ENERGY
WAIT_QOS_GRP_NODE_MIN                   = slurm.WAIT_QOS_GRP_NODE_MIN
WAIT_QOS_GRP_NODE_RUN_MIN               = slurm.WAIT_QOS_GRP_NODE_RUN_MIN
WAIT_QOS_MAX_NODE_MINS_PER_JOB          = slurm.WAIT_QOS_MAX_NODE_MINS_PER_JOB
WAIT_QOS_MIN_NODE                       = slurm.WAIT_QOS_MIN_NODE
WAIT_QOS_GRP_GRES                       = slurm.WAIT_QOS_GRP_GRES
WAIT_QOS_GRP_GRES_MIN                   = slurm.WAIT_QOS_GRP_GRES_MIN
WAIT_QOS_GRP_GRES_RUN_MIN               = slurm.WAIT_QOS_GRP_GRES_RUN_MIN
WAIT_QOS_MAX_GRES_PER_JOB               = slurm.WAIT_QOS_MAX_GRES_PER_JOB
WAIT_QOS_MAX_GRES_PER_NODE              = slurm.WAIT_QOS_MAX_GRES_PER_NODE
WAIT_QOS_MAX_GRES_PER_USER              = slurm.WAIT_QOS_MAX_GRES_PER_USER
WAIT_QOS_MAX_GRES_MINS_PER_JOB          = slurm.WAIT_QOS_MAX_GRES_MINS_PER_JOB
WAIT_QOS_MIN_GRES                       = slurm.WAIT_QOS_MIN_GRES
WAIT_QOS_GRP_LIC                        = slurm.WAIT_QOS_GRP_LIC
WAIT_QOS_GRP_LIC_MIN                    = slurm.WAIT_QOS_GRP_LIC_MIN
WAIT_QOS_GRP_LIC_RUN_MIN                = slurm.WAIT_QOS_GRP_LIC_RUN_MIN
WAIT_QOS_MAX_LIC_PER_JOB                = slurm.WAIT_QOS_MAX_LIC_PER_JOB
WAIT_QOS_MAX_LIC_PER_USER               = slurm.WAIT_QOS_MAX_LIC_PER_USER
WAIT_QOS_MAX_LIC_MINS_PER_JOB           = slurm.WAIT_QOS_MAX_LIC_MINS_PER_JOB
WAIT_QOS_MIN_LIC                        = slurm.WAIT_QOS_MIN_LIC
WAIT_QOS_GRP_BB                         = slurm.WAIT_QOS_GRP_BB
WAIT_QOS_GRP_BB_MIN                     = slurm.WAIT_QOS_GRP_BB_MIN
WAIT_QOS_GRP_BB_RUN_MIN                 = slurm.WAIT_QOS_GRP_BB_RUN_MIN
WAIT_QOS_MAX_BB_PER_JOB                 = slurm.WAIT_QOS_MAX_BB_PER_JOB
WAIT_QOS_MAX_BB_PER_NODE                = slurm.WAIT_QOS_MAX_BB_PER_NODE
WAIT_QOS_MAX_BB_PER_USER                = slurm.WAIT_QOS_MAX_BB_PER_USER
WAIT_QOS_MAX_BB_MINS_PER_JOB            = slurm.WAIT_QOS_MAX_BB_MINS_PER_JOB
WAIT_QOS_MIN_BB                         = slurm.WAIT_QOS_MIN_BB
FAIL_DEADLINE                           = slurm.FAIL_DEADLINE
WAIT_QOS_MAX_BB_PER_ACCT                = slurm.WAIT_QOS_MAX_BB_PER_ACCT
WAIT_QOS_MAX_CPU_PER_ACCT               = slurm.WAIT_QOS_MAX_CPU_PER_ACCT
WAIT_QOS_MAX_ENERGY_PER_ACCT            = slurm.WAIT_QOS_MAX_ENERGY_PER_ACCT
WAIT_QOS_MAX_GRES_PER_ACCT              = slurm.WAIT_QOS_MAX_GRES_PER_ACCT
WAIT_QOS_MAX_NODE_PER_ACCT              = slurm.WAIT_QOS_MAX_NODE_PER_ACCT
WAIT_QOS_MAX_LIC_PER_ACCT               = slurm.WAIT_QOS_MAX_LIC_PER_ACCT
WAIT_QOS_MAX_MEM_PER_ACCT               = slurm.WAIT_QOS_MAX_MEM_PER_ACCT
WAIT_QOS_MAX_UNK_PER_ACCT               = slurm.WAIT_QOS_MAX_UNK_PER_ACCT
WAIT_QOS_MAX_JOB_PER_ACCT               = slurm.WAIT_QOS_MAX_JOB_PER_ACCT
WAIT_QOS_MAX_SUB_JOB_PER_ACCT           = slurm.WAIT_QOS_MAX_SUB_JOB_PER_ACCT
WAIT_PART_CONFIG                        = slurm.WAIT_PART_CONFIG
WAIT_ACCOUNT_POLICY                     = slurm.WAIT_ACCOUNT_POLICY
WAIT_FED_JOB_LOCK                       = slurm.WAIT_FED_JOB_LOCK
FAIL_OOM                                = slurm.FAIL_OOM
WAIT_PN_MEM_LIMIT                       = slurm.WAIT_PN_MEM_LIMIT
WAIT_ASSOC_GRP_BILLING                  = slurm.WAIT_ASSOC_GRP_BILLING
WAIT_ASSOC_GRP_BILLING_MIN              = slurm.WAIT_ASSOC_GRP_BILLING_MIN
WAIT_ASSOC_GRP_BILLING_RUN_MIN          = slurm.WAIT_ASSOC_GRP_BILLING_RUN_MIN
WAIT_ASSOC_MAX_BILLING_PER_JOB          = slurm.WAIT_ASSOC_MAX_BILLING_PER_JOB
WAIT_ASSOC_MAX_BILLING_PER_NODE         = slurm.WAIT_ASSOC_MAX_BILLING_PER_NODE
WAIT_ASSOC_MAX_BILLING_MINS_PER_JOB     = slurm.WAIT_ASSOC_MAX_BILLING_MINS_PER_JOB
WAIT_QOS_GRP_BILLING                    = slurm.WAIT_QOS_GRP_BILLING
WAIT_QOS_GRP_BILLING_MIN                = slurm.WAIT_QOS_GRP_BILLING_MIN
WAIT_QOS_GRP_BILLING_RUN_MIN            = slurm.WAIT_QOS_GRP_BILLING_RUN_MIN
WAIT_QOS_MAX_BILLING_PER_JOB            = slurm.WAIT_QOS_MAX_BILLING_PER_JOB
WAIT_QOS_MAX_BILLING_PER_NODE           = slurm.WAIT_QOS_MAX_BILLING_PER_NODE
WAIT_QOS_MAX_BILLING_PER_USER           = slurm.WAIT_QOS_MAX_BILLING_PER_USER
WAIT_QOS_MAX_BILLING_MINS_PER_JOB       = slurm.WAIT_QOS_MAX_BILLING_MINS_PER_JOB
WAIT_QOS_MAX_BILLING_PER_ACCT           = slurm.WAIT_QOS_MAX_BILLING_PER_ACCT
WAIT_QOS_MIN_BILLING                    = slurm.WAIT_QOS_MIN_BILLING
WAIT_RESV_DELETED                       = slurm.WAIT_RESV_DELETED

# end enum job_state_reason

# enum job_acct_types

JOB_START       = slurm.JOB_START
JOB_STEP        = slurm.JOB_STEP
JOB_SUSPEND     = slurm.JOB_SUSPEND
JOB_TERMINATED  = slurm.JOB_TERMINATED

# end enum job_acct_types

# enum auth_plugin_type

AUTH_PLUGIN_NONE   = slurm.AUTH_PLUGIN_NONE
AUTH_PLUGIN_MUNGE  = slurm.AUTH_PLUGIN_MUNGE
AUTH_PLUGIN_JWT    = slurm.AUTH_PLUGIN_JWT

# end enum auth_plugin_type

# enum select_plugin_type

SELECT_PLUGIN_CONS_RES        = slurm.SELECT_PLUGIN_CONS_RES
SELECT_PLUGIN_LINEAR          = slurm.SELECT_PLUGIN_LINEAR
SELECT_PLUGIN_SERIAL          = slurm.SELECT_PLUGIN_SERIAL
SELECT_PLUGIN_CRAY_LINEAR     = slurm.SELECT_PLUGIN_CRAY_LINEAR
SELECT_PLUGIN_CRAY_CONS_RES   = slurm.SELECT_PLUGIN_CRAY_CONS_RES
SELECT_PLUGIN_CONS_TRES       = slurm.SELECT_PLUGIN_CONS_TRES
SELECT_PLUGIN_CRAY_CONS_TRES  = slurm.SELECT_PLUGIN_CRAY_CONS_TRES

# end enum select_plugin_type

# enum switch_plugin_type

SWITCH_PLUGIN_NONE     = slurm.SWITCH_PLUGIN_NONE
SWITCH_PLUGIN_GENERIC  = slurm.SWITCH_PLUGIN_GENERIC
SWITCH_PLUGIN_CRAY     = slurm.SWITCH_PLUGIN_CRAY

# end enum switch_plugin_type

# enum select_jobdata_type

SELECT_JOBDATA_PAGG_ID  = slurm.SELECT_JOBDATA_PAGG_ID
SELECT_JOBDATA_PTR      = slurm.SELECT_JOBDATA_PTR
SELECT_JOBDATA_CLEANING = slurm.SELECT_JOBDATA_CLEANING
SELECT_JOBDATA_NETWORK  = slurm.SELECT_JOBDATA_NETWORK
SELECT_JOBDATA_RELEASED = slurm.SELECT_JOBDATA_RELEASED

# end enum select_jobdata_type

# enum select_nodedata_type

SELECT_NODEDATA_SUBCNT               = slurm.SELECT_NODEDATA_SUBCNT
SELECT_NODEDATA_PTR                  = slurm.SELECT_NODEDATA_PTR
SELECT_NODEDATA_MEM_ALLOC            = slurm.SELECT_NODEDATA_MEM_ALLOC
SELECT_NODEDATA_TRES_ALLOC_FMT_STR   = slurm.SELECT_NODEDATA_TRES_ALLOC_FMT_STR
SELECT_NODEDATA_TRES_ALLOC_WEIGHTED  = slurm.SELECT_NODEDATA_TRES_ALLOC_WEIGHTED

# end enum select_nodedata_type

# enum select_print_mode

SELECT_PRINT_HEAD                    = slurm.SELECT_PRINT_HEAD
SELECT_PRINT_DATA                    = slurm.SELECT_PRINT_DATA
SELECT_PRINT_MIXED                   = slurm.SELECT_PRINT_MIXED
SELECT_PRINT_MIXED_SHORT             = slurm.SELECT_PRINT_MIXED_SHORT
SELECT_PRINT_BG_ID                   = slurm.SELECT_PRINT_BG_ID
SELECT_PRINT_NODES                   = slurm.SELECT_PRINT_NODES
SELECT_PRINT_CONNECTION              = slurm.SELECT_PRINT_CONNECTION
SELECT_PRINT_ROTATE                  = slurm.SELECT_PRINT_ROTATE
SELECT_PRINT_GEOMETRY                = slurm.SELECT_PRINT_GEOMETRY
SELECT_PRINT_START                   = slurm.SELECT_PRINT_START
SELECT_PRINT_BLRTS_IMAGE             = slurm.SELECT_PRINT_BLRTS_IMAGE
SELECT_PRINT_LINUX_IMAGE             = slurm.SELECT_PRINT_LINUX_IMAGE
SELECT_PRINT_MLOADER_IMAGE           = slurm.SELECT_PRINT_MLOADER_IMAGE
SELECT_PRINT_RAMDISK_IMAGE           = slurm.SELECT_PRINT_RAMDISK_IMAGE
SELECT_PRINT_REBOOT                  = slurm.SELECT_PRINT_REBOOT
SELECT_PRINT_RESV_ID                 = slurm.SELECT_PRINT_RESV_ID
SELECT_PRINT_START_LOC               = slurm.SELECT_PRINT_START_LOC

# end enum select_print_mode

# enum select_node_cnt

SELECT_GET_NODE_SCALING              = slurm.SELECT_GET_NODE_SCALING
SELECT_GET_NODE_CPU_CNT              = slurm.SELECT_GET_NODE_CPU_CNT
SELECT_GET_MP_CPU_CNT                = slurm.SELECT_GET_MP_CPU_CNT
SELECT_APPLY_NODE_MIN_OFFSET         = slurm.SELECT_APPLY_NODE_MIN_OFFSET
SELECT_APPLY_NODE_MAX_OFFSET         = slurm.SELECT_APPLY_NODE_MAX_OFFSET
SELECT_SET_NODE_CNT                  = slurm.SELECT_SET_NODE_CNT
SELECT_SET_MP_CNT                    = slurm.SELECT_SET_MP_CNT

# end enum select_node_cnt

# enum acct_gather_profile_info

ACCT_GATHER_PROFILE_DIR              = slurm.ACCT_GATHER_PROFILE_DIR
ACCT_GATHER_PROFILE_DEFAULT          = slurm.ACCT_GATHER_PROFILE_DEFAULT
ACCT_GATHER_PROFILE_RUNNING          = slurm.ACCT_GATHER_PROFILE_RUNNING

# end enum acct_gather_profile_info

# enum jobacct_data_type

JOBACCT_DATA_TOTAL                   = slurm.JOBACCT_DATA_TOTAL
JOBACCT_DATA_PIPE                    = slurm.JOBACCT_DATA_PIPE
JOBACCT_DATA_RUSAGE                  = slurm.JOBACCT_DATA_RUSAGE
JOBACCT_DATA_TOT_VSIZE               = slurm.JOBACCT_DATA_TOT_VSIZE
JOBACCT_DATA_TOT_RSS                 = slurm.JOBACCT_DATA_TOT_RSS

# end enum jobacct_data_type

# enum acct_energy_type

ENERGY_DATA_JOULES_TASK              = slurm.ENERGY_DATA_JOULES_TASK
ENERGY_DATA_STRUCT                   = slurm.ENERGY_DATA_STRUCT
ENERGY_DATA_RECONFIG                 = slurm.ENERGY_DATA_RECONFIG
ENERGY_DATA_PROFILE                  = slurm.ENERGY_DATA_PROFILE
ENERGY_DATA_LAST_POLL                = slurm.ENERGY_DATA_LAST_POLL
ENERGY_DATA_SENSOR_CNT               = slurm.ENERGY_DATA_SENSOR_CNT
ENERGY_DATA_NODE_ENERGY              = slurm.ENERGY_DATA_NODE_ENERGY
ENERGY_DATA_NODE_ENERGY_UP           = slurm.ENERGY_DATA_NODE_ENERGY_UP
ENERGY_DATA_STEP_PTR                 = slurm.ENERGY_DATA_STEP_PTR

# end enum acct_energy_type

# enum task_dist_states

SLURM_DIST_CYCLIC               = slurm.SLURM_DIST_CYCLIC
SLURM_DIST_BLOCK                = slurm.SLURM_DIST_BLOCK
SLURM_DIST_ARBITRARY            = slurm.SLURM_DIST_ARBITRARY
SLURM_DIST_PLANE                = slurm.SLURM_DIST_PLANE
SLURM_DIST_CYCLIC_CYCLIC        = slurm.SLURM_DIST_CYCLIC_CYCLIC
SLURM_DIST_CYCLIC_BLOCK         = slurm.SLURM_DIST_CYCLIC_BLOCK
SLURM_DIST_CYCLIC_CFULL         = slurm.SLURM_DIST_CYCLIC_CFULL
SLURM_DIST_BLOCK_CYCLIC         = slurm.SLURM_DIST_BLOCK_CYCLIC
SLURM_DIST_BLOCK_BLOCK          = slurm.SLURM_DIST_BLOCK_BLOCK
SLURM_DIST_BLOCK_CFULL          = slurm.SLURM_DIST_BLOCK_CFULL
SLURM_DIST_CYCLIC_CYCLIC_CYCLIC = slurm.SLURM_DIST_CYCLIC_CYCLIC_CYCLIC
SLURM_DIST_CYCLIC_CYCLIC_BLOCK  = slurm.SLURM_DIST_CYCLIC_CYCLIC_BLOCK
SLURM_DIST_CYCLIC_CYCLIC_CFULL  = slurm.SLURM_DIST_CYCLIC_CYCLIC_CFULL
SLURM_DIST_CYCLIC_BLOCK_CYCLIC  = slurm.SLURM_DIST_CYCLIC_BLOCK_CYCLIC
SLURM_DIST_CYCLIC_BLOCK_BLOCK   = slurm.SLURM_DIST_CYCLIC_BLOCK_BLOCK
SLURM_DIST_CYCLIC_BLOCK_CFULL   = slurm.SLURM_DIST_CYCLIC_BLOCK_CFULL
SLURM_DIST_CYCLIC_CFULL_CYCLIC  = slurm.SLURM_DIST_CYCLIC_CFULL_CYCLIC
SLURM_DIST_CYCLIC_CFULL_BLOCK   = slurm.SLURM_DIST_CYCLIC_CFULL_BLOCK
SLURM_DIST_CYCLIC_CFULL_CFULL   = slurm.SLURM_DIST_CYCLIC_CFULL_CFULL
SLURM_DIST_BLOCK_CYCLIC_CYCLIC  = slurm.SLURM_DIST_BLOCK_CYCLIC_CYCLIC
SLURM_DIST_BLOCK_CYCLIC_BLOCK   = slurm.SLURM_DIST_BLOCK_CYCLIC_BLOCK
SLURM_DIST_BLOCK_CYCLIC_CFULL   = slurm.SLURM_DIST_BLOCK_CYCLIC_CFULL
SLURM_DIST_BLOCK_BLOCK_CYCLIC   = slurm.SLURM_DIST_BLOCK_BLOCK_CYCLIC
SLURM_DIST_BLOCK_BLOCK_BLOCK    = slurm.SLURM_DIST_BLOCK_BLOCK_BLOCK
SLURM_DIST_BLOCK_BLOCK_CFULL    = slurm.SLURM_DIST_BLOCK_BLOCK_CFULL
SLURM_DIST_BLOCK_CFULL_CYCLIC   = slurm.SLURM_DIST_BLOCK_CFULL_CYCLIC
SLURM_DIST_BLOCK_CFULL_BLOCK    = slurm.SLURM_DIST_BLOCK_CFULL_BLOCK
SLURM_DIST_BLOCK_CFULL_CFULL    = slurm.SLURM_DIST_BLOCK_CFULL_CFULL

SLURM_DIST_NODECYCLIC           = slurm.SLURM_DIST_NODECYCLIC
SLURM_DIST_NODEBLOCK            = slurm.SLURM_DIST_NODEBLOCK
SLURM_DIST_SOCKCYCLIC           = slurm.SLURM_DIST_SOCKCYCLIC
SLURM_DIST_SOCKBLOCK            = slurm.SLURM_DIST_SOCKBLOCK
SLURM_DIST_SOCKCFULL            = slurm.SLURM_DIST_SOCKCFULL
SLURM_DIST_CORECYCLIC           = slurm.SLURM_DIST_CORECYCLIC
SLURM_DIST_COREBLOCK            = slurm.SLURM_DIST_COREBLOCK
SLURM_DIST_CORECFULL            = slurm.SLURM_DIST_CORECFULL

SLURM_DIST_NO_LLLP              = slurm.SLURM_DIST_NO_LLLP
SLURM_DIST_UNKNOWN              = slurm.SLURM_DIST_UNKNOWN

# end enum task_disk_states

# enum cpu_bind_type

CPU_BIND_VERBOSE                = slurm.CPU_BIND_VERBOSE
CPU_BIND_TO_THREADS             = slurm.CPU_BIND_TO_THREADS
CPU_BIND_TO_CORES               = slurm.CPU_BIND_TO_CORES
CPU_BIND_TO_SOCKETS             = slurm.CPU_BIND_TO_SOCKETS
CPU_BIND_TO_LDOMS               = slurm.CPU_BIND_TO_LDOMS
CPU_BIND_TO_BOARDS              = slurm.CPU_BIND_TO_BOARDS
CPU_BIND_NONE                   = slurm.CPU_BIND_NONE
CPU_BIND_RANK                   = slurm.CPU_BIND_RANK
CPU_BIND_MAP                    = slurm.CPU_BIND_MAP
CPU_BIND_MASK                   = slurm.CPU_BIND_MASK
CPU_BIND_LDRANK                 = slurm.CPU_BIND_LDRANK
CPU_BIND_LDMAP                  = slurm.CPU_BIND_LDMAP
CPU_BIND_LDMASK                 = slurm.CPU_BIND_LDMASK
CPU_BIND_ONE_THREAD_PER_CORE    = slurm.CPU_BIND_ONE_THREAD_PER_CORE
CPU_AUTO_BIND_TO_THREADS        = slurm.CPU_AUTO_BIND_TO_THREADS
CPU_AUTO_BIND_TO_CORES          = slurm.CPU_AUTO_BIND_TO_CORES
CPU_AUTO_BIND_TO_SOCKETS        = slurm.CPU_AUTO_BIND_TO_SOCKETS
SLURMD_OFF_SPEC                 = slurm.SLURMD_OFF_SPEC
CPU_BIND_OFF                    = slurm.CPU_BIND_OFF

# end enum cpu_bind_type

# enum mem_bind_type

MEM_BIND_VERBOSE                = slurm.MEM_BIND_VERBOSE
MEM_BIND_NONE                   = slurm.MEM_BIND_NONE
MEM_BIND_RANK                   = slurm.MEM_BIND_RANK
MEM_BIND_MAP                    = slurm.MEM_BIND_MAP
MEM_BIND_MASK                   = slurm.MEM_BIND_MASK
MEM_BIND_LOCAL                  = slurm.MEM_BIND_LOCAL
MEM_BIND_SORT                   = slurm.MEM_BIND_SORT
MEM_BIND_PREFER                 = slurm.MEM_BIND_PREFER

# end enum mem_bind_type

# enum accel_bind_type

ACCEL_BIND_VERBOSE              = slurm.ACCEL_BIND_VERBOSE
ACCEL_BIND_CLOSEST_GPU          = slurm.ACCEL_BIND_CLOSEST_GPU
ACCEL_BIND_CLOSEST_MIC          = slurm.ACCEL_BIND_CLOSEST_MIC
ACCEL_BIND_CLOSEST_NIC          = slurm.ACCEL_BIND_CLOSEST_NIC

# end enum accel_bind_type

# enum node_states

NODE_STATE_UNKNOWN              = slurm.NODE_STATE_UNKNOWN
NODE_STATE_DOWN                 = slurm.NODE_STATE_DOWN
NODE_STATE_IDLE                 = slurm.NODE_STATE_IDLE
NODE_STATE_ALLOCATED            = slurm.NODE_STATE_ALLOCATED
NODE_STATE_ERROR                = slurm.NODE_STATE_ERROR
NODE_STATE_MIXED                = slurm.NODE_STATE_MIXED
NODE_STATE_FUTURE               = slurm.NODE_STATE_FUTURE
NODE_STATE_END                  = slurm.NODE_STATE_END
NODE_STATE_DYNAMIC              = slurm.NODE_STATE_DYNAMIC
NODE_STATE_REBOOT_ISSUED        = slurm.NODE_STATE_REBOOT_ISSUED

# end enum node_states

# enum ctx_keys

SLURM_STEP_CTX_STEPID                   = slurm.SLURM_STEP_CTX_STEPID
SLURM_STEP_CTX_TASKS                    = slurm.SLURM_STEP_CTX_TASKS
SLURM_STEP_CTX_TID                      = slurm.SLURM_STEP_CTX_TID
SLURM_STEP_CTX_RESP                     = slurm.SLURM_STEP_CTX_RESP
SLURM_STEP_CTX_CRED                     = slurm.SLURM_STEP_CTX_CRED
SLURM_STEP_CTX_SWITCH_JOB               = slurm.SLURM_STEP_CTX_SWITCH_JOB
SLURM_STEP_CTX_NUM_HOSTS                = slurm.SLURM_STEP_CTX_NUM_HOSTS
SLURM_STEP_CTX_HOST                     = slurm.SLURM_STEP_CTX_HOST
SLURM_STEP_CTX_JOBID                    = slurm.SLURM_STEP_CTX_JOBID
SLURM_STEP_CTX_USER_MANAGED_SOCKETS     = slurm.SLURM_STEP_CTX_USER_MANAGED_SOCKETS
SLURM_STEP_CTX_NODE_LIST                = slurm.SLURM_STEP_CTX_NODE_LIST
SLURM_STEP_CTX_TIDS                     = slurm.SLURM_STEP_CTX_TIDS
SLURM_STEP_CTX_DEF_CPU_BIND_TYPE        = slurm.SLURM_STEP_CTX_DEF_CPU_BIND_TYPE

# end enum ctx_keys





