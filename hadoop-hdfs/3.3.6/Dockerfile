FROM docker.io/dtweave/minideb-java8:bullseye

ARG TARGETARCH

LABEL org.opencontainers.image.base.name="docker.io/dtweave/minideb:bullseye" \
      org.opencontainers.image.licenses="Apache-2.0" \
      org.opencontainers.image.ref.name="3.3.6-debian-11-r119" \
      org.opencontainers.image.title="hadoop-hdfs" \
      org.opencontainers.image.version="3.3.6"

ENV HOME="/" \
    OS_ARCH="${TARGETARCH:-amd64}" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

COPY hadoop-3.3.6 /opt/hadoop-3.3.6

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apt-get update && apt-get upgrade -y && \
    apt-get clean && rm -rf /var/lib/apt/lists /var/cache/apt/archives

ENV APP_VERSION="3.3.6" \
    APP_NAME="hadoop-hdfs"

CMD tail -f /dev/null