#!/bin/bash -lxe
# Run without a sudo prefixed.
#
sudo apt update && \
sudo apt install -y python3 python3-dev git curl wget && \
conda update -n base -c defaults conda && \
curl -L https://tljh.jupyter.org/bootstrap.py | sudo -E python3 - --admin jupyadmin
