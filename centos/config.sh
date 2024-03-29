#!/bin/bash

# This script can be used to apply the complete configuration of this LICCiA Base System
# to a virtual machine

APP_FLAVOR=centos
APP_NAME=liccia-apps
APP_REPO="https://github.com/ls2n-dev/${APP_NAME}.git"
APP_DIR="/opt/liccia"
APP_GIT="${APP_DIR}/git/${APP_NAME}"

yum -y install git
chown ${APP_FLAVOR}: $APP_DIR && mkdir -p `dirname $APP_GIT` && git clone ${APP_REPO} ${APP_GIT} && chown -R ${APP_FLAVOR}: $APP_GIT && \
cd ${APP_GIT}/${APP_FLAVOR} && {
  pwd
  source profile_liccia.sh
  source profile_funcs.sh
  liccia_log INFO "start configuration process"
  source install.sh
}
