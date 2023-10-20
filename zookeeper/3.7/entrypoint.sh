#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/scripts/libs/liblog.sh
. /opt/scripts/libs/lib.sh

# Load ZooKeeper environment variables
. /opt/scripts/zookeeper/3.7/env.sh

print_welcome_page
info ************** env **************
env
info ************** env **************

if [[ "$*" = *"/opt/scripts/zookeeper/3.7/run.sh"* || "$*" = *"/run.sh"* ]]; then
    info "** Starting ZooKeeper setup **"
    /opt/scripts/zookeeper/3.7/post-start.sh
    info "** ZooKeeper setup finished! **"
fi

echo ""
exec "$@"