ARG EXA_REPOSITORY="https://github.com/ogham/exa"
ARG EXA_VERSION="master"
ARG EXA_BRANCH="master"
ARG EXA_COMMIT="c697d066702ab81ce0684fedb4c638e0fc0473e8"

FROM docker.io/rust:alpine as builder
COPY package-metadata.spec /build/

ARG EXA_REPOSITORY \
    EXA_BRANCH \
    EXA_COMMIT

RUN apk update && apk add --no-cache \
    git \
    ca-certificates \
    build-base \
    musl-utils \
    musl-dev

RUN cargo install cargo-auditable

RUN git clone --branch "${EXA_BRANCH}" "${EXA_REPOSITORY}" /build/exa \
    && export ARCHITECTURE=$(arch) \
    && export EXA_DEV_VERSION="dev" \
    && cd /build/exa \
    && git reset --hard "${EXA_COMMIT}" \
    && RUSTFLAGS='-C link-arg=-s -C link-arg=-specs=/build/package-metadata.spec' cargo auditable build --release --bins --target-dir /build/

FROM alpine:latest as config

RUN addgroup exa \
    && adduser -G exa -s /bin/sh -D exa

FROM scratch

ARG EXA_REPOSITORY \
    EXA_VERSION \
    EXA_BRANCH \
    EXA_COMMIT

ENV EXA_REPOSITORY="${EXA_REPOSITORY}" \
    EXA_VERSION="${EXA_VERSION}" \
    EXA_BRANCH="${EXA_BRANCH}" \
    EXA_COMMIT="${EXA_COMMIT}" \
    TERM="xterm-256color"

COPY --from=config /etc/passwd /etc/passwd
COPY --from=builder /build/release/exa /usr/local/bin/exa

USER exa

ENTRYPOINT ["/usr/local/bin/exa"]
CMD ["--help"]

LABEL org.opencontainers.image.title="exa" \
    org.opencontainers.image.description="exa in a container" \
    org.opencontainers.image.revision="${EXA_COMMIT}" \
    org.opencontainers.image.version="${EXA_VERSION}"

