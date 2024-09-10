FROM docker.io/dtweave/minideb-java8:bookworm

ARG TARGETARCH

LABEL org.opencontainers.image.base.name="docker.io/dtweave/hive-metastore:v3.1.3" \
      org.opencontainers.image.licenses="Apache-2.0" \
      org.opencontainers.image.ref.name="3.1.3-debian-12" \
      org.opencontainers.image.title="hive-metastore" \
      org.opencontainers.image.version="3.1.3"

ENV HOME="/" \
    OS_ARCH="${TARGETARCH:-amd64}" \
    OS_FLAVOUR="debian-12" \
    OS_NAME="linux"

COPY hive-3.1.3 /opt/hive-3.1.3
COPY *.sh /opt/scripts/hive/3.1.3/metastore/

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apt-get autoremove --purge -y curl && \
    apt-get update && apt-get upgrade -y && \
    apt-get clean && rm -rf /var/lib/apt/lists /var/cache/apt/archives

RUN /opt/scripts/hive/3.1.3/metastore/setup.sh

ENV APP_VERSION="3.1.3" \
    APP_NAME="hive-metastore" \
    HIVE_HOME="/opt/hive-3.1.3" \
    HADOOP_HOME="/opt/hadoop-3.3.4" \
    PATH=$PATH:$HIVE_HOME/bin \
    PATH=$PATH:$HIVE_HOME/sbin

EXPOSE 9083

ENTRYPOINT [ "/opt/scripts/hive/3.1.3/metastore/entrypoint.sh" ]
CMD [ "/opt/scripts/hive/3.1.3/metastore/run.sh" ]