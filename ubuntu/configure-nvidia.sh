#!/bin/bash
#
distribution=$(. /etc/os-release;echo $ID$VERSION_ID) \
   && curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add - \
   && curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
sudo apt update
cat<<EOFF | sudo tee -a /etc/profile.d/ls2n.sh
export NVIDIA_CUDA_VERSION=$(/usr/bin/nvidia-smi | head -3  | grep "CUDA Version" | tr -d '|' | awk -F': ' '{print $3}')
export NVIDIA_DRIVER_VERSION=$(/usr/bin/nvidia-smi | head -3  | grep "NVIDIA-SMI" | tr -d '|' | awk '{print $2}')
EOFF
