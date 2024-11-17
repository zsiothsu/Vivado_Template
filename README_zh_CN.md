# Vivado Template

[English](README.md)

## 简介

这是一个自动化生成 Vivado 项目脚本的模板，也包含了 iverilog 和 vcs 的仿真脚本。在不用开启GUI的情况下就可以实现仿真、综合和实现。

## 项目结构

项目结构如下：

```
.
├── example_project         # 示例项目
│   ├── rtl                 # 项目的rtl文件
│   ├── tb                  # testbench
│   ├── xdc                 # 约束文件
│   └── config.sh           # 项目配置
└── scripts
    ├── template            # 脚本模板
    ├── gen_project.sh      # 生成脚本
    └── template_config.sh  # 模板配置

```

`example_project` 文件夹可以被替换为你自己的项目，只要把 `config.sh` 复制过去即可。
`scripts` 文件夹包含了项目的生成脚本和一些模板，`gen_project.sh` 是入口文件

## 使用方式

### 配置项目

根据你的项目修改 `config.sh`，可以参考 `config.sh` 内部的说明。所有路径都是相对于 `config.sh` 的路径

### 生成脚本

使用以下指令进行脚本的生成，当然，config.sh 记得替换为自己的

```shell
cd scripts
./gen_project.sh ../example_project/config.sh
```

生成完毕之后，`scripts` 目录下会生成一个以你的项目名称（在`config.sh`里面设置）命名的文件夹。

```
scripts
├── 你的项目名称          # 生成的脚本文件夹
│   ├── iverilog
│   ├── vcs
│   └── vivado
├── template            # 脚本模板
├── gen_project.sh      # 生成脚本
└── template_config.sh  # 模板配置
```

其中，`vivado` 包含了 vivado 的综合和实现脚本，`vcs` 包含了vcs的仿真脚本， `iverilog` 包含了 iverilog 的仿真脚本

### Vivado 综合和实现

使用以下指令进行综合和实现

```
cd 你的项目名称/vivado

# 综合项目
source run_synth

# 实现项目
source run_impl 
```

结果分别位于 `你的项目名称/vivado/SynOutputDir` 和 `你的项目名称/vivado/ImplOutputDir`

### Vcs 仿真

如果进行的是综合后仿真，或者项目含有 ip 核，请务必先进行 vivado 综合。

使用以下指令进行仿真

```shell
cd 你的项目名称/vcs

./compile.sh
./elaborate.sh
./simulate.sh
```

使用以下指令可以开启 verdi 查看波形

```shell
./verdi.sh
```

### Iverilog 仿真

如果进行的是综合后仿真，或者项目含有 ip 核，请务必先进行 vivado 综合。

使用以下指令进行仿真

```shell
cd 你的项目名称/iverilog

./compile.sh
./simulate.sh
```

使用以下指令可以开启 gtkwave 查看波形

```shell
./gtkwave.sh
```