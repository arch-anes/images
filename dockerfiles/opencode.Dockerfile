FROM dev-container

COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /usr/bin/

RUN sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc && sudo chmod a+r /etc/apt/keyrings/docker.asc && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list

RUN sudo apt-get update && \
    sudo apt-get install -y docker-ce-cli nodejs npm python3-pip python3-venv ripgrep fd-find fzf git-lfs && \
    sudo ln -sf /usr/bin/fdfind /usr/bin/fd && \
    sudo rm -rf /var/lib/apt/lists/*

ARG VERSION

RUN curl -fsSL "https://github.com/anomalyco/opencode/releases/download/v${VERSION}/opencode-linux-x64.tar.gz" | sudo tar -xzf - -C /usr/local/bin/ opencode

ENTRYPOINT ["/usr/bin/opencode"]
