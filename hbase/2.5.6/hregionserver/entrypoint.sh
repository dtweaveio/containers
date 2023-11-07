#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/scripts/libs/liblog.sh
. /opt/scripts/libs/lib.sh

# Load HMaster environment variables
. /opt/scripts/hbase/2.5.6/regionserver/env.sh

print_welcome_page

if [[ $DEBUG_MODEL == true ]]; then
  info ************** env-start **************
  env
  info ************** env-end **************
fi

if [[ "$*" = *"/opt/scripts/hbase/2.5.6/regionserver/run.sh"* || "$*" = *"/run.sh"* ]]; then
    info "** HRegionServer setup **"
    /opt/scripts/hbase/2.5.6/regionserver/post-start.sh
    info "** HRegionServer setup finished! **"
fi

echo ""
exec "$@"