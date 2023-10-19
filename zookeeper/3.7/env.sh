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

#export DW_ROOT_DIR="/opt/dtweave"
#export ZOO_VOLUME_DIR="/dtweave/zookeeper"

# Logging configuration
export MODULE="${MODULE:-zookeeper}"

# Paths
export ZOO_BASE_DIR="/opt/zookeeper"
export ZOO_DATA_DIR="/zookeeper/data"
export ZOO_DATA_LOG_DIR="/zookeeper/log"
export ZOO_CONF_DIR="${ZOO_BASE_DIR}/conf"
export ZOO_CONF_FILE="${ZOO_CONF_DIR}/zoo.cfg"
export ZOO_LOG_DIR="${ZOO_BASE_DIR}/logs"
export ZOO_LOG_FILE="${ZOO_LOG_DIR}/zookeeper.out"
export ZOO_BIN_DIR="${ZOO_BASE_DIR}/bin"
export ZOO_DATA_ID_DIR="${ZOO_DATA_DIR}/myid"
export ZOO_SERVERS_DIR="${ZOO_CONF_DIR}/zoo.cfg.dynamic"

# System users (when running with a privileged user)
export ZOO_DAEMON_USER="zookeeper"
export ZOO_DAEMON_GROUP="zookeeper"

# K8S param
export K8S_REPLICAS="${K8S_REPLICAS:-0}"
export CLUSTER_DOMAIN="${CLUSTER_DOMAIN:-cluster.local}"

# ZooKeeper cluster configuration
export CLI_PORT_NUMBER="${CLI_PORT_NUMBER:-2181}"
export FOLLOWER_PORT="${FOLLOWER_PORT:-2888}"
export ELECTION_PORT="${ELECTION_PORT:-3888}"
export ZOO_SERVER_ID="${ZOO_SERVER_ID:-1}"

# ZooKeeper settings
export ZOO_TICK_TIME="${ZOO_TICK_TIME:-2000}"
export ZOO_INIT_LIMIT="${ZOO_INIT_LIMIT:-10}"
export ZOO_SYNC_LIMIT="${ZOO_SYNC_LIMIT:-5}"
export ZOO_LOG_LEVEL="${ZOO_LOG_LEVEL:-INFO}"

# Java settings
export JVMFLAGS="${JVMFLAGS:-}"
export ZOO_HEAP_SIZE="${ZOO_HEAP_SIZE:-1024}"

#
export ZOO_ENABLE_PROMETHEUS_METRICS="${ZOO_ENABLE_PROMETHEUS_METRICS:-no}"