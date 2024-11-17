#!/bin/bash

# root directory
SCRIPT_DIR=$(pwd)
PROJECT_DIR=$(pwd)/${PROJECT_NAME}

# vivado install path
VIVADO_BIN_DIR=$(dirname $(which vivado))

###########################################
# for vivado generator
###########################################
#############
# template
#############
VIVADO_TEMPLATE_DIR=${SCRIPT_DIR}/template/vivado
VIVADO_TEMPLATE_PROPERRTY=${VIVADO_TEMPLATE_DIR}/property/property.tcl.in
VIVADO_TEMPLATE_READ_VERILOG_HEADER=${VIVADO_TEMPLATE_DIR}/read_verilog/read_verilog_header.tcl.in
VIVADO_TEMPLATE_READ_VERILOG=${VIVADO_TEMPLATE_DIR}/read_verilog/read_verilog.tcl.in
VIVADO_TEMPLATE_READ_INCDIR_HEADER=${VIVADO_TEMPLATE_DIR}/read_verilog/read_include_path_header.tcl.in
VIVADO_TEMPLATE_READ_INCDIR=${VIVADO_TEMPLATE_DIR}/read_verilog/read_include_path.tcl.in
VIVADO_TEMPLATE_READ_GLOBAL_INCLUDE=${VIVADO_TEMPLATE_DIR}/read_verilog/read_global_include.tcl.in
VIVADO_TEMPLATE_POST_SYNTH_HEADER=${VIVADO_TEMPLATE_DIR}/synth/post_synth_header.tcl.in
VIVADO_TEMPLATE_FUNCTIONS=${VIVADO_TEMPLATE_DIR}/functions/functions.tcl.in
VIVADO_TEMPLATE_READ_XDC_HEADER=${VIVADO_TEMPLATE_DIR}/read_xdc/read_xdc_header.tcl.in
VIVADO_TEMPLATE_READ_XDC=${VIVADO_TEMPLATE_DIR}/read_xdc/read_xdc.tcl.in
VIVADO_TEMPLATE_READ_XCI_HEADER=${VIVADO_TEMPLATE_DIR}/read_ip/read_xci_header.tcl.in
VIVADO_TEMPLATE_READ_XCI=${VIVADO_TEMPLATE_DIR}/read_ip/read_xci.tcl.in
VIVADO_TEMPLATE_READ_BD=${VIVADO_TEMPLATE_DIR}/read_bd/read_bd.tcl.in
VIVADO_TEMPLATE_GENERATE_XCI=${VIVADO_TEMPLATE_DIR}/read_ip/generate_xci.tcl.in
VIVADO_TEMPLATE_READ_CHECKPOINT=${VIVADO_TEMPLATE_DIR}/impl/read_checkpoint.tcl.in
VIVADO_TEMPLATE_READ_CHECKPOINT_LIST=${VIVADO_TEMPLATE_DIR}/impl/read_checkpoint_list.tcl.in
VIVADO_TEMPLATE_READ_CHECKPOINT_HEADER=${VIVADO_TEMPLATE_DIR}/impl/read_checkpoint_header.tcl.in
VIVADO_TEMPLATE_SYNTH=${VIVADO_TEMPLATE_DIR}/synth/synth.tcl.in
VIVADO_TEMPLAT_IMPL=${VIVADO_TEMPLATE_DIR}/impl/impl.tcl.in

#############
# tcl
#############
# vivado scripts director
VIVADO_DIR=${PROJECT_DIR}/vivado
VIVADO_SYN_DIR=${VIVADO_DIR}/SynOutputDir
VIVADO_IMPL_DIR=${VIVADO_DIR}/ImplOutputDir
VIVADO_SCRIPT_DIR=${VIVADO_DIR}/Scripts
VIVADO_IP_GENERATE_DIR=${VIVADO_DIR}/.gen/ip
VIVADO_BD_GENERATE_DIR=${VIVADO_DIR}/.gen/bd

# tcl files
VIVADO_FILELIST_SCRIPT=${VIVADO_SCRIPT_DIR}/filelist.tcl
VIVADO_SYN_SCRIPT=${VIVADO_SCRIPT_DIR}/run_synth.tcl
VIVADO_IMPL_SCRIPT=${VIVADO_SCRIPT_DIR}/run_impl.tcl
VIVADO_FUNCTIONS_SCRIPT=${VIVADO_SCRIPT_DIR}/functions.tcl

# entry files
VIVADO_SYNTH_ENTRY=${VIVADO_DIR}/run_synth
VIVADO_IMPL_ENTRY=${VIVADO_DIR}/run_impl


###########################################
# for vcs generator
###########################################
#############
# template
#############
VCS_TEMPLATE_DIR=${SCRIPT_DIR}/template/vcs
VCS_TEMPLATE_SETUP=${VCS_TEMPLATE_DIR}/synopsys_sim.setup.in
VCS_TEMPLATE_COMPILE=${VCS_TEMPLATE_DIR}/compile.sh.in
VCS_TEMPLATE_ELABORATE=${VCS_TEMPLATE_DIR}/elaborate.sh.in
VCS_TEMPLATE_SIMULATE=${VCS_TEMPLATE_DIR}/simulate.sh.in
VCS_TEMPLATE_VERDI=${VCS_TEMPLATE_DIR}/verdi.sh.in

#############
# tcl
#############
# vcs script directories
VCS_DIR=${PROJECT_DIR}/vcs
VCS_WORK_LIB_NAME=xli_default
VCS_WORK_DIR=${VCS_DIR}/${VCS_WORK_LIB_NAME}

# vcs script files
VCS_SETUP_SCRIPT=${VCS_DIR}/synopsys_sim.setup
VCS_COMPILE_SCRIPT=${VCS_DIR}/compile.sh
VCS_ELABORATE_SCRIPT=${VCS_DIR}/elaborate.sh
VCS_SIMUALTE_SCRIPT=${VCS_DIR}/simulate.sh
VCS_VERDI_SCRIPT=${VCS_DIR}/verdi.sh
VCS_SIM_FILELIST=${VCS_DIR}/filelist.txt

###########################################
# for iverilog generator
###########################################
#############
# template
#############
IVERILOG_TEMPLATE_DIR=${SCRIPT_DIR}/template/iverilog
IVERILOG_TEMPLATE_COMPILE=${IVERILOG_TEMPLATE_DIR}/compile.sh.in
IVERILOG_TEMPLATE_SIMULATE=${IVERILOG_TEMPLATE_DIR}/simulate.sh.in


# vcs script directories
IVERILOG_DIR=${PROJECT_DIR}/iverilog

# vcs script files
IVERILOG_COMPILE_SCRIPT=${IVERILOG_DIR}/compile.sh
IVERILOG_SIMUALTE_SCRIPT=${IVERILOG_DIR}/simulate.sh
IVERILOG_GTKWAVE_SCRIPT=${IVERILOG_DIR}/gtkwave.sh
IVERILOG_SIM_FILELIST=${IVERILOG_DIR}/filelist.txt