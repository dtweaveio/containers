#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/scripts/libs/libos.sh
. /opt/scripts/libs/liblog.sh

# Load HMaster environment variables
. /opt/scripts/hbase/2.5.6/hmaster/env.sh

START_COMMAND=("${HBASE_HOME}/bin/hbase-daemon.sh" "foreground_start" "master" "$@")

if am_i_root; then
  info "** Starting HMaster **"
  exec_as_user "$HBASE_DAEMON_USER" "${START_COMMAND[@]}"
else
  info "** Starting HMaster **"
  #${HBASE_HOME}/bin/hbase-daemon.sh start master
  #tail -f $HBASE_LOGLOG
  exec "${START_COMMAND[@]}"
fi