FROM dev-container

COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /usr/bin/

ARG NODE_MAJOR=24
RUN curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | \
        sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg && \
    echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_${NODE_MAJOR}.x nodistro main" | \
        sudo tee /etc/apt/sources.list.d/nodesource.list > /dev/null 

RUN sudo apt-get update && \
    sudo apt-get install -y podman nodejs python3-pip python3-venv ripgrep fd-find fzf git-lfs && \
    sudo ln -sf /usr/bin/fdfind /usr/bin/fd && \
    sudo rm -rf /var/lib/apt/lists/*

ARG VERSION

RUN curl -fsSL "https://github.com/anomalyco/opencode/releases/download/v${VERSION}/opencode-linux-x64.tar.gz" | sudo tar -xzf - -C /usr/local/bin/ opencode

RUN brew install jadx ghidra gh

ENV GHIDRA_INSTALL_DIR /home/linuxbrew/.linuxbrew/opt/ghidra/libexec/

ENTRYPOINT ["/usr/local/bin/opencode"]
