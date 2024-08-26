FROM docker.io/dtweave/minideb:bookworm

LABEL org.opencontainers.image.base.name="docker.io/bitnami/minideb:bookworm" \
      org.opencontainers.image.licenses="Apache-2.0" \
      org.opencontainers.image.ref.name="debian-12-r3" \
      org.opencontainers.image.title="minideb-java8" \
      org.opencontainers.image.version="bookworm"

ARG TARGETARCH

ENV HOME="/" \
    OS_ARCH="${TARGETARCH:-amd64}" \
    OS_FLAVOUR="debian-12" \
    OS_NAME="linux" \
    JAVA_HOME="/opt/java" \
    PATH="/opt/java/bin:$PATH" \
    DOWNLOAD_URL="https://downloads.bitnami.com"

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN mkdir -p /tmp/dtweave/pkg/cache/ && cd /tmp/dtweave/pkg/cache/ && \
    COMPONENTS=( \
      "java-1.8.422-6-1-linux-${OS_ARCH}-debian-12" \
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

RUN apt-get update && apt-get upgrade -y && \
    apt-get clean && rm -rf /var/lib/apt/lists /var/cache/apt/archives

CMD tail -f /dev/null