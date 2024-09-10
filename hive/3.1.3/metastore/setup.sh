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
. /opt/scripts/hive/3.1.3/metastore/env.sh

ensure_user_exists "$HIVE_DAEMON_USER" --uid 10000 --group "$HIVE_DAEMON_GROUP"

# Ensure directories used by ZooKeeper exist and have proper ownership and permissions
for dir in "$HIVE_HOME_DIR" "$HIVE_CONF_DIR" "$HIVE_DATA_DIR"; do
    ensure_dir_exists "$dir"
done

chown -R "$HIVE_DAEMON_USER":"$HIVE_DAEMON_GROUP" $HIVE_HOME_DIR
chown -R "$HIVE_DAEMON_USER":"$HIVE_DAEMON_GROUP" $HIVE_CONF_DIR
chown -R "$HADOOP_DAEMON_USER":"$HADOOP_DAEMON_GROUP" $HADOOP_HOME_DIR
chown -R "$HADOOP_DAEMON_USER":"$HADOOP_DAEMON_GROUP" $HADOOP_DATA_DIR