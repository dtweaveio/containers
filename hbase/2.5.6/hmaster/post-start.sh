#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/scripts/libs/libfs.sh
. /opt/scripts/libs/libos.sh
# Load JournalNode environment variables
. /opt/scripts/hbase/2.5.6/hmaster/env.sh
. /opt/scripts/hbase/2.5.6/hmaster/hbase.sh

# Ensure HMaster user and group exist when running as 'root'
if am_i_root; then
    ensure_user_exists "$HBASE_DAEMON_USER" --uid 10000 --group "$HBASE_DAEMON_GROUP"
    HBASE_OWNERSHIP_USER="$HBASE_DAEMON_USER"
else
    HBASE_OWNERSHIP_USER=""
fi
# Ensure directories used by HMaster exist and have proper ownership and permissions
for dir in "$HBASE_DATA_DIR" "$HBASE_HOME" "$HBASE_CONF_DIR" "$HBASE_LOG_DIR" "$HADOOP_CONF_DIR"; do
    ensure_dir_exists "$dir" "$HBASE_OWNERSHIP_USER"
done