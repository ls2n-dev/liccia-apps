#!/bin/bash
# Inspired from https://gitlab.in2p3.fr/ifb-biosphere/apps/ubuntu-ifb
# Hacked for LICCiA Environment

# This script is executed on the virtual machine during the Installation phase (need to be ran as root!).
# It is used to record a predefined VM-image of the appliance.
# Otherwise executed first during a cloud deployement in OS-BIRD Infra

# Initialization
source profile_liccia.sh
source profile_funcs.sh

# Install Ansible
liccia_log "ansible installation in progress.."
export DEBIAN_FRONTEND=noninteractive
APT_OPT=""
DIST_CODENAME=$(lsb_release -cs)
if [ $(lsb_release -is) = "Debian" ]; then
    apt-get install -y software-properties-common dirmngr
	if [[ $DIST_CODENAME == "stretch" || $DIST_CODENAME == "buster" ]]; then
        apt-add-repository "deb http://deb.debian.org/debian ${DIST_CODENAME}-backports main";
    fi
    APT_OPT="-t ${DIST_CODENAME}-backports --allow-unauthenticated"
    apt-get -y --allow-unauthenticated dist-upgrade
elif [ $DIST_CODENAME != "focal" ]; then
    apt-add-repository -y ppa:ansible/ansible
fi
apt-get update
apt-get install $APT_OPT -y ansible
liccia_log "ansible installation done!"

# Run app playbook
liccia_log "updating system with ansible.."
liccia_log CMD "ansible-playbook -c local -i 127.0.0.1, -b -e 'ansible_python_interpreter=/usr/bin/python3' system-update.yaml"
ansible-playbook -c local -i 127.0.0.1, -b -e 'ansible_python_interpreter=/usr/bin/python3' system-update.yaml
