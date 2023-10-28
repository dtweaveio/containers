#!/bin/bash
# Load logging library
# shellcheck disable=SC1090,SC1091
export APP_NAME=journalnode
export JAVA_HOME="/opt/dtweave/java"

. /opt/dtweave/scripts/hdfs/3.3.5/journalnode/env.sh
env
. /opt/dtweave/scripts/hdfs/3.3.5/journalnode/entrypoint.sh
. /opt/dtweave/scripts/hdfs/3.3.5/journalnode/setup.sh
. /opt/dtweave/scripts/hdfs/3.3.5/journalnode/run.sh