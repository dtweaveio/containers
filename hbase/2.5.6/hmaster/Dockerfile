FROM docker.io/dtweave/hadoop-common:v3.3.4

ARG TARGETARCH

LABEL org.opencontainers.image.base.name="docker.io/dtweave/hadoop-common:v3.3.4" \
      org.opencontainers.image.licenses="Apache-2.0" \
      org.opencontainers.image.ref.name="2.5.6-debian-11" \
      org.opencontainers.image.title="hmaster" \
      org.opencontainers.image.version="2.5.6"

ENV HOME="/" \
    OS_ARCH="${TARGETARCH:-amd64}" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

COPY *.sh /opt/scripts/hbase/2.5.6/hmaster/
COPY hbase-2.5.6 /opt/hbase-2.5.6

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apt-get autoremove --purge -y curl ca-certificates && \
    apt-get update && apt-get upgrade -y && \
    apt-get clean && rm -rf /var/lib/apt/lists /var/cache/apt/archives

RUN /opt/scripts/hbase/2.5.6/hmaster/setup.sh

ENV APP_VERSION="2.5.6" \
    APP_NAME="hmaster"

EXPOSE 16000 16010 16020 16030

CMD ["tail", "-f", "/dev/null"]

ENTRYPOINT [ "/opt/scripts/hbase/2.5.6/hmaster/entrypoint.sh" ]
CMD [ "/opt/scripts/hbase/2.5.6/hmaster/run.sh" ]