#!/bin/bash
#
# called by ansible process - system-update.yaml
#
# Add Docker’s official GPG key
#curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
#echo \
#  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
#  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

usermod -aG docker ubuntu
mkdir -p /etc/systemd/system/docker.service.d
cat<<EOF | tee /etc/systemd/system/docker.service.d/proxy.conf
[Service]
Environment="HTTP_PROXY=http://172.20.12.74:3128"
Environment="HTTPS_PROXY=http://172.20.12.74:3128"
Environment="NO_PROXY=localhost,127.0.0.1,169.254.169.254,172.20.0.0/16,::1"
EOF
#
# Configure docker to use specific local data root for images
# append this line below in the daemon.json file before the value "bip"
# be sure the ',' is present and the end of the line
#   "data-root": "/specify/the/absolute/path/dir",
#
cat<<EOFD | sudo tee /etc/docker/daemon.json
{
   "bip": "192.168.250.1/24",
   "mtu": 1500,
   "data-root": "/opt/data/docker",
   "runtimes": {
        "nvidia": {
            "path": "/usr/bin/nvidia-container-runtime",
            "runtimeArgs": []
        }
    }
}
EOFD
systemctl daemon-reload 
systemctl restart docker.service
pkill -SIGHUP dockerd
