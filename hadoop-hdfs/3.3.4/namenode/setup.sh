#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/scripts/libs/libfs.sh
. /opt/scripts/libs/libos.sh

# Load ZooKeeper environment variables
. /opt/scripts/hdfs/3.3.4/namenode/env.sh

ensure_user_exists "$HADOOP_DAEMON_USER" --uid 10000 --group "$HADOOP_DAEMON_GROUP"

# Ensure directories used by ZooKeeper exist and have proper ownership and permissions
for dir in "$HADOOP_DATA_DIR" "$HADOOP_VOLUME_DIR" "$DFS_NAME_NODE_NAME_DIR" "$DFS_JOURNAL_NODE_EDITS_DIR" "$HADOOP_CONF_DIR" "$HADOOP_LOG_DIR"; do
    ensure_dir_exists "$dir"
done

chown -R "$HADOOP_DAEMON_USER":"$HADOOP_DAEMON_GROUP" $HADOOP_HOME_DIR
chown -R "$HADOOP_DAEMON_USER":"$HADOOP_DAEMON_GROUP" $HADOOP_DATA_DIR