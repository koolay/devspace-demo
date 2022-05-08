ARG GO_VERSION=1.18.1

FROM golang:${GO_VERSION}-buster as builder

ENV TZ "Asia/Shanghai"

ARG GOPROXY="https://goproxy.cn,direct"

RUN set -ex; \
  apt-get update; \
  apt-get install -y --no-install-recommends \
  dirmngr ca-certificates locales \
  ; \
  rm -rf /var/lib/apt/lists/*; \
  echo "LC_ALL=en_US.UTF-8" >> /etc/environmenta ;\
  echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen; \
  echo "LANG=en_US.UTF-8" > /etc/locale.conf; \
  locale-gen en_US.UTF-8

RUN go install github.com/go-delve/delve/cmd/dlv@latest && \
  go install github.com/makiuchi-d/arelo@latest 

WORKDIR /app
