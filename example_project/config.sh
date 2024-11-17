#!/bin/bash

PROJECT_NAME=blink

###########################################
# for tcl flow
###########################################
# device definition
VIVADO_DEVICE=xc7z020
VIVADO_PACKAGE=clg400
VIVADO_SPEED=-2
VIVADO_PART=\$device\$package\$speed

# top module
VIVADO_TOP_MODULES=blink

# bd module
VIVADO_BD_TOP_MODULES=

# source files
VIVADO_VERILOG_FILELIST=(
    rtl/common.vh
    rtl/blink.v
)
VIVADO_INC_PATH_FILELIST=(
    rtl
)
VIVADO_GLOBAL_INC_FILE_LIST=
VIVADO_XCI_FILELIST=
VIVADO_BD_FILE=
VIVADO_BD_TCL_FILELIST=
VIVADO_XDC_FILELIST=(
    xdc/blink.xdc
)
VIVADO_SIM_FILELIST=(
    tb/tb_blink.v
)
VIVADO_POST_SYNTH_SCRIPTS_FILELIST=

# ip repository path
VIVAOD_USER_IP_REPOSITORY=

# synth oprions
VIVADO_SYNTH_OPT="-directive PerformanceOptimized -flatten_hierarchy full -keep_equivalent_registers -retiming"
VIVADO_OPT_OPT=""
VIVADO_PLACE_OPT=""
VIDODO_PHYS_OPT_OPT=""
VIVADO_ROUTE_OPT_OPT=""

###########################################
# for vcs flow
###########################################
VCS_ENABLE=1

# pre-compiled simulation library
VCS_COMPILE_LIB_DIR=/xxx/compile_simlib/vcs

# simulation config
VCS_TIMESCALE="1ns/1ps"

# simulation_mode
# 1. RTL
# 2. POST_SYNTH
VCS_SIM_MODE=RTL

VCS_SIM_TOP_MODULE=tb_blink
VCS_FSDB_FILE=tb_blink.fsdb

###########################################
# for iverilog flow
###########################################
IVERILOG_ENABLE=1

IVERILOG_SIM_TOP_MODULE=tb_blink
IVERILOG_VCD_FILE=tb_blink.vcd