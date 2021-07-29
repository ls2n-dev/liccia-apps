#!/bin/bash

cat<<EOF | tee $HOME/.liccia-output.log
-- start-configuration: `date`
EOF

sudo dpkg --configure -a
sudo apt update && sudo apt install -y python3 python3-dev python3-pip git curl wget
curl -s https://get.docker.com | sh && sudo systemctl --now enable docker
sudo usermod -aG docker ubuntu
sudo mkdir -p /etc/systemd/system/docker.service.d
cat<<EOF | sudo tee /etc/systemd/system/docker.service.d/proxy.conf
[Service]
Environment="HTTP_PROXY=http://172.20.12.74:3128"
Environment="HTTPS_PROXY=http://172.20.12.74:3128"
Environment="NO_PROXY=localhost,127.0.0.1,169.254.169.254,172.20.0.0/16,::1"
EOF
sudo systemctl daemon-reload 
sudo systemctl restart docker.service
distribution=$(. /etc/os-release;echo $ID$VERSION_ID) \
   && curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add - \
   && curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
sudo apt update
cat<<EOFF | sudo tee -a /etc/profile.d/ls2n.sh
export NVIDIA_CUDA_VERSION=$(/usr/bin/nvidia-smi | head -3  | grep "CUDA Version" | tr -d '|' | awk -F': ' '{print $3}')
export NVIDIA_DRIVER_VERSION=$(/usr/bin/nvidia-smi | head -3  | grep "NVIDIA-SMI" | tr -d '|' | awk '{print $2}')
EOFF
sudo apt-get install -y nvidia-docker2
cat<<EOF | sudo tee /etc/docker/daemon.json
{
   "bip": "192.168.250.1/24",
   "mtu": 1500,
    "runtimes": {
        "nvidia": {
            "path": "/usr/bin/nvidia-container-runtime",
            "runtimeArgs": []
        }
    }
}
EOF
sudo systemctl daemon-reload
sudo pkill -SIGHUP dockerd
sudo apt install -y python3-dev python3-pip python3-venv
#sudo apt -y upgrade

cat<<EOF | tee -a $HOME/.liccia-output.log
-- end-configuration: `date`
EOF
chown ubuntu: $HOME/.liccia-output.log
