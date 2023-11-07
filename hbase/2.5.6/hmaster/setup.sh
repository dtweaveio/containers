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
. /opt/scripts/hbase/2.5.6/hmaster/env.sh

ensure_user_exists "$HBASE_DAEMON_USER" --uid 10000 --group "$HBASE_DAEMON_GROUP"

# Ensure directories used by HMaster exist and have proper ownership and permissions
for dir in "$HBASE_DATA_DIR" "$HBASE_HOME" "$HBASE_CONF_DIR" "$HBASE_LOG_DIR" "$HADOOP_CONF_DIR"; do
    ensure_dir_exists "$dir"
done

chown -R "$HBASE_DAEMON_USER":"$HBASE_DAEMON_GROUP" $HBASE_HOME_DIR
chown -R "$HBASE_DAEMON_USER":"$HBASE_DAEMON_GROUP" $HBASE_DATA_DIR
chown -R "$HBASE_DAEMON_USER":"$HBASE_DAEMON_GROUP" $HADOOP_DATA_DIR
chown -R "$HBASE_DAEMON_USER":"$HBASE_DAEMON_GROUP" "/tmp"