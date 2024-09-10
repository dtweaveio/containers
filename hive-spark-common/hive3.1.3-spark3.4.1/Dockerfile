FROM docker.io/dtweave/minideb-java8:bookworm

ARG TARGETARCH

LABEL org.opencontainers.image.base.name="docker.io/dtweave/minideb:bookworm" \
      org.opencontainers.image.licenses="Apache-2.0" \
      org.opencontainers.image.ref.name="hive3.1.3-spark3.4.1-debian-12-r3" \
      org.opencontainers.image.title="hive-spark-common" \
      org.opencontainers.image.version="hive3.1.3-spark3.4.1-1.0.0"

ENV HOME="/" \
    OS_ARCH="${TARGETARCH:-amd64}" \
    OS_FLAVOUR="debian-12" \
    OS_NAME="linux"

COPY apache-hive-3.1.3 /opt/software/apache-hive-3.1.3

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apt-get update && apt-get upgrade -y && \
    apt-get clean && rm -rf /var/lib/apt/lists /var/cache/apt/archives

ENV APP_VERSION="hive3.1.3-spark3.4.1-1.0.0" \
    APP_NAME="hive-spark-common"

CMD tail -f /dev/null