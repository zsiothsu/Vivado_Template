#!/bin/bash

# project name
PROJECT_NAME=blink

###########################################
# Vivado Configuration
###########################################
# target device
VIVADO_PART=xc7z020clg400-2

# top module name of source code
VIVADO_TOP_MODULES=blink

# file configuration
# verilog source: .v .sv
VIVADO_VERILOG_FILELIST=(
    rtl/common.vh
    rtl/blink.v
)
# simulation source: .v .sv
VIVADO_SIM_FILELIST=(
    tb/tb_blink.v
)
# include path
VIVADO_INC_PATH_FILELIST=(
    rtl
)
# global include file: .v .vh .sv .svh
VIVADO_GLOBAL_INC_FILE_LIST=(

)
# constraints file: .xdc
VIVADO_XDC_FILELIST=(
    xdc/blink.xdc
)
# Vivado IP core: .xci
VIVADO_XCI_FILELIST=

# Vivado options for synthesis and implemention
VIVADO_SYNTH_OPT="-directive PerformanceOptimized -flatten_hierarchy full -keep_equivalent_registers -retiming"
VIVADO_OPT_OPT=""
VIVADO_PLACE_OPT=""
VIDODO_PHYS_OPT_OPT=""
VIVADO_ROUTE_OPT_OPT=""

###########################################
# Simulation Configuration
###########################################
# top module name of simulation files
SIM_TOP_MODULE=tb_blink

# simulation tools
# 1. vcs
# 2. iverilog
SIM_TOOL=iverilog

#############
# vcs configuration
#############
# pre-compiled simulation library
VCS_COMPILE_LIB_DIR=/xxx/compile_simlib/vcs

# simulation config
VCS_TIMESCALE="1ns/1ps"

# simulation_mode
# 1. RTL
# 2. POST_SYNTH
VCS_SIM_MODE=RTL

###########################################
# Other Configurawtions
###########################################
# tcl scripts to be executed after synthesis
VIVADO_POST_SYNTH_SCRIPTS_FILELIST=(

)
# Vivado user ip core repository
VIVAOD_USER_IP_REPOSITORY=