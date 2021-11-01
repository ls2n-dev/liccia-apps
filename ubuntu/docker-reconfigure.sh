#!/bin/bash
#
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
