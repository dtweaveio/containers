#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/scripts/libs/libos.sh
. /opt/scripts/libs/liblog.sh

# Load JournalNode environment variables
. /opt/scripts/hive/3.1.3/metastore/env.sh

START_COMMAND=("${HIVE_HOME_DIR}/bin/hive" "--service" "metastore")

info "** Starting HiveMetaStore **"
if am_i_root; then
    exec_as_user "$HIVE_DAEMON_USER" "${START_COMMAND[@]}"
else
    exec "${START_COMMAND[@]}"
fi