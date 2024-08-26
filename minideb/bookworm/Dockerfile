FROM docker.io/bitnami/minideb:bookworm

LABEL org.opencontainers.image.base.name="docker.io/bitnami/minideb:bookworm" \
      org.opencontainers.image.licenses="Apache-2.0" \
      org.opencontainers.image.ref.name="debian-12-r3" \
      org.opencontainers.image.title="minideb" \
      org.opencontainers.image.version="bullseye"

ARG TARGETARCH

ENV HOME="/" \
    OS_ARCH="${TARGETARCH:-amd64}" \
    OS_FLAVOUR="debian-12" \
    OS_NAME="linux"

RUN install_packages apt-transport-https ca-certificates curl procps

COPY scripts /
COPY sources.list /etc/apt/

RUN apt-get update && apt-get upgrade -y && \
    apt-get clean && rm -rf /var/lib/apt/lists /var/cache/apt/archives && \
    ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo "Asia/Shanghai" >> /etc/timezone

CMD tail -f /dev/null