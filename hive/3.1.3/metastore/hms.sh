#!/bin/bash

. /opt/scripts/libs/libos.sh
. /opt/scripts/libs/liblog.sh
. /opt/scripts/hive/3.1.3/metastore/env.sh

metastore_initialize() {
  info "** Initialize HiveMetaStore MySql **"

  # 检查环境变量是否存在
  if [[ -z "$DB_TYPE" || -z "$CURRENT_POD" ]]; then
    echo "Error: Required environment variables DB_TYPE or CURRENT_POD are not set."
    exit 1
  fi

  CURRENT_INDEX=$(echo "$CURRENT_POD" | awk -F '-' '{print $NF}')
  INIT_FLAG="/hive/metadata/hive_metastore_initialized"

  # 仅在第一个 pod（索引为0）上进行初始化
  if [[ "$CURRENT_INDEX" -eq 0 ]]; then
    if [[ -f "$INIT_FLAG" ]]; then
      echo "[$(date)] Hive Metastore is already initialized (flag file exists)."
    else
      echo "[$(date)] Hive Metastore is not initialized, starting initialization..."

      # 创建一个临时文件用于保存日志
      TEMP_LOG=$(mktemp)
      
      # 初始化 Hive Metastore 并打印日志
      schematool -dbType "$DB_TYPE" -initSchema -verbose 2>&1 | tee "$TEMP_LOG"
      if [ $? -eq 0 ]; then
        echo "[$(date)] Hive Metastore initialization successful."

        # 创建标志文件，表示初始化完成
        touch "$INIT_FLAG"
      else
        echo "[$(date)] Hive Metastore initialization failed. See log for details:"
        cat "$TEMP_LOG"
        rm -f "$TEMP_LOG"
        exit 1
      fi

      rm -f "$TEMP_LOG" # 删除临时日志文件
    fi
  else
    echo "[$(date)] Not the first pod (CURRENT_INDEX=$CURRENT_INDEX), skipping initialization."
  fi
}
