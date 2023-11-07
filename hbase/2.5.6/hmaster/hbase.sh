#!/bin/bash

. /opt/scripts/libs/libos.sh
. /opt/scripts/libs/liblog.sh
. /opt/scripts/hbase/2.5.6/hmaster/env.sh

hbase_master_initialize() {
  info "** Initialize HBaseMaster **"
  CURRENT_INDEX=$(echo $KB_POD_NAME | awk -F '-' '{print $NF}')

  # Master
  if [[ "$CURRENT_INDEX" -eq 0 ]]; then
    if [ ! -f "$HBASE_MASTER_DIR" ]; then
        echo "backup-masters not exists create it..."
        touch "$HBASE_MASTER_DIR"
        local FQDN=$(printf "%s-%s-%d.%s" $KB_CLUSTER_NAME $KB_COMP_NAME 1 $HEADLESS_SERVICE_NAME)
        echo "write $FQDN to backup-masters..."
        echo "$FQDN" >> "$HBASE_MASTER_DIR"
    fi
  fi
}