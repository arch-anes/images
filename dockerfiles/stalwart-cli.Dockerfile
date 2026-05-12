FROM docker.io/debian:trixie-slim

RUN apt-get update && apt-get install -y curl ca-certificates xz-utils wget && rm -rf /var/lib/apt/lists/*

RUN curl -LsSf https://github.com/stalwartlabs/cli/releases/latest/download/stalwart-cli-installer.sh | sh

ENV PATH=/root/.cargo/bin:$PATH

ENTRYPOINT ["stalwart-cli"]
