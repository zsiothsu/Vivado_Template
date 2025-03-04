#!/bin/bash

SRC_DIR=""

COLOR_ERROR="\033[31m"
COLOR_WARNING="\033[34m"
COLOR_INFO="\033[36m"
COLOR_RESET="\033[0m"

function vivado_replace_xci_path() {
    echo -e ${COLOR_INFO}"[info] vivado: replace xci path"${COLOR_RESET}
    for xci in ${VIVADO_XCI_FILELIST[@]}; do
        if [[ -f ${SRC_DIR}/${xci} ]]; then
            xci_file=${SRC_DIR}/${xci}
            xci_basename=`basename ${xci} .xci`
            vivado_ip_gen_dir=`echo ${VIVADO_IP_GENERATE_DIR//\//\\\/}`
            # for json
            sed -i "s/\"gen_directory\": \".*\"/\"gen_directory\": \"${vivado_ip_gen_dir}\/${xci_basename}\"/g" ${xci_file}
            sed -i "s/\"OUTPUTDIR\": \[.*\]/\"OUTPUTDIR\": \[ \{ \"value\": \"${vivado_ip_gen_dir}\/${xci_basename}\" \} \]/g" ${xci_file} 
            # for xml
            sed -i "s/<spirit:configurableElementValue spirit:referenceId=\"RUNTIME_PARAM.OUTPUTDIR\">.*<\/spirit:configurableElementValue>/<spirit:configurableElementValue spirit:referenceId=\"RUNTIME_PARAM.OUTPUTDIR\">${vivado_ip_gen_dir}\/${xci_basename}<\/spirit:configurableElementValue>/g" ${xci_file}
        else
            echo -e ${COLOR_ERROR}"[error] file ${SRC_DIR}/${xci} dosen't exist. "${COLOR_RESET}
        fi
    done
}

function vivado_replace_bd_path() {
    for bd in ${VIVADO_BD_FILE[@]}; do
        if [[ -f ${SRC_DIR}/${bd} ]]; then
            bd_file=${SRC_DIR}/${bd}
            bd_basename=`basename ${bd} .bd`
            vivado_bd_gen_dir=`echo ${VIVADO_BD_GENERATE_DIR//\//\\\/}`
            # for json
            sed -i "s/\"gen_directory\": \".*\"/\"gen_directory\": \"${vivado_bd_gen_dir}\/${bd_basename}\"/g" ${bd_file}
            sed -i "s/\"OUTPUTDIR\": \[.*\]/\"OUTPUTDIR\": \[ \{ \"value\": \"${vivado_bd_gen_dir}\/${bd_basename}\" \} \]/g" ${bd_file} 
            # for xml
            sed -i "s/<spirit:configurableElementValue spirit:referenceId=\"RUNTIME_PARAM.OUTPUTDIR\">.*<\/spirit:configurableElementValue>/<spirit:configurableElementValue spirit:referenceId=\"RUNTIME_PARAM.OUTPUTDIR\">${vivado_bd_gen_dir}\/${bd_basename}<\/spirit:configurableElementValue>/g" ${bd_file}
            # change to global synthesis
            sed -i "s/\"synth_flow_mode\": \"Hierarchical\"/\"synth_flow_mode\": \"None\"/g" ${bd_file}
        else
            echo -e ${COLOR_ERROR}"[error] file ${SRC_DIR}/${bd} dosen't exist. "${COLOR_RESET}
        fi
    done
}

function vivado_make_directoies() {
    echo -e ${COLOR_INFO}"[info] vivado: make directories"${COLOR_RESET}
    mkdir -p ${VIVADO_DIR}
    mkdir -p ${VIVADO_SYN_DIR}
    mkdir -p ${VIVADO_IMPL_DIR}
    mkdir -p ${VIVADO_SCRIPT_DIR}
}

