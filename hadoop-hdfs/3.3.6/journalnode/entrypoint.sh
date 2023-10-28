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
. /opt/scripts/hdfs/3.3.6/journalnode/env.sh

print_welcome_page

if [[ $DEBUG_MODEL == true ]]; then
  info ************** env-start **************
  env
  info ************** env-end **************
fi

if [[ "$*" = *"/opt/scripts/hdfs/3.3.6/journalnode/run.sh"* || "$*" = *"/run.sh"* ]]; then
    info "** Starting JournalNode setup **"
    /opt/scripts/hdfs/3.3.6/journalnode/post-start.sh
    info "** JournalNode setup finished! **"
fi

echo ""
exec "$@"