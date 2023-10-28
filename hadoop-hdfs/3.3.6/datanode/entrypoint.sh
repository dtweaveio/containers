#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/scripts/libs/liblog.sh
. /opt/scripts/libs/lib.sh

# Load JournalNode environment variables
. /opt/scripts/hdfs/3.3.6/datanode/env.sh

print_welcome_page

if [[ "$*" = *"/opt/scripts/hdfs/3.3.6/datanode/run.sh"* || "$*" = *"/run.sh"* ]]; then
    info "** Starting NameNode setup **"
    /opt/scripts/hdfs/3.3.6/datanode/post-start.sh
    info "** NameNode setup finished! **"
fi

echo ""
exec "$@"