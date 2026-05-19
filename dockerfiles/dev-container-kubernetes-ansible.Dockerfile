# This assumes dev-container-kubernetes is built and tagged locally
# or available in your registry.
FROM dev-container-kubernetes

RUN brew tap hashicorp/tap && brew install pipx hashicorp/tap/vagrant

RUN sudo $(which pipx) install --global --include-deps ansible uv && \
    sudo $(which pipx) inject  --global --include-deps ansible jmespath netaddr boto3 ansible-lint molecule molecule-plugins[docker]
