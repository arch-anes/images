FROM dev-container

ARG KUBECTL_VERSION=1.35

RUN curl -fsSL https://pkgs.k8s.io/core:/stable:/v$KUBECTL_VERSION/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg && \
    echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v$KUBECTL_VERSION/deb/ /" | sudo tee /etc/apt/sources.list.d/kubernetes.list

RUN curl -fsSL https://packages.buildkite.com/helm-linux/helm-debian/gpgkey | sudo gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/helm.gpg] https://packages.buildkite.com/helm-linux/helm-debian/any/ any main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list

RUN sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc && sudo chmod a+r /etc/apt/keyrings/docker.asc && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list

RUN sudo apt-get update && sudo apt-get install -y kubectl helm docker-ce-cli \
    && sudo rm -rf /var/lib/apt/lists/*

RUN brew install yamlfmt

ARG HELMFMT_VERSION=0.5.0
RUN curl -L https://github.com/digitalstudium/helmfmt/releases/download/v${HELMFMT_VERSION}/helmfmt_Linux_x86_64.tar.gz | sudo tar -xzf - -C /usr/local/bin/ helmfmt
