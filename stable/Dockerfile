ARG SOURCE
ARG REVISION
ARG CREATED
ARG VERSION
ARG GIT_REF="${VERSION}"

FROM westonsteimel/rust-static-builder:stable as builder

ARG GIT_REF

RUN git clone --depth 1 --branch "${GIT_REF}" https://github.com/ogham/exa /build/exa \
    && cd /build/exa \
    && NOCOMPRESS=1 /home/builder/build.sh

FROM alpine:latest as config

RUN addgroup exa \
    && adduser -G exa -s /bin/sh -D exa

FROM scratch

ARG VERSION
ARG SOURCE
ARG REVISION
ARG CREATED

COPY --from=config /etc/passwd /etc/passwd
COPY --from=builder /build/exa/target/x86_64-unknown-linux-musl/release/exa /usr/local/bin/exa

USER exa

ENV TERM xterm-256color

ENTRYPOINT ["/usr/local/bin/exa"]
CMD ["--help"]

LABEL org.opencontainers.image.title="exa" \
    org.opencontainers.image.description="exa in Docker" \
    org.opencontainers.image.source="${SOURCE}" \
    org.opencontainers.image.revision="${REVISION}" \
    org.opencontainers.image.created="${CREATED}" \
    org.opencontainers.image.version="${VERSION}"
