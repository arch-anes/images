FROM mcr.microsoft.com/vscode/devcontainers/base:ubuntu-24.04

ARG KUBECTL_VERSION=1.30

RUN curl -fsSL https://pkgs.k8s.io/core:/stable:/v$KUBECTL_VERSION/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg && \
    echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v$KUBECTL_VERSION/deb/ /" | sudo tee /etc/apt/sources.list.d/kubernetes.list

RUN curl -fsSL https://baltocdn.com/helm/signing.asc | sudo gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list

RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list

RUN sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc && sudo chmod a+r /etc/apt/keyrings/docker.asc && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list

RUN apt-get update && apt-get install -y apt-transport-https pipx gettext-base kubectl helm vagrant docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Workaround for https://github.com/pypa/pipx/issues/754#issuecomment-951162846
# Fixed in pipx 1.5.0 but not yet available in apt which has pipx 1.4.3
RUN PIPX_HOME=/opt/pipx PIPX_BIN_DIR=/usr/local/bin pipx install --include-deps ansible && \
    PIPX_HOME=/opt/pipx PIPX_BIN_DIR=/usr/local/bin pipx inject  --include-deps ansible jmespath boto3 ansible-lint molecule molecule-plugins[docker]

RUN usermod -aG docker vscode
