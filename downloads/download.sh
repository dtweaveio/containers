#!/bin/bash

export DOWNLOAD_URL=https://downloads.bitnami.com
export OS_ARCH=amd64

mkdir -p /tmp/dtweave/pkg/cache/ && cd /tmp/dtweave/pkg/cache/ && \
    COMPONENTS=( \
      "yq-4.32.2-0-linux-${OS_ARCH}-debian-11" \
      "gosu-1.16.0-3-linux-${OS_ARCH}-debian-11" \
      "java-1.8.362-4-linux-${OS_ARCH}-debian-11" \
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