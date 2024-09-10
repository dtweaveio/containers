#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/scripts/libs/liblog.sh
. /opt/scripts/libs/lib.sh

# Load environment variables
. /opt/scripts/hive/3.1.3/metastore/env.sh

print_welcome_page

if [[ $DEBUG_MODEL == true ]]; then
  info ************** env-start **************
  env
  info ************** env-end **************
  info ************** conf-start **************
  cat $HIVE_CONF_DIR/hive-site.xml
  info ************** conf-start **************
fi

if [[ "$*" = *"/opt/scripts/hive/3.1.3/metastore/run.sh"* || "$*" = *"/run.sh"* ]]; then
    info "** Starting HMS setup **"
    /opt/scripts/hive/3.1.3/metastore/post-start.sh
    info "** HMS setup finished! **"
fi

echo ""
exec "$@"