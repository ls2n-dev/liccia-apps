#!/bin/bash -lxe
# Python 3.6
#
export LC_ALL=C
export DISTRIB_CODENAME=$(lsb_release -cs)
cat<<EOF | tee /home/ubuntu/.liccia-output.log
-- start-configuration: `date`
EOF

# Clean up docker installation
apt-get purge -y docker-engine docker docker.io docker-ce docker-ce-cli
apt-get autoremove -y --purge docker-engine docker docker.io docker-ce  
rm -rf /etc/docker /var/lib/docker /etc/apt/sources.list.d/docker.list 2>/dev/null
rm -f /etc/apparmor.d/docker
groupdel docker
rm -rf /var/run/docker.sock

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

python3 -m pip install --upgrade pip 
cat<<EOF | tee -a /home/ubuntu/.liccia-output.log
-- end-configuration: `date`
EOF
chown ubuntu: /home/ubuntu/.liccia-output.log
