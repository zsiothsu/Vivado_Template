# Vivado Template

[简体中文](README_zh_CN.md)

## Introduction

This is a template for automatically generating Vivado project scripts, which also includes simulation scripts for iverilog and vcs. It enables simulation, synthesis, and implementation without the need to open the GUI.

## Project Structure

The project structure is as follows:

```
.
├── example_project         # Example project
│   ├── rtl                 # Project's RTL files
│   ├── tb                  # Testbenches
│   ├── xdc                 # Constraint files
│   └── config.sh           # Project configuration
└── scripts
    ├── template            # Script templates
    ├── gen_project.sh      # Script generation script
    └── template_config.sh  # Template configuration

```

The `example_project` folder can be replaced with your own project by simply copying the `config.sh` over.

The `scripts` folder contains project generation scripts and some templates. The `gen_project.sh` is the entry file.

## Usage

### Configuring the Project

Modify `config.sh` according to your project, referring to the internal guides. All paths are relative to the `config.sh` path.

### Generating Scripts

Generate the scripts using the following command, of course, remember to replace `config.sh` with your own.

```shell
cd scripts
./gen_project.sh ../example_project/config.sh
```

After generation, a folder named by your project (set inside `config.sh`) will be created under the `scripts` directory.

```
scripts
├── Your-Project-Name   # Generated scripts folder
│   ├── iverilog
│   ├── vcs
│   └── vivado
├── template            # Script templates
├── gen_project.sh      # Script generation script
└── template_config.sh  # Template configuration
```

Here, `vivado` contains the synthesis and implementation scripts for Vivado, `vcs` contains the simulation scripts for vcs, and `iverilog` contains the simulation scripts for iverilog.

### Vivado Synthesis and Implementation

Use the following commands for synthesis and implementation:

```
cd Your-Project-Name/vivado

# Synthesis project
source run_synth

# Implementation project
source run_impl 
```

The results are located in `Your-Project-Name/vivado/SynOutputDir` and `Your-Project-Name/vivado/ImplOutputDir` respectively.

### Vcs Simulation

If you are performing post-synthesis simulation or your project contains IP cores, be sure to perform Vivado synthesis first.

Use the following commands for simulation:

```shell
cd Your-Project-Name/vcs

./compile.sh
./elaborate.sh
./simulate.sh
```

Use the following command to open verdi to view the waveforms:

```shell
./verdi.sh
```

### Iverilog Simulation

If you are performing post-synthesis simulation or your project contains IP cores, be sure to perform Vivado synthesis first.

Use the following commands for simulation:

```shell
cd Your-Project-Name/iverilog

./compile.sh
./simulate.sh
```

Use the following command to open gtkwave to view the waveforms:

```shell
./gtkwave.sh
```
