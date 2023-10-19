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
. /opt/scripts/zookeeper/3.7/env.sh

ensure_user_exists "$ZOO_DAEMON_USER" --uid 10000 --group "$ZOO_DAEMON_GROUP"

# Ensure directories used by ZooKeeper exist and have proper ownership and permissions
for dir in "$ZOO_DATA_DIR" "$ZOO_DATA_LOG_DIR" "$ZOO_CONF_DIR" "$ZOO_LOG_DIR"; do
    ensure_dir_exists "$dir"
done

chown -R "$ZOO_DAEMON_USER":"$ZOO_DAEMON_GROUP" $ZOO_BASE_DIR
chown -R "$ZOO_DAEMON_USER":"$ZOO_DAEMON_GROUP" $ZOO_DATA_DIR