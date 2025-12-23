FROM mcr.microsoft.com/vscode/devcontainers/base:ubuntu-24.04

RUN apt-get update && apt-get install -y software-properties-common ca-certificates apt-transport-https

RUN sudo add-apt-repository ppa:longsleep/golang-backports

ARG KUBECTL_VERSION=1.34
ARG KUBEBUILDER_VERSION=4.5.0

RUN curl -fsSL https://pkgs.k8s.io/core:/stable:/v$KUBECTL_VERSION/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg && \
    echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v$KUBECTL_VERSION/deb/ /" | sudo tee /etc/apt/sources.list.d/kubernetes.list

RUN curl -fsSL https://packages.buildkite.com/helm-linux/helm-debian/gpgkey | sudo gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/helm.gpg] https://packages.buildkite.com/helm-linux/helm-debian/any/ any main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list

RUN sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc && chmod a+r /etc/apt/keyrings/docker.asc && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list

RUN apt-get update && apt-get install -y golang-go kubectl helm docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

RUN curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 && install minikube-linux-amd64 /usr/local/bin/minikube && rm minikube-linux-amd64

RUN curl -L "https://github.com/kubernetes-sigs/kubebuilder/releases/download/v$KUBEBUILDER_VERSION/kubebuilder_linux_amd64" -o kubebuilder && install kubebuilder /usr/local/bin/kubebuilder && rm kubebuilder

RUN usermod -aG docker vscode
