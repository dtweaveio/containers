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
. /opt/scripts/hdfs/3.3.4/namenode/env.sh

START_COMMAND=("${HADOOP_HOME}/bin/hdfs" "namenode" "$@")

info "** Starting NameNode **"
if am_i_root; then
  info "** Starting zkfc **"
  exec_as_user "$HADOOP_DAEMON_USER" hadoop-daemon.sh start zkfc

  info "** Starting namenode **"
  exec_as_user "$HADOOP_DAEMON_USER" "${START_COMMAND[@]}"
  #exec gosu "$HADOOP_DAEMON_USER" hdfs --config $HADOOP_CONF_DIR namenode
else
  info "** Starting zkfc **"
  hadoop-daemon.sh start zkfc

  info "** Starting namenode **"
  exec "${START_COMMAND[@]}"
fi
