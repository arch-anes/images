FROM dev-container

COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /usr/bin/

RUN sudo apt-get update && \
    sudo apt-get install -y podman nodejs npm python3-pip python3-venv ripgrep fd-find fzf git-lfs && \
    sudo ln -sf /usr/bin/fdfind /usr/bin/fd && \
    sudo rm -rf /var/lib/apt/lists/*

ARG VERSION

RUN curl -fsSL "https://github.com/anomalyco/opencode/releases/download/v${VERSION}/opencode-linux-x64.tar.gz" | sudo tar -xzf - -C /usr/local/bin/ opencode

ENTRYPOINT ["/usr/local/bin/opencode"]
