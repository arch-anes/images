ARG VERSION
FROM mcr.microsoft.com/devcontainers/base:${VERSION}

RUN apt-get update && apt-get install -y software-properties-common ca-certificates apt-transport-https gettext-base build-essential procps curl git fuse \
    && rm -rf /var/lib/apt/lists/*

USER vscode

WORKDIR /home/vscode

RUN NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" && \
    echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> $HOME/.profile

ENV PATH="/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:${PATH}"
