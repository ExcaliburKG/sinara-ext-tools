#!/bin/bash

set -e
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get install unzip
sudo apt-get install git

echo -e "\n"
read -p "Install nvidia drivers 515+? Yes(y), No or Don't know(n): " nvidia_drivers_installed

if [[ -z "$nvidia_drivers_installed" || "$nvidia_drivers_installed" == "y" ]]; then
    # install nvidia driver (ubuntu manual)
    # https://ubuntu.com/server/docs/nvidia-drivers-installation
    DRIVER_BRANCH=525
    LINUX_FLAVOUR=generic
    SERVER=""
    sudo apt --purge remove -y '*nvidia*${DRIVER_BRANCH}*' || true
    sudo apt install -y linux-modules-nvidia-${DRIVER_BRANCH}${SERVER}-${LINUX_FLAVOUR}
    sudo apt install -y linux-headers-${LINUX_FLAVOUR}
    sudo apt install -y nvidia-dkms-${DRIVER_BRANCH}${SERVER}
    sudo apt install -y nvidia-driver-${DRIVER_BRANCH}${SERVER}
fi

# install nvidia container toolkit
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
  && curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
    sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
    sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list && \
    sudo apt-get update -y
sudo apt-get install -y nvidia-container-toolkit

# installing docker
# https://docs.docker.com/engine/install/ubuntu

for pkg in docker.io docker-doc docker-compose containerd runc; do sudo apt-get remove -y $pkg; done
# Add Docker's official GPG key:
sudo apt-get update -y
sudo apt-get install -y ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Add the repository to Apt sources:
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update -y

sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo systemctl restart docker
