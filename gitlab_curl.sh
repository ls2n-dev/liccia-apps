#!/bin/bash

# initialize gitlab setup project environment
#

[ -z "$GITLAB_TOKEN" ] && export GITLAB_TOKEN=$1 && shift
export GITLAB_SERVER="https://gitlab.univ-nantes.fr/api/v4"
export GITLAB_GROUP_ID=9147
export GITLAB_PROJECT_ID=10925
export GITLAB_FILE=$1

if [ -z "$GITLAB_TOKEN" ]; then
  echo "*ERROR* Please set the GITLAB_TOKEN variable"
  return 1
fi

# get global setup
curl -sSLf --header "PRIVATE-TOKEN: $GITLAB_TOKEN" \
     -XGET "${GITLAB_SERVER}/projects/$GITLAB_PROJECT_ID/repository/files/${GITLAB_FILE}/raw" 2>/dev/null
