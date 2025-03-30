# Vivado Template  

[中文文档](README_zh_CN.md)  

## Introduction  

This is a template for automating Vivado project script generation, which also includes simulation scripts for iverilog and VCS. It enables simulation, synthesis, and implementation without opening the GUI.  

## Project Structure  

The project structure is as follows:  

```  
.  
├── example_project         # Example project  
│   ├── rtl                 # RTL files  
│   ├── tb                  # Testbench  
│   ├── xdc                 # Constraint files  
│   └── config.sh           # Project configuration  
└── scripts  
    ├── template            # Script templates  
    ├── vivado_project      # Entry script for generation  
    ├── config.sh           # Blank configuration template  
    └── template_config.sh  # Template configuration  
```  

The `example_project` folder can be replaced with your own project. Use the `vivado_project new` command to generate a `config.sh` in your project.  
The `scripts` folder contains generation scripts and templates. `vivado_project` is the entry script.  

## Usage  

### Installation

Run `install.sh` to install the project.  
If you do not have root permissions, copy the `scripts` folder to your project directory and invoke `vivado_project` using relative paths.  

### Configuration  

In your project folder, generate `config.sh` using:  

```shell  
vivado_project new  
```  

Modify `config.sh` according to your project (refer to the comments inside the file). All paths are relative to the generated `config.sh`.  

### Script Generation  

Run the following command to generate scripts (ensure `config.sh` is properly configured):  

```shell  
vivado_project ./config.sh  
```  

After execution, a folder named after your project (defined in `config.sh`) will be created in the current directory:  

```  
Current Directory  
├── [Project Name]          # Generated scripts folder  
│   ├── iverilog  
│   ├── vcs  
│   └── vivado  
└── config.sh               # Generated configuration file  
```  

- `vivado`: Contains Vivado synthesis and implementation scripts.  
- `vcs`: Contains VCS simulation scripts.  
- `iverilog`: Contains iverilog simulation scripts.  

### Vivado Synthesis and Implementation  

Run the following commands:  

```shell  
cd [Project Name]/vivado  

# Synthesis  
source run_synth  

# Implementation  
source run_impl  
```  

Results are saved in `[Project Name]/vivado/SynOutputDir` and `[Project Name]/vivado/ImplOutputDir`.  

### VCS Simulation  

**Note**: If post-synthesis simulation is required or the project includes IP cores, complete Vivado synthesis first.  

Run the following commands:  

```shell  
cd [Project Name]/vcs  

./compile.sh  
./elaborate.sh  
./simulate.sh  
```  

To open Verdi for waveform viewing:  

```shell  
./verdi.sh  
```  

### Iverilog Simulation  

**Note**: If post-synthesis simulation is required or the project includes IP cores, complete Vivado synthesis first.  

Run the following commands:  

```shell  
cd [Project Name]/iverilog  

./compile.sh  
./simulate.sh  
```  

To open GTKWave for waveform viewing:  

```shell  
./gtkwave.sh  
```  
