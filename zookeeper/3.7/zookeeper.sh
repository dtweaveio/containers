#!/bin/bash
#
# Bitnami ZooKeeper library

# shellcheck disable=SC1091

# Load Generic Libraries
. /opt/scripts/libs/libfs.sh
. /opt/scripts/libs/libfile.sh
. /opt/scripts/libs/liblog.sh
. /opt/scripts/libs/libos.sh
. /opt/scripts/libs/libvalidations.sh
. /opt/scripts/libs/libservice.sh
. /opt/scripts/zookeeper/3.7/env.sh

########################
# Ensure ZooKeeper is initialized
# Globals:
#   ZOO_*
# Arguments:
#   None
# Returns:
#   None
#########################
zookeeper_initialize() {
    info "Initializing ZooKeeper..."

    if [[ ! -f "$ZOO_CONF_FILE" ]]; then
        info "No injected configuration file found, creating default config files..."
        zookeeper_generate_conf
        zookeeper_configure_heap_size "$ZOO_HEAP_SIZE"

        if is_boolean_yes "$ZOO_ENABLE_PROMETHEUS_METRICS"; then
            zookeeper_enable_prometheus_metrics "$ZOO_CONF_FILE"
        fi
        zookeeper_export_jvmflags "-Dzookeeper.electionPortBindRetry=0"
    else
        info "User injected custom configuration detected!"
    fi

    if [[ $K8S_REPLICAS -gt 0 && $STANDALONE_ENABLE == false ]]; then
      init_zookeeper_server_id
      zookeeper_generate_servers
    fi

    if is_dir_empty "$ZOO_DATA_DIR"; then
        info "Deploying ZooKeeper from scratch..."
        echo "$ZOO_SERVER_ID" >"${ZOO_DATA_DIR}/myid"
    else
        info "Deploying ZooKeeper with persisted data..."
    fi
}

########################
# Ensure ZooKeeper data id is initialized
# check ZOO_SERVER_ID in persistent volume via myid
# if not present, set based on POD hostname,hostname like：web-0、web-1、web-2
#########################
init_zookeeper_server_id() {
    info "Init ZooKeeper server id..."
    if [[ -f "${ZOO_DATA_ID_DIR}" ]]; then
        export ZOO_SERVER_ID=$(cat "${ZOO_DATA_ID_DIR}")
    else
        if [[ $HOSTNAME =~ (.*)-([0-9]+)$ ]]; then
            export ZOO_SERVER_ID=${BASH_REMATCH[2]}
        else
            echo "Failed to get index from hostname $HOSTNAME"
            export ZOO_SERVER_ID=0
        fi
    fi
}

########################
# Ensure ZooKeeper cluster servers like this:
#  server.1=hadoop102:2888:3888;2181
#  server.2=hadoop103:2888:3888;2181
#  server.3=hadoop104:2888:3888;2181
#
#  for k8s:
#  server.1=zk-0.zk-svc.default.svc.cluster.local:2888:3888;2181
#  server.2=zk-1.zk-svc.default.svc.cluster.local:2888:3888;2181
#  server.3=zk-2.zk-svc.default.svc.cluster.local:2888:3888;2181
# check ZOO_SERVER_ID in persistent volume via myid
# if not present, set based on POD hostname,hostname like：web-0、web-1、web-2
#########################
zookeeper_generate_servers(){
    info "Generate ZooKeeper servers..."
    local replicas=${K8S_REPLICAS}
    if [[ $HOSTNAME =~ (.*)-([0-9]+)$ ]]; then
      export ZOO_SERVER_NAME=${BASH_REMATCH[1]}
    fi
    touch ${ZOO_SERVERS_DIR}

    # Add zookeeper servers to configuration
    if [[ $replicas -gt 0 ]]; then
      for ((i = 0; i < $replicas; i++)); do
        #local endpoints=$(printf "%s-%d.%s.%s.svc.%s:%d:%d;%d" $ZOO_SERVER_NAME ${i} $SERVICE_NAME $KUBERNETES_NAMESPACE $CLUSTER_DOMAIN $FOLLOWER_PORT $ELECTION_PORT $ZOO_PORT_NUMBER)
        local FQDN=$(echo "${KB_POD_FQDN}" | sed "s/[0-9]/$i/")
        local endpoints=$(printf "%s.%s:%d:%d;%d" $FQDN $CLUSTER_DOMAIN $FOLLOWER_PORT $ELECTION_PORT $CLI_PORT_NUMBER)
        info "Adding server: ${i}"
        zookeeper_conf_set "$ZOO_SERVERS_DIR" "server.${i}" "${endpoints}"
      done
    else
      info "No additional servers were specified. ZooKeeper will run in standalone mode..."
    fi
}