function vivado_gen_entry() {
    echo -e ${COLOR_INFO}"[info] vivado: generate entry"${COLOR_RESET}

    template_post_synth_header=$(cat ${VIVADO_TEMPLATE_POST_SYNTH_HEADER})

    # generate synth entry
    echo "rm *.jou *.log || echo \"\" > /dev/null" > ${VIVADO_SYNTH_ENTRY}
    echo "vivado -mode tcl -source ${VIVADO_SYN_SCRIPT} -stack 10000000" >> ${VIVADO_SYNTH_ENTRY}

    if [[ -n "${VIVADO_POST_SYNTH_SCRIPTS_FILELIST}" ]]; then
        eval "echo \"${template_post_synth_header}\"" >> ${VIVADO_SYNTH_ENTRY}
        for script in ${VIVADO_POST_SYNTH_SCRIPTS_FILELIST[@]}; do
            if [[ -f ${SRC_DIR}/${script} ]]; then
                echo "vivado -mode tcl -source ${SRC_DIR}/${script}" >> ${VIVADO_SYNTH_ENTRY}
            else
                echo -e ${COLOR_ERROR}"[error] file ${SRC_DIR}/${script} dosen't exist. "${COLOR_RESET}
            fi
        done
    fi

    # generate impl entry
    echo "rm *.jou *.log || echo \"\" > /dev/null" > ${VIVADO_IMPL_ENTRY}
    echo "vivado -mode tcl -source ${VIVADO_IMPL_SCRIPT}" >> ${VIVADO_IMPL_ENTRY}
}

function vivado_gen_functions() {
    template_funcitons=$(cat ${VIVADO_TEMPLATE_FUNCTIONS})
    eval "echo \"${template_funcitons}\"" > ${VIVADO_FUNCTIONS_SCRIPT}
}

function vivado_gen_filelist() {
    echo -e ${COLOR_INFO}"[info] vivado: generate file list"${COLOR_RESET}
    echo "set SrcDir ${SRC_DIR}" > ${VIVADO_FILELIST_SCRIPT}

    template_read_verilog_header=$(cat ${VIVADO_TEMPLATE_READ_VERILOG_HEADER})
    template_read_verilog=$(cat ${VIVADO_TEMPLATE_READ_VERILOG})
    template_read_include_dir_header=$(cat ${VIVADO_TEMPLATE_READ_INCDIR_HEADER})
    template_read_include_dir=$(cat ${VIVADO_TEMPLATE_READ_INCDIR})
    template_read_global_include=$(cat ${VIVADO_TEMPLATE_READ_GLOBAL_INCLUDE})

    eval "echo \"${template_read_verilog_header}\"" >> ${VIVADO_FILELIST_SCRIPT}
    for verilog in ${VIVADO_VERILOG_FILELIST[@]}
    do
        if [[ -f ${SRC_DIR}/${verilog} ]]; then
            verilog=\$\{SrcDir\}/${verilog}
            eval "echo \"${template_read_verilog}\"" >> ${VIVADO_FILELIST_SCRIPT}
        else
            echo -e ${COLOR_ERROR}"[error] file ${SRC_DIR}/${verilog} dosen't exist. "${COLOR_RESET}
        fi
    done

    echo "" >> ${VIVADO_FILELIST_SCRIPT}
    if [[ -n "${VIVADO_GLOBAL_INC_FILE_LIST}" ]]; then
        for headers in ${VIVADO_GLOBAL_INC_FILE_LIST[@]}; do
            if [[ -f ${SRC_DIR}/${headers} ]]; then
                eval "echo \"${template_read_global_include}\"" >> ${VIVADO_FILELIST_SCRIPT}
            else
                echo -e ${COLOR_ERROR}"[error] file ${SRC_DIR}/${headers} dosen't exist. "${COLOR_RESET}
            fi
        done
    fi

    if [[ -n "${VIVADO_INC_PATH_FILELIST}" ]]; then
        eval "echo \"${template_read_include_dir_header}\"" >> ${VIVADO_FILELIST_SCRIPT}

        inc_dirs=""

        for line in ${VIVADO_INC_PATH_FILELIST[@]}; do
            if [[ -d ${SRC_DIR}/${line} ]]; then
                line=\$\{SrcDir\}/${line}
                inc_dirs="${inc_dirs} ${line}"
            else
                echo -e ${COLOR_ERROR}"[error] directory ${SRC_DIR}/${line} dosen't exist. "${COLOR_RESET}
            fi
        done

        eval "echo \"${template_read_include_dir}\"" >> ${VIVADO_FILELIST_SCRIPT}
    fi
}

function vivado_gen_synth() {
    echo -e ${COLOR_INFO}"[info] vivado: generate synthesis script"${COLOR_RESET}
    template_property=$(cat ${VIVADO_TEMPLATE_PROPERRTY})
    template_synth=$(cat ${VIVADO_TEMPLATE_SYNTH})
    template_read_xdc_header=$(cat ${VIVADO_TEMPLATE_READ_XDC_HEADER})
    template_read_xdc=$(cat ${VIVADO_TEMPLATE_READ_XDC})
    template_read_xci_header=$(cat ${VIVADO_TEMPLATE_READ_XCI_HEADER})
    template_read_xci=$(cat ${VIVADO_TEMPLATE_READ_XCI})
    template_generate_xci=$(cat ${VIVADO_TEMPLATE_GENERATE_XCI})
    template_read_bd=$(cat ${VIVADO_TEMPLATE_READ_BD})

    top=${VIVADO_TOP_MODULES}
    
    echo "" > ${VIVADO_SYN_SCRIPT}

    #############
    # gen functions
    #############
    echo "#################################################" >> ${VIVADO_SYN_SCRIPT}
    echo "#               external functions" >> ${VIVADO_SYN_SCRIPT}
    echo "#################################################" >> ${VIVADO_SYN_SCRIPT}
    echo "source ${VIVADO_FUNCTIONS_SCRIPT}" >> ${VIVADO_SYN_SCRIPT}


    #############
    # gen property
    #############
    eval "echo \"${template_property}\"" >> ${VIVADO_SYN_SCRIPT}

    #############
    # gen read user ip repo
    #############
    if [[ ${VIVAOD_USER_IP_REPOSITORY} ]]; then
        if [[ -d ${VIVAOD_USER_IP_REPOSITORY} ]]; then
            echo "set_property IP_REPO_PATHS ${VIVAOD_USER_IP_REPOSITORY} [current_fileset]" >> ${VIVADO_SYN_SCRIPT}
            echo "update_ip_catalog" >> ${VIVADO_SYN_SCRIPT}
        else 
            echo "user ip repository \"${VIVAOD_USER_IP_REPOSITORY}\" dosen't exist. stop"
            exit
        fi
    fi


    #############
    # gen read verilog
    #############
    if [[ -n "${VIVADO_VERILOG_FILELIST}" ]]; then
        echo "" >> ${VIVADO_SYN_SCRIPT}
        echo "source ${VIVADO_FILELIST_SCRIPT}" >> ${VIVADO_SYN_SCRIPT}
    fi

    #############
    # gen read vivado xci ip file
    #############
    if [[ -n "${VIVADO_XCI_FILELIST}" ]]; then
        eval "echo \"${template_read_xci_header}\"" >> ${VIVADO_SYN_SCRIPT}

        for xci in ${VIVADO_XCI_FILELIST[@]}; do
            if [[ -f ${SRC_DIR}/${xci} ]]; then
                xci_basename=$(basename ${xci} .xci)
                xci=\$\{SrcDir\}/${xci}
                eval "echo \"${template_read_xci}\"" >> ${VIVADO_SYN_SCRIPT}
            else
                echo -e ${COLOR_ERROR}"[error] file ${SRC_DIR}/${xci} dosen't exist. "${COLOR_RESET}
            fi
        done

        eval "echo \"${template_generate_xci}\"" >> ${VIVADO_SYN_SCRIPT}
    fi
    
    #############
    # gen read block design
    #############
    if [[ -n "${VIVADO_BD_FILE}" ]]; then
        if [[ -f ${VIVADO_BD_FILE} ]]; then
            bd_name=`basename ${bd} .bd`
            bd=\$\{SrcDir\}/${VIVADO_BD_FILE}
            eval "echo \"${template_read_bd}\"" >> ${VIVADO_SYN_SCRIPT}
        fi
    fi

    #############
    # gen read xdc
    #############
    if [[ -n "${VIVADO_XDC_FILELIST}" ]]; then
        eval "echo \"${template_read_xdc_header}\"" >> ${VIVADO_SYN_SCRIPT}
        for xdc in ${VIVADO_XDC_FILELIST[@]}; do
            if [[ -f ${SRC_DIR}/${xdc} ]]; then
                xdc=\$\{SrcDir\}/${xdc}
                eval "echo \"${template_read_xdc}\"" >> ${VIVADO_SYN_SCRIPT}
            else
                echo -e ${COLOR_ERROR}"[error] file ${SRC_DIR}/${xdc} dosen't exist. "${COLOR_RESET}
            fi
        done
    fi

    #############
    # gen synth command
    #############
    top=$VIVADO_TOP_MODULES
    eval "echo \"${template_synth}\"" >> ${VIVADO_SYN_SCRIPT}

    #############
    # gen exit command
    #############
    echo "" >> ${VIVADO_SYN_SCRIPT}
    echo "q" >> ${VIVADO_SYN_SCRIPT}
}

function vivado_gen_impl() {
    echo -e ${COLOR_INFO}"[info] vivado: generate implementation script"${COLOR_RESET}

    template_property=$(cat ${VIVADO_TEMPLATE_PROPERRTY})
    template_read_xdc_header=$(cat ${VIVADO_TEMPLATE_READ_XDC_HEADER})
    template_read_xdc=$(cat ${VIVADO_TEMPLATE_READ_XDC})
    template_impl=$(cat ${VIVADO_TEMPLAT_IMPL})
    template_read_checkpoint_header=$(cat ${VIVADO_TEMPLATE_READ_CHECKPOINT_HEADER})
    template_read_checkpoint=$(cat ${VIVADO_TEMPLATE_READ_CHECKPOINT})
    template_read_checkpoint_list=$(cat ${VIVADO_TEMPLATE_READ_CHECKPOINT_LIST})

    top=${VIVADO_TOP_MODULES}

    echo "" > ${VIVADO_IMPL_SCRIPT}

    #############
    # gen functions
    #############
    echo "#################################################" >> ${VIVADO_IMPL_SCRIPT}
    echo "#               external functions" >> ${VIVADO_IMPL_SCRIPT}
    echo "#################################################" >> ${VIVADO_IMPL_SCRIPT}
    echo "source ${VIVADO_FUNCTIONS_SCRIPT}" >> ${VIVADO_IMPL_SCRIPT}


    #############
    # gen property
    #############
    eval "echo \"${template_property}\"" >> ${VIVADO_IMPL_SCRIPT}

    #############
    # read checkpoint
    #############
    eval "echo \"${template_read_checkpoint_header}\"" >> ${VIVADO_IMPL_SCRIPT}
    if [[ ${VIVADO_POST_SYNTH_DCP_FILE_LIST} ]]; then
        if [[ -f ${VIVADO_POST_SYNTH_DCP_FILE_LIST} ]]; then
            while read dcp;
            do
                if [[ ${dcp} ]]; then
                    dcp=\$\{SrcDir\}/${dcp}
                    eval "echo \"${template_read_checkpoint_list}\"" >> ${VIVADO_IMPL_SCRIPT}
                fi
            done < ${VIVADO_POST_SYNTH_DCP_FILE_LIST}
        fi
    else
        eval "echo \"${template_read_checkpoint}\""  >> ${VIVADO_IMPL_SCRIPT}
    fi

    #############
    # gen read xdc
    #############
    if [[ -n "${VIVADO_XDC_FILELIST}" ]]; then
        eval "echo \"${template_read_xdc_header}\"" >> ${VIVADO_IMPL_SCRIPT}
        for xdc in ${VIVADO_XDC_FILELIST[@]}; do
            if [[ -f ${SRC_DIR}/${xdc} ]]; then
                xdc=\$\{SrcDir\}/${xdc}
                eval "echo \"${template_read_xdc}\"" >> ${VIVADO_IMPL_SCRIPT}
            else
                echo -e ${COLOR_ERROR}"[error] file ${SRC_DIR}/${xdc} dosen't exist. "${COLOR_RESET}
            fi
        done
    else
        echo -e ${COLOR_WARNING}"[warning] vivado: xdc files are needed by implementation"${COLOR_RESET}
    fi

    #############
    # gen impl command
    #############
    eval "echo \"${template_impl}\"" >> ${VIVADO_IMPL_SCRIPT}

    #############
    # gen exit command
    #############
    echo "" >> ${VIVADO_IMPL_SCRIPT}
    echo "q" >> ${VIVADO_IMPL_SCRIPT}
}

function vivado_main() {
    if [[ -n "${VIVADO_XCI_FILELIST}" ]]; then
        vivado_replace_xci_path
    fi

    if [[ -n "${VIVADO_BD_FILE}" ]]; then
        vivado_replace_bd_path
    fi

    vivado_make_directoies
    vivado_gen_entry
    vivado_gen_functions

    if [[ -n "${VIVADO_VERILOG_FILELIST}" ]]; then
        vivado_gen_filelist
        vivado_gen_synth
    else
        echo -e ${COLOR_ERROR}"[error] no file list"${COLOR_RESET}
    fi

    vivado_gen_impl
}

function vcs_gen_directry() {
    mkdir -p ${VCS_DIR}
}

function vcs_gen_setup() {
    echo -e ${COLOR_INFO}"[info] vcs: generate vcs setup script"${COLOR_RESET}

    template_setup=$(cat ${VCS_TEMPLATE_SETUP})
    eval "echo \"${template_setup}\"" > ${VCS_SETUP_SCRIPT}
}

function _vcs_gen_post_synth_sim_filelist() {
    echo -e ${COLOR_INFO}"[info] vcs: generate post synth simulation filelist"${COLOR_RESET}
    filelist_set=""
    
    for verilog in ${VIVADO_SIM_FILELIST[@]}; do
        if [[ -f ${SRC_DIR}/${verilog} ]]; then
            if [[ ${filelist_set} ]]; then
                filelist_set="${filelist_set} ${SRC_DIR}/${verilog}"
            else
                filelist_set="${SRC_DIR}/${verilog}"
            fi
        else
            echo -e ${COLOR_ERROR}"[error] file ${SRC_DIR}/${verilog} dosen't exist. "${COLOR_RESET}
        fi
    done

    filelist_set="${filelist_set} ${VIVADO_SYN_DIR}/${VIVADO_TOP_MODULES}.post_synth.funcsim_synth_netlist.v"

    filelist_set=( ${filelist_set} )
    echo "" > ${VCS_SIM_FILELIST}
    for file in ${filelist_set[*]}; do
        echo ${file} >> ${VCS_SIM_FILELIST}
    done
}

function _vcs_gen_rtl_sim_filelist() {
    echo -e ${COLOR_INFO}"[info] vcs: generate rtl simulation filelist"${COLOR_RESET}

    filelist_set=""
    # rtl file
    if [[ -n "${VIVADO_VERILOG_FILELIST}" ]]; then
        for verilog in ${VIVADO_VERILOG_FILELIST[@]}; do
            if [[ -f ${SRC_DIR}/${verilog} ]]; then
                if [[ ${filelist_set} ]]; then
                    filelist_set="${filelist_set} ${SRC_DIR}/${verilog}"
                else
                    filelist_set="${SRC_DIR}/${verilog}"
                fi
            else
                echo -e ${COLOR_ERROR}"[error] file ${SRC_DIR}/${verilog} dosen't exist. "${COLOR_RESET}
            fi
        done
    fi

    # ip file
    if [[ -n "${VIVADO_XCI_FILELIST}" ]]; then
        for xci in ${VIVADO_XCI_FILELIST[@]}; do
            if [[ -f ${SRC_DIR}/${xci} ]]; then
                xci_basename=`basename ${xci} .xci`
                ip_sim_file=${VIVADO_IP_GENERATE_DIR}/${xci_basename}/${xci_basename}_sim_netlist.v
                filelist_set="${filelist_set} ${ip_sim_file}"
            else
                echo -e ${COLOR_ERROR}"[error] file ${SRC_DIR}/${xci} dosen't exist. "${COLOR_RESET}
            fi
        done
    fi

    for verilog in ${VIVADO_SIM_FILELIST[@]}; do
        if [[ -f ${SRC_DIR}/${verilog} ]]; then
            if [[ ${filelist_set} ]]; then
                filelist_set="${filelist_set} ${SRC_DIR}/${verilog}"
            else
                filelist_set="${SRC_DIR}/${verilog}"
            fi
        else
            echo -e ${COLOR_ERROR}"[error] file ${SRC_DIR}/${verilog} dosen't exist. "${COLOR_RESET}
        fi
    done

    # glbl
    filelist_set="${filelist_set} ${VIVADO_BIN_DIR}/../data/verilog/src/glbl.v"
    
    filelist_set=( ${filelist_set} )
    echo "" > ${VCS_SIM_FILELIST}
    for file in ${filelist_set[*]}; do
        echo ${file} >> ${VCS_SIM_FILELIST}
    done

}

function vcs_gen_compile() {
    echo -e ${COLOR_INFO}"[info] vcs: generate compile script"${COLOR_RESET}

    template_compile=$(cat ${VCS_TEMPLATE_COMPILE})

    eval "echo -e \"${template_compile}\"" > ${VCS_COMPILE_SCRIPT}

    if [[ -n "${VIVADO_INC_PATH_FILELIST}" ]]; then
        for line in ${VIVADO_INC_PATH_FILELIST[@]}; do
            if [[ -d ${SRC_DIR}/${line} ]]; then
                inc_dir="${SRC_DIR}/${line}"
                echo "+incdir+\"${inc_dir}\" \\" >> ${VCS_COMPILE_SCRIPT}
            else
                echo -e ${COLOR_ERROR}"[error] directory ${SRC_DIR}/${line} dosen't exist. "${COLOR_RESET}
            fi
        done
    fi

    echo "-f ${VCS_SIM_FILELIST}" >> ${VCS_COMPILE_SCRIPT}
    chmod +x ${VCS_COMPILE_SCRIPT}
}

function vcs_gen_elaborate() {
    echo -e ${COLOR_INFO}"[info] vcs: generate elaborate script"${COLOR_RESET}

    template_elaborate=$(cat ${VCS_TEMPLATE_ELABORATE})
    eval "echo \"${template_elaborate}\"" > ${VCS_ELABORATE_SCRIPT}
    chmod +x ${VCS_ELABORATE_SCRIPT}
}

function vcs_gen_simulate() {
    echo -e ${COLOR_INFO}"[info] vcs: generate simulate script"${COLOR_RESET}

    template_simulate=$(cat ${VCS_TEMPLATE_SIMULATE})
    eval "echo \"${template_simulate}\"" > ${VCS_SIMUALTE_SCRIPT}
    chmod +x ${VCS_SIMUALTE_SCRIPT}
}

function vcs_gen_verdi() {
    echo -e ${COLOR_INFO}"[info] vcs: generate verdi script"${COLOR_RESET}

    template_verdi=$(cat ${VCS_TEMPLATE_VERDI})
    eval "echo \"${template_verdi}\"" > ${VCS_VERDI_SCRIPT}
    chmod +x ${VCS_VERDI_SCRIPT}
}

function vcs_main() {
    if [[ -n "${VIVADO_SIM_FILELIST}" ]]; then
        vcs_gen_directry
        if [[ ${VCS_SIM_MODE} == "RTL" ]]; then
            _vcs_gen_rtl_sim_filelist
        elif [[ ${VCS_SIM_MODE} == "POST_SYNTH" ]]; then
            _vcs_gen_post_synth_sim_filelist
        fi
        vcs_gen_setup
        vcs_gen_compile
        vcs_gen_elaborate
        vcs_gen_simulate
        vcs_gen_verdi
    else
        echo -e ${COLOR_INFO}"[info] vcs: no simulation files. stop to generate vcs"${COLOR_RESET}
    fi
}

function iverilog_gen_directory() {
    mkdir -p ${IVERILOG_DIR}
}

function _iverilog_gen_rtl_sim_filelist() {
    echo -e ${COLOR_INFO}"[info] iverilog: generate rtl simulation filelist"${COLOR_RESET}

    filelist_set=""
    # rtl file
    if [[ -n "${VIVADO_VERILOG_FILELIST}" ]]; then
        for verilog in ${VIVADO_VERILOG_FILELIST[@]}; do
            if [[ -f ${SRC_DIR}/${verilog} ]]; then
                if [[ ${filelist_set} ]]; then
                    filelist_set="${filelist_set} ${SRC_DIR}/${verilog}"
                else
                    filelist_set="${SRC_DIR}/${verilog}"
                fi
            else
                echo -e ${COLOR_ERROR}"[error] file ${SRC_DIR}/${verilog} dosen't exist. "${COLOR_RESET}
            fi
        done
    fi

    for verilog in ${VIVADO_SIM_FILELIST[@]}; do
        if [[ -f ${SRC_DIR}/${verilog} ]]; then
            if [[ ${filelist_set} ]]; then
                filelist_set="${filelist_set} ${SRC_DIR}/${verilog}"
            else
                filelist_set="${SRC_DIR}/${verilog}"
            fi
        else
            echo -e ${COLOR_ERROR}"[error] file ${SRC_DIR}/${verilog} dosen't exist. "${COLOR_RESET}
        fi
    done
    
    # glbl
    filelist_set="${filelist_set} ${VIVADO_BIN_DIR}/../data/verilog/src/glbl.v"

    filelist_set=( ${filelist_set} )
    echo "" > ${IVERILOG_SIM_FILELIST}
    for file in ${filelist_set[*]}; do
        echo ${file} >> ${IVERILOG_SIM_FILELIST}
    done
}

function iverilog_gen_compile() {
    echo -e ${COLOR_INFO}"[info] iverilog: generate compile script"${COLOR_RESET}

    template_compile=$(cat ${IVERILOG_TEMPLATE_COMPILE})
    eval "echo \"${template_compile}\"" > ${IVERILOG_COMPILE_SCRIPT}

    if [[ -n "${VIVADO_INC_PATH_FILELIST}" ]]; then
        for line in ${VIVADO_INC_PATH_FILELIST[@]}; do
            if [[ -d ${SRC_DIR}/${line} ]]; then
                inc_dir="${SRC_DIR}/${line}"
                echo "-I ${inc_dir} \\" >> ${IVERILOG_COMPILE_SCRIPT}
            else
                echo -e ${COLOR_ERROR}"[error] directory ${SRC_DIR}/${line} dosen't exist. "${COLOR_RESET}
            fi
        done
    fi

    echo "-o a.out" >> ${IVERILOG_COMPILE_SCRIPT}

    chmod +x ${IVERILOG_COMPILE_SCRIPT}
}

function iverilog_gen_simulate() {
    echo -e ${COLOR_INFO}"[info] iverilog: generate simulate script"${COLOR_RESET}

    template_simulate=$(cat ${IVERILOG_TEMPLATE_SIMULATE})
    eval "echo \"${template_simulate}\"" > ${IVERILOG_SIMUALTE_SCRIPT}

    chmod +x ${IVERILOG_SIMUALTE_SCRIPT}
}

function iverilog_gen_gtwave() {
    echo -e ${COLOR_INFO}"[info] iverilog: generate gtkwave script"${COLOR_RESET}

    echo "gtkwave ${IVERILOG_VCD_FILE}" > ${IVERILOG_GTKWAVE_SCRIPT}

    chmod +x ${IVERILOG_GTKWAVE_SCRIPT}
}

function iverilog_main() {
    if [[ -n "${VIVADO_SIM_FILELIST}" ]]; then
        iverilog_gen_directory
        _iverilog_gen_rtl_sim_filelist
        iverilog_gen_compile
        iverilog_gen_simulate
        iverilog_gen_gtwave
    else
        echo -e ${COLOR_INFO}"[info] iverilog: no simulation files. stop to generate iverilog"${COLOR_RESET}
    fi
}

if [[ $# -ge 1 ]]; then
    for i in "$@"; do
        echo -e ${COLOR_INFO}"[info] generator: read ${i}"${COLOR_RESET}
        SRC_DIR=$(dirname $(readlink -f ${i}))
        source ${i}
        source ./template_config.sh
        vivado_main
        if [[ ${VCS_ENABLE} && ${VCS_ENABLE} -ne 0 ]]; then
            vcs_main
        fi
        if [[ ${IVERILOG_ENABLE} && ${IVERILOG_ENABLE} -ne 0 ]]; then
            iverilog_main
        fi
    done
else
    echo -e ${COLOR_ERROR}"[error] generator: need config file. stop"${COLOR_RESET}
fi
