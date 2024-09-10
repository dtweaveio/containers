#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/scripts/libs/libfs.sh
. /opt/scripts/libs/libos.sh
. /opt/scripts/hive/3.1.3/metastore/env.sh
. /opt/scripts/hive/3.1.3/metastore/hms.sh

# Ensure DataNode user and group exist when running as 'root'
if am_i_root; then
    ensure_user_exists "$HIVE_DAEMON_USER" --uid 10000 --group "$HIVE_DAEMON_GROUP"
    HIVE_OWNERSHIP_USER="$HIVE_DAEMON_USER"
else
    HIVE_OWNERSHIP_USER=""
fi

# Ensure directories used by JournalNode exist and have proper ownership and permissions
for dir in "$HIVE_HOME_DIR" "$HIVE_CONF_DIR" "$HIVE_DATA_DIR"; do
    ensure_dir_exists "$dir" "$HIVE_OWNERSHIP_USER"
done

metastore_initialize