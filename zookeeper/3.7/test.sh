#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

export REPLICAS=3
export HOSTNAME="zk-0"
export SERVICE_NAME=zk-svc
export KUBERNETES_NAMESPACE=default
export CLUSTER_DOMAIN=cluster.local
export ZOO_PORT_NUMBER=2181
export FOLLOWER_PORT=2888
export ELECTION_PORT=3888
export APP_NAME=zookeeper

. /opt/scripts/zookeeper/3.7/zookeeper-env.sh
. /opt/scripts/zookeeper/3.7/libzookeeper.sh
. /opt/scripts/zookeeper/3.7/entrypoint.sh