ARG VERSION="master"
ARG REVISION="69d5e1fc112788e2685338789b314fc71d248c7d"

FROM westonsteimel/rust-static-builder:stable as builder

ARG VERSION
ARG REVISION

RUN git clone --branch "${VERSION}" https://github.com/ogham/exa /build/exa \
    && cd /build/exa \
    && git reset --hard "${REVISION}" \
    && mkdir /build/output \
    && NOCOMPRESS=1 /home/builder/build.sh \
    && cp /build/exa/target/${TARGET}/release/exa /build/output/

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
COPY --from=builder /build/output/exa /usr/local/bin/exa

USER exa

ENTRYPOINT ["/usr/local/bin/exa"]
CMD ["--help"]

LABEL org.opencontainers.image.title="exa" \
    org.opencontainers.image.description="exa in Docker" \
    org.opencontainers.image.revision="${REVISION}" \
    org.opencontainers.image.version="${VERSION}"

