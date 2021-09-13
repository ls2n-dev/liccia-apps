#!/bin/bash

# This script can be used to apply the complete configuration of this LICCiA Base System
# to a virtual machine

APP_NAME=liccia-ubuntu
APP_REPO="https://github.com/ls2n-dev/liccia-apps.git"
APP_DIR="/opt/liccia"
APP_GIT="${APP_DIR}/git/${APP_NAME}"

mkdir -p `dirname $APP_GIT` && chown ubuntu: `dirname $APP_DIR` && git clone ${APP_REPO} ${APP_GIT} && \
cd ${APP_GIT}/ubuntu && {
  source profile_liccia.sh
  source profile_funcs.sh
  liccia_log INFO "start configuration process"
  source install.sh
}
