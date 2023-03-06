ARG VERSION="master"
ARG REVISION="c697d066702ab81ce0684fedb4c638e0fc0473e8"

FROM docker.io/rust:alpine as builder

ARG VERSION
ARG REVISION

RUN apk update && apk add --no-cache \
    git \
    ca-certificates \
    build-base \
    musl-utils \
    musl-dev

RUN git clone --branch "${VERSION}" https://github.com/ogham/exa /build/exa \
    && cd /build/exa \
    && git reset --hard "${REVISION}" \
    && RUSTFLAGS='-C link-arg=-s' cargo build --release --bins --target-dir /build

FROM alpine:latest as config

RUN addgroup exa \
    && adduser -G exa -s /bin/sh -D exa

FROM scratch

ARG VERSION
ARG REVISION
ENV EXA_VERSION="${VERSION}" \
    EXA_REVISION="${REVISION}" \
    TERM="xterm-256color"

COPY --from=config /etc/passwd /etc/passwd
COPY --from=builder /build/release/exa /usr/local/bin/exa

USER exa

ENTRYPOINT ["/usr/local/bin/exa"]
CMD ["--help"]

LABEL org.opencontainers.image.title="exa" \
    org.opencontainers.image.description="exa in Docker" \
    org.opencontainers.image.revision="${REVISION}" \
    org.opencontainers.image.version="${VERSION}"

