#!/bin/bash
# Inspired from https://gitlab.in2p3.fr/ifb-biosphere/apps/ubuntu-ifb
# Hacked for LICCiA Environment
#

CONDA_SHELL=Miniconda3-latest-Linux-x86_64.sh
CONDA_DIR=/var/lib/miniconda3
#LOG_DEPLOYMENT=/var/log/miniconda-deploy.log

liccia_log "Miniconda3 installation in progress.."

# Install miniconda:latest
# 191025: Add a time-out limit on miniconda installation
curl -LJO --connect-timeout 10 https://repo.continuum.io/miniconda/$CONDA_SHELL
if [ ! -e $CONDA_SHELL ]; then
   liccia_log ERROR "Miniconda3 installation timed out"
   exit
fi
timeout 1m bash $CONDA_SHELL -b -u -p $CONDA_DIR
if [ $? -ne 0 ]; then
   liccia_log ERROR  "Miniconda3 installation timed out"
   exit
fi
rm $CONDA_SHELL

liccia_log "Miniconda3 configuration environment.."

# Configure conda environment
ln -s $CONDA_DIR/etc/profile.d/conda.sh /etc/profile.d/conda.sh
source /etc/profile.d/conda.sh

chgrp -R ubuntu $CONDA_DIR
chmod -R g+w $CONDA_DIR

## Add conda channels
# conda config --add channels bioconda --system
conda config --add channels R --system
conda config --add channels conda-forge --system

## Install Mamba (and update to the very last version of conda)
conda install -n base -c conda-forge mamba

liccia_log "Miniconda3 installation done!"
