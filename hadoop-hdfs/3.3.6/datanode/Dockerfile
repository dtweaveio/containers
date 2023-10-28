FROM docker.io/dtweave/hadoop-hdfs:v3.3.6

ARG TARGETARCH

LABEL org.opencontainers.image.base.name="docker.io/dtweave/hadoop-hdfs:v3.3.6" \
      org.opencontainers.image.licenses="Apache-2.0" \
      org.opencontainers.image.ref.name="3.3.6-debian-11" \
      org.opencontainers.image.title="datanode" \
      org.opencontainers.image.version="3.3.6"

ENV HOME="/" \
    OS_ARCH="${TARGETARCH:-amd64}" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

COPY *.sh /opt/scripts/hdfs/3.3.6/datanode/

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apt-get autoremove --purge -y curl && \
    apt-get update && apt-get upgrade -y && \
    apt-get clean && rm -rf /var/lib/apt/lists /var/cache/apt/archives

RUN /opt/scripts/hdfs/3.3.6/datanode/setup.sh

ENV APP_VERSION="3.3.6" \
    APP_NAME="datanode"

EXPOSE 50010 50020 50075 50475 9866 9864 9867

#USER 1000
ENTRYPOINT [ "/opt/scripts/hdfs/3.3.6/datanode/entrypoint.sh" ]
CMD [ "/opt/scripts/hdfs/3.3.6/datanode/run.sh" ]