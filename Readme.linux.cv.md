# Getting started with Sinara ML

## Prerequisites
Sinara ML components can be run on Linux. Following software should be installed:
- Git
- Unzip
- Proprietary Nvidia GPU driver (noveau driver doesn't support CUDA)
- Nvidia container toolkit
- Docker

## Setup prerequisites
### Setup git
Use official manual at https://git-scm.com/download/linux

### Setup unzip
Ubuntu and Debian:
```
sudo apt-get install unzip
```

### Setup nvidia drivers
1. Use nvidia official installation manual for your linux distribution at https://docs.nvidia.com/datacenter/tesla/tesla-installation-notes/index.html#abstract<br>
    <span style="color: red;">**Only driver version 515 and above is suitable for running sinara ML with NVIDIA CUDA support**</span>

### Setup Nvidia container toolkit
1. Use nvidia official installation manual for your linux distribution at https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html#installing-the-nvidia-container-toolkit

### Setup Docker on Linux
1. Download and install docker using package manager of your linux distribution
- Official guides at https://docs.docker.com/engine/install/#supported-platforms<br>
    You don't need to change default docker container runtime to "nvidia" for sinara server to work, all available GPUs will be connected to container automatically

## Deploy and run Sinara server on your linux system
Clone sinara-ext-tools repo with sinara server CLI tools:
```
git clone --recursive https://github.com/4-DS/sinara-ext-tools.git && \
cd sinara-ext-tools
```
Create Sinara server container:<br>
```
bash create.sh
```
    When asked "Please, choose a Sinara for ML(n) or CV(y) projects:" - input "y" letter
Run Sinara server container:<br>
```
bash run.sh
```
