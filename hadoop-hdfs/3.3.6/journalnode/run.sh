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
. /opt/scripts/hdfs/3.3.6/journalnode/env.sh

START_COMMAND=("${HADOOP_HOME}/bin/hdfs" "journalnode" "$@")

info "** Starting JournalNode **"
if am_i_root; then
    exec_as_user "$HADOOP_DAEMON_USER" "${START_COMMAND[@]}"
else
    exec "${START_COMMAND[@]}"
fi