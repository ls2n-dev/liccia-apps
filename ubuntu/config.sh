#!/bin/bash

# This script can be used to apply the complete configuration of this LICCiA Base System
# to a virtual machine

APP_REPO="https://github.com/ls2n/liccia-vm.git"
APP_DIR="/opt/liccia/git/$APP_NAME"

mkdir -p `dirname $APP_DIR` && git clone ${APP_REPO} ${APP_DIR} && cd ${APP_DIR} && {
  source profile_liccia.sh
  liccia_log INFO "start configuration process"
  source install.sh
  source deploy.sh
}
