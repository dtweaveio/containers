#!/bin/bash

test(){
  export KB_CLUSTER_NAME=zk
  export KB_COMP_NAME=zookeeper
  export KB_NAMESPACE=default
  export CLUSTER_DOMAIN=cluster.local
  export podIndex=1
  export headlessServiceName=$(printf "%s-%s-%s.%s.svc.%s" $KB_CLUSTER_NAME $KB_COMP_NAME headless $KB_NAMESPACE $CLUSTER_DOMAIN)

  echo "backup-masters not exists create it..."
  local FQDN=$(printf "%s-%s-%d.%s" $KB_CLUSTER_NAME $KB_COMP_NAME 1 $headlessServiceName)
  echo ${FQDN}
  echo "write ${FQDN} to backup-masters..."
  #echo "$endpoints" >> "$HBASE_MASTER_DIR"
}

test