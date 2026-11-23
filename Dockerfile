# Multi-stage build: official xray image has no shell, so copy the binary into Alpine.
# NOTE: in ghcr.io/xtls/xray-core the binary lives at /usr/local/bin/xray (entrypoint),
# NOT /usr/bin/xray — using the wrong path fails the build with "/usr/bin/xray: not found".
FROM ghcr.io/xtls/xray-core:latest AS xray

FROM alpine:latest
RUN apk add --no-cache ca-certificates
COPY --from=xray /usr/local/bin/xray /usr/local/bin/xray
COPY config.json /etc/xray/config.json
EXPOSE 3000
CMD ["/usr/local/bin/xray", "run", "-c", "/etc/xray/config.json"]
