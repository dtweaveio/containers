FROM docker.io/dtweave/hadoop-common:v3.3.4

ARG TARGETARCH

LABEL org.opencontainers.image.base.name="docker.io/dtweave/hadoop-hdfs:v3.3.4" \
      org.opencontainers.image.licenses="Apache-2.0" \
      org.opencontainers.image.ref.name="3.3.4-debian-11" \
      org.opencontainers.image.title="journalnode" \
      org.opencontainers.image.version="3.3.4"

ENV HOME="/" \
    OS_ARCH="${TARGETARCH:-amd64}" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

COPY *.sh /opt/scripts/hdfs/3.3.4/journalnode/

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apt-get autoremove --purge -y curl && \
    apt-get update && apt-get upgrade -y && \
    apt-get clean && rm -rf /var/lib/apt/lists /var/cache/apt/archives

RUN /opt/scripts/hdfs/3.3.4/journalnode/setup.sh

ENV APP_VERSION="3.3.4" \
    APP_NAME="journalnode"

EXPOSE 8485 8480

ENTRYPOINT [ "/opt/scripts/hdfs/3.3.4/journalnode/entrypoint.sh" ]
CMD [ "/opt/scripts/hdfs/3.3.4/journalnode/run.sh" ]