FROM ghcr.io/actions/actions-runner:latest

ARG KUBECTL_VERSION=1.30

RUN curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -

RUN sudo add-apt-repository ppa:longsleep/golang-backports

RUN curl -fsSL https://pkgs.k8s.io/core:/stable:/v$KUBECTL_VERSION/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg && \
    echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v$KUBECTL_VERSION/deb/ /" | sudo tee /etc/apt/sources.list.d/kubernetes.list

RUN sudo apt-get update && sudo apt-get install -y software-properties-common build-essential kubectl golang-go nodejs apt-transport-https pipx
