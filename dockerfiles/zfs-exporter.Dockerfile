FROM alpine:3.23

ARG VERSION

RUN apk add --no-cache zfs curl tar && \
    curl -fsSL "https://github.com/pdf/zfs_exporter/releases/download/v${VERSION}/zfs_exporter-${VERSION}.linux-amd64.tar.gz" | \
    tar -xz -C /usr/local/bin --strip-components=1 "zfs_exporter-${VERSION}.linux-amd64/zfs_exporter" && \
    apk del curl tar

ENTRYPOINT ["/usr/local/bin/zfs_exporter"]