########################
# Generate the configuration files for ZooKeeper
# Globals:
#   ZOO_*
# Arguments:
#   None
# Returns:
#   None
#########################
zookeeper_generate_conf() {
    info "Generate ZooKeeper Conf..."

    cp "${ZOO_CONF_DIR}/zoo_sample.cfg" "$ZOO_CONF_FILE"
    echo >>"$ZOO_CONF_FILE"

    zookeeper_conf_set "$ZOO_CONF_FILE" tickTime "$ZOO_TICK_TIME"
    zookeeper_conf_set "$ZOO_CONF_FILE" initLimit "$ZOO_INIT_LIMIT"
    zookeeper_conf_set "$ZOO_CONF_FILE" syncLimit "$ZOO_SYNC_LIMIT"
    zookeeper_conf_set "$ZOO_CONF_FILE" dataDir "$ZOO_DATA_DIR"
    zookeeper_conf_set "$ZOO_CONF_FILE" dataLogDir "$ZOO_DATA_LOG_DIR"
    zookeeper_conf_set "$ZOO_CONF_FILE" clientPort "$CLI_PORT_NUMBER"
    zookeeper_conf_set "$ZOO_CONF_FILE" standaloneEnabled "$STANDALONE_ENABLE"
    zookeeper_conf_set "$ZOO_CONF_FILE" reconfigEnabled "$RE_CONFIG_ENABLE"
    zookeeper_conf_set "$ZOO_CONF_FILE" 4lw.commands.whitelist "$ZOO_4LW_COMMANDS_WHITELIST"
#    zookeeper_conf_set "$ZOO_CONF_FILE" dynamicConfigFile "${ZOO_SERVERS_DIR}"

#    zookeeper_conf_set "$ZOO_CONF_FILE" admin.enableServer "${ENABLE_SERVER}"
#    zookeeper_conf_set "$ZOO_CONF_FILE" admin.serverAddress "${SERVER_ADDRESS}"
#    zookeeper_conf_set "$ZOO_CONF_FILE" admin.serverPort "${SERVER_PORT}"

    # Set log level
    if [ -f "${ZOO_CONF_DIR}/logback.xml" ]; then
      # Zookeeper 3.8+
      xmlstarlet edit -L -u "/configuration/property[@name='zookeeper.console.threshold']/@value" -v "$ZOO_LOG_LEVEL" "${ZOO_CONF_DIR}/logback.xml"
    else
      zookeeper_conf_set "${ZOO_CONF_DIR}/log4j.properties" zookeeper.console.threshold "$ZOO_LOG_LEVEL"
    fi
    # Admin web server https://zookeeper.apache.org/doc/r3.5.7/zookeeperAdmin.html#sc_adminserver
    #zookeeper_conf_set "$ZOO_CONF_FILE" admin.serverPort "$ZOO_ADMIN_SERVER_PORT_NUMBER"
    #zookeeper_conf_set "$ZOO_CONF_FILE" admin.enableServer "$(is_boolean_yes "$ZOO_ENABLE_ADMIN_SERVER" && echo "true" || echo "false")"
}

########################
# Set a configuration setting value into a configuration file
# Globals:
#   None
# Arguments:
#   $1 - filename
#   $2 - key
#   $3 - value
# Returns:
#   None
#########################
zookeeper_conf_set() {
    local -r filename="${1:?filename is required}"
    local -r key="${2:?key is required}"
    local -r value="${3:?value is required}"

    if grep -q -E "^\s*#*\s*${key}=" "$filename"; then
        replace_in_file "$filename" "^\s*#*\s*${key}=.*" "${key}=${value}"
    else
        echo "${key}=${value}" >>"$filename"
    fi
}

########################
# Configure heap size
# Globals:
#   JVMFLAGS
# Arguments:
#   $1 - heap_size
# Returns:
#   None
#########################
zookeeper_configure_heap_size() {
    local -r heap_size="${1:?heap_size is required}"

    if [[ "$JVMFLAGS" =~ -Xm[xs].*-Xm[xs] ]]; then
        debug "Using specified values (JVMFLAGS=${JVMFLAGS})"
    else
        debug "Setting '-Xmx${heap_size}m -Xms${heap_size}m' heap options..."
        zookeeper_export_jvmflags "-Xmx${heap_size}m -Xms${heap_size}m"
    fi
}

########################
# Export JVMFLAGS
# Globals:
#   JVMFLAGS
# Arguments:
#   $1 - value
# Returns:
#   None
#########################
zookeeper_export_jvmflags() {
    local -r value="${1:?value is required}"

    export JVMFLAGS="${JVMFLAGS} ${value}"
    echo "export JVMFLAGS=\"${JVMFLAGS}\"" >"${ZOO_CONF_DIR}/java.env"
}

########################
# Enable Prometheus metrics for ZooKeeper
# Globals:
#   ZOO_PROMETHEUS_METRICS_PORT_NUMBER
# Arguments:
#   $1 - filename
# Returns:
#   None
#########################
zookeeper_enable_prometheus_metrics() {
    local -r filename="${1:?filename is required}"

    info "Enabling Prometheus metrics..."
    zookeeper_conf_set "$filename" metricsProvider.className org.apache.zookeeper.metrics.prometheus.PrometheusMetricsProvider
    zookeeper_conf_set "$filename" metricsProvider.httpPort "$ZOO_PROMETHEUS_METRICS_PORT_NUMBER"
    zookeeper_conf_set "$filename" metricsProvider.exportJvmInfo true
}