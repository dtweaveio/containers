FROM docker.io/dtweave/minideb-java8:bookworm

ARG TARGETARCH

LABEL org.opencontainers.image.base.name="docker.io/dtweave/minideb:bookworm" \
      org.opencontainers.image.licenses="Apache-2.0" \
      org.opencontainers.image.ref.name="3.3.4-debian-12-r3" \
      org.opencontainers.image.title="hadoop-hdfs" \
      org.opencontainers.image.version="3.3.4"

ENV HOME="/" \
    OS_ARCH="${TARGETARCH:-amd64}" \
    OS_FLAVOUR="debian-12" \
    OS_NAME="linux"

COPY hadoop-3.3.4 /opt/software/hadoop-3.3.4
COPY *.sh /opt/scripts/hdfs/3.3.4/

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apt-get update && apt-get upgrade -y && \
    apt-get clean && rm -rf /var/lib/apt/lists /var/cache/apt/archives

RUN /opt/scripts/hdfs/3.3.4/setup.sh

ENV APP_VERSION="3.3.4" \
    APP_NAME="hadoop-common"

CMD tail -f /dev/null