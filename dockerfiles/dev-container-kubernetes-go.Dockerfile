FROM dev-container-kubernetes

RUN sudo add-apt-repository ppa:longsleep/golang-backports

ARG KUBEBUILDER_VERSION=4.5.0

RUN apt-get update && apt-get install -y golang-go \
    && rm -rf /var/lib/apt/lists/*

RUN curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 && install minikube-linux-amd64 /usr/local/bin/minikube && rm minikube-linux-amd64

RUN curl -L "https://github.com/kubernetes-sigs/kubebuilder/releases/download/v$KUBEBUILDER_VERSION/kubebuilder_linux_amd64" -o kubebuilder && install kubebuilder /usr/local/bin/kubebuilder && rm kubebuilder
