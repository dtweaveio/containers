#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/scripts/libs/liblog.sh
. /opt/scripts/libs/lib.sh
. /opt/scripts/libs/libnet.sh

# Load JournalNode environment variables
. /opt/scripts/hdfs/3.3.4/journalnode/env.sh

print_welcome_page

if [[ $DEBUG_MODEL == true ]]; then
  info ************** env-start **************
  env
  info ************** env-end **************
fi

if [[ $WAIT_ZK_TO_READY == true ]]; then
  ZOOKEEPER_HOSTNAME=$(echo "$ZOOKEEPER_ENDPOINTS" | cut -d':' -f1)
  echo "Waiting zookeeper to start..."
  wait_for_dns_lookup "$ZOOKEEPER_HOSTNAME" 30 5
fi
echo "Wait zookeeper started successfully."

if [[ "$*" = *"/opt/scripts/hdfs/3.3.4/journalnode/run.sh"* || "$*" = *"/run.sh"* ]]; then
    info "** Starting JournalNode setup **"
    /opt/scripts/hdfs/3.3.4/journalnode/post-start.sh
    info "** JournalNode setup finished! **"
fi

echo ""
exec "$@"