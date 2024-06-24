ARG EZA_REPOSITORY="https://github.com/eza-community/eza"
ARG EZA_VERSION="0.18.19"
ARG EZA_BRANCH="v0.18.19"
ARG EZA_COMMIT="7e21ed993c490f91bd4434bb4061ca007aedaf64"

FROM docker.io/rust:alpine as builder
COPY package-metadata.spec /build/

ARG EZA_REPOSITORY \
    EZA_VERSION \
    EZA_BRANCH \
    EZA_COMMIT

RUN apk update && apk add --no-cache \
    git \
    ca-certificates \
    build-base \
    musl-utils \
    musl-dev

RUN cargo install cargo-auditable

RUN git clone --branch "${EZA_BRANCH}" "${EZA_REPOSITORY}" /build/eza \
    && export ARCHITECTURE=$(arch) \
    && cd /build/eza \
    && git reset --hard "${EZA_COMMIT}" \
    && RUSTFLAGS='-C link-arg=-s -C link-arg=-specs=/build/package-metadata.spec' cargo auditable build --release --bins --target-dir /build/

FROM alpine:latest as config

RUN addgroup eza \
    && adduser -G eza -s /bin/sh -D eza

FROM scratch

ARG EZA_REPOSITORY \
    EZA_VERSION \
    EZA_BRANCH \
    EZA_COMMIT

ENV EZA_REPOSITORY="${EZA_REPOSITORY}" \
    EZA_VERSION="${EZA_VERSION}" \
    EZA_BRANCH="${EZA_BRANCH}" \
    EZA_COMMIT="${EZA_COMMIT}" \
    TERM="xterm-256color"

COPY --from=config /etc/passwd /etc/passwd
COPY --from=builder /build/release/eza /usr/local/bin/eza

USER eza

ENTRYPOINT ["/usr/local/bin/eza"]
CMD ["--help"]

LABEL org.opencontainers.image.title="eza" \
    org.opencontainers.image.description="eza in a container" \
    org.opencontainers.image.revision="${EZA_COMMIT}" \
    org.opencontainers.image.version="${EZA_VERSION}"

