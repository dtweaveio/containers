#!/bin/bash

. /opt/scripts/libs/libos.sh
. /opt/scripts/libs/liblog.sh
. /opt/scripts/hdfs/3.3.4/namenode/env.sh

namenode_initialize() {
  info "** Initialize NameNode **"
  CURRENT_INDEX=$(echo $CURRENT_POD | awk -F '-' '{print $NF}')
  _METADATA_DIR=${DFS_NAME_NODE_NAME_DIR}/current

  if [[ "$CURRENT_INDEX" -eq 0 ]]; then
      if [[ ! -d $_METADATA_DIR ]]; then
        info "** NameNode MetaData not exists process format hdfs **"
        hdfs namenode -format -nonInteractive hdfs-k8s ||
            (rm -rf $_METADATA_DIR; exit 1)
      fi

      _ZKFC_FORMATTED=${_METADATA_DIR}/.hdfs-k8s-zkfc-formatted
      if [[ ! -f $_ZKFC_FORMATTED ]]; then
        info "** ZKFC not exists format ZKFC **"
        #gosu "$HADOOP_DAEMON_USER" hdfs zkfc -formatZK -nonInteractive
        if hdfs zkfc -formatZK -nonInteractive; then
            info "ZK  FC format executed successfully."
            touch $_ZKFC_FORMATTED
        else
            error "ZKFC format failed."
            exit 1
        fi
      fi
  else
    if [[ ! -d $_METADATA_DIR ]]; then
        info "** NameNode Running bootstrapStandby **"
      hdfs namenode -bootstrapStandby -nonInteractive ||
          (rm -rf $_METADATA_DIR; exit 1)
    fi
  fi
}