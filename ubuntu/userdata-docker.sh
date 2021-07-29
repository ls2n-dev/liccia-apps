#!/bin/bash -lxe
# source: https://docs.docker.com/engine/install/ubuntu
# Python 3.6
# Docker default 5:19.03.15~3-0
# input DOCKER_VERSION
#
export LC_ALL=C
export DISTRIB_CODENAME=$(lsb_release -cs)

# To find a specific version, run "apt-cache madison docker-ce"
#
export DEFAULT_DOCKER_VERSION="5:19.03.15~3-0"
export DOCKER_VERSION="${DOCKER_VERSION:-${DEFAULT_DOCKER_VERSION}}~ubuntu-${DISTRIB_CODENAME}"
cat<<EOF | tee /home/ubuntu/.liccia-output.log
-- start-configuration: `date`
EOF

# Set up the repository
dpkg --configure -a
apt-get update && \
apt-get install -y python3 python3-dev python3-pip git curl wget \
    apt-transport-https python3-pip python3-venv \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Add Docker’s official GPG key
echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker Engine
apt-get update && \
apt-get install -y docker-ce=${DOCKER_VERSION} docker-ce-cli=${DOCKER_VERSION} containerd.io

usermod -aG docker ubuntu
mkdir -p /etc/systemd/system/docker.service.d
cat<<EOF | tee /etc/systemd/system/docker.service.d/proxy.conf
[Service]
Environment="HTTP_PROXY=http://172.20.12.74:3128"
Environment="HTTPS_PROXY=http://172.20.12.74:3128"
Environment="NO_PROXY=localhost,127.0.0.1,169.254.169.254,172.20.0.0/16,::1"
EOF
cat<<EOF1 | tee /etc/docker/daemon.json
{
   "bip": "192.168.250.1/24",
   "mtu": 1500
}
EOF1
systemctl daemon-reload 
systemctl restart docker.service
pkill -SIGHUP dockerd
python3 -m pip install --upgrade pip 
python3 -m pip install docker-compose 
cat<<EOF | tee -a /home/ubuntu/.liccia-output.log
-- end-configuration: `date`
EOF
chown ubuntu: /home/ubuntu/.liccia-output.log
