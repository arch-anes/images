FROM docker.io/debian:trixie-slim

RUN apt-get update && apt-get install -y curl ca-certificates xz-utils wget && rm -rf /var/lib/apt/lists/*

RUN groupadd -g 568 apps && \
    useradd -m -u 568 -g 568 -s /bin/bash apps; \
    mkdir -p /home/apps; \
    chown -R apps:apps /home/apps

USER 568

RUN curl -LsSf https://github.com/stalwartlabs/cli/releases/latest/download/stalwart-cli-installer.sh | sh

ENV PATH=/home/apps/.cargo/bin:$PATH

ENTRYPOINT ["/home/apps/.cargo/bin/stalwart-cli"]
