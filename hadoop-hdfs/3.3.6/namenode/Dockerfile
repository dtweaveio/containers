FROM docker.io/dtweave/hadoop-common:v3.3.4

ARG TARGETARCH

LABEL org.opencontainers.image.base.name="docker.io/dtweave/hadoop-hdfs:v3.3.6" \
      org.opencontainers.image.licenses="Apache-2.0" \
      org.opencontainers.image.ref.name="3.3.6-debian-11" \
      org.opencontainers.image.title="namenode" \
      org.opencontainers.image.version="3.3.6"

ENV HOME="/" \
    OS_ARCH="${TARGETARCH:-amd64}" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

COPY *.sh /opt/scripts/hdfs/3.3.6/namenode/

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apt-get autoremove --purge -y curl ca-certificates && \
    apt-get update && apt-get upgrade -y && \
    apt-get clean && rm -rf /var/lib/apt/lists /var/cache/apt/archives

RUN /opt/scripts/hdfs/3.3.6/namenode/setup.sh

ENV APP_VERSION="3.3.6" \
    APP_NAME="namenode"

EXPOSE 8020 9870 9820

ENTRYPOINT [ "/opt/scripts/hdfs/3.3.6/namenode/entrypoint.sh" ]
CMD [ "/opt/scripts/hdfs/3.3.6/namenode/run.sh" ]