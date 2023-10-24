FROM docker.io/dtweave/minideb-java8:bullseye

ARG TARGETARCH

LABEL org.opencontainers.image.base.name="docker.io/dtweave/minideb:bullseye" \
      org.opencontainers.image.licenses="Apache-2.0" \
      org.opencontainers.image.ref.name="3.7.1-debian-11" \
      org.opencontainers.image.title="zookeeper" \
      org.opencontainers.image.version="3.7.1"

ENV HOME="/" \
    OS_ARCH="${TARGETARCH:-amd64}" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux" \
    PATH="/opt/common/bin:/opt/java/bin:/opt/zookeeper/bin:$PATH" \
    DOWNLOAD_URL="http://downloads.dtweave.com:9000"

COPY *.sh /opt/scripts/zookeeper/3.7/

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN install_packages netcat-openbsd

RUN mkdir -p /tmp/dtweave/pkg/cache/ && cd /tmp/dtweave/pkg/cache/ && \
    COMPONENTS=( \
      "zookeeper-3.7.1-164-linux-${OS_ARCH}-debian-11" \
    ) && \
    for COMPONENT in "${COMPONENTS[@]}"; do \
      if [ ! -f "${COMPONENT}.tar.gz" ]; then \
        curl -SsLf "${DOWNLOAD_URL}/files/stacksmith/${COMPONENT}.tar.gz" -O ; \
        curl -SsLf "${DOWNLOAD_URL}/files/stacksmith/${COMPONENT}.tar.gz.sha256" -O ; \
      fi && \
      sha256sum -c "${COMPONENT}.tar.gz.sha256" && \
      tar -zxf "${COMPONENT}.tar.gz" -C /opt --strip-components=2 --no-same-owner --wildcards '*/files' && \
      rm -rf "${COMPONENT}".tar.gz{,.sha256} ; \
    done

RUN apt-get autoremove --purge -y curl && \
    apt-get update && apt-get upgrade -y && \
    apt-get clean && rm -rf /var/lib/apt/lists /var/cache/apt/archives

RUN /opt/scripts/zookeeper/3.7/setup.sh
ENV APP_VERSION="3.7.1" \
    JAVA_HOME="/opt/java" \
    APP_NAME="zookeeper"

EXPOSE 2181 2888 3888 9876 7000

ENTRYPOINT [ "/opt/scripts/zookeeper/3.7/entrypoint.sh" ]
CMD [ "/opt/scripts/zookeeper/3.7/run.sh" ]