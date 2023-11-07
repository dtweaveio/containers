#!/bin/bash
#
# Environment configuration for zookeeper

# The values for all environment variables will be set in the below order of precedence
# 1. Custom environment variables defined below after Bitnami defaults
# 2. Constants defined in this file (environment variables with no default), i.e. BITNAMI_ROOT_DIR
# 3. Environment variables overridden via external files using *_FILE variables (see below)
# 4. Environment variables set externally (i.e. current Bash context/Dockerfile/userdata)

# Load logging library
# shellcheck disable=SC1090,SC1091
. /opt/scripts/libs/liblog.sh

# Paths
export HBASE_HOME_DIR="/opt/hbase-2.5.6"
export HBASE_HOME="${HBASE_HOME:-${HBASE_HOME_DIR}}"
export HBASE_DATA_DIR="/hbase"

# Logging configuration
export MODULE="${MODULE:-hmaster}"

# ENV Path
export HBASE_CONF_DIR="${HBASE_DATA_DIR}/conf"
export HBASE_LOG_DIR="${HBASE_DATA_DIR}/logs"
export HBASE_MASTER_DIR="${HBASE_CONF_DIR}/backup-masters"
export HBASE_REGION_SERVERS_DIR="${HBASE_CONF_DIR}/regionservers"
export PATH=$PATH:$HBASE_HOME/bin

# Hadoop ENV
export HADOOP_DATA_DIR="/hadoop"
export HADOOP_HOME_DIR="/opt/hadoop-3.3.4"
export HADOOP_HOME="${HADOOP_HOME:-${HADOOP_HOME_DIR}}"
export HADOOP_CONF_DIR="${HADOOP_DATA_DIR}/conf"

# System users (when running with a privileged user)
export HBASE_DAEMON_USER="hadoop"
export HBASE_DAEMON_GROUP="hadoop"

#
export DEBUG_MODEL="${DEBUG_MODEL:-true}"
export HBASE_MANAGES_ZK=false
#export HBASE_PID_DIR="${HBASE_DATA_DIR}/pids"

# ENV
#export HEADLESS_SERVICE_NAME=$(printf "%s-%s-%s.%s.svc.%s" $KB_CLUSTER_NAME $KB_COMP_NAME headless $KB_NAMESPACE $CLUSTER_DOMAIN)