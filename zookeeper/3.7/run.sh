#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/scripts/libs/libos.sh
. /opt/scripts/libs/liblog.sh
. /opt/scripts/zookeeper/3.7/zookeeper.sh

# Load ZooKeeper environment variables
. /opt/scripts/zookeeper/3.7/env.sh

START_COMMAND=("${ZOO_BASE_DIR}/bin/zkServer.sh" "start-foreground" "$@")

info "** Starting ZooKeeper **"
if am_i_root; then
    exec_as_user "$ZOO_DAEMON_USER" "${START_COMMAND[@]}"
else
    exec "${START_COMMAND[@]}"
fi