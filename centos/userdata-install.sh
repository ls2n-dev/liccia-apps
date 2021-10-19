#!/bin/bash
# called by ansible process - system-update.yaml
#

usermod -aG docker centos
mkdir -p /etc/docker 2>/dev/null
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
cat<<EOF1 | tee /etc/docker/daemon.json
{
   "bip": "192.168.250.1/24",
   "mtu": 1500
}
EOF1
systemctl daemon-reload 
systemctl restart docker.service
pkill -SIGHUP dockerd
