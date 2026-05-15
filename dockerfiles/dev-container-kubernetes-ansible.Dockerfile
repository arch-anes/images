# This assumes dev-container-kubernetes is built and tagged locally
# or available in your registry.
FROM dev-container-kubernetes

RUN brew tap hashicorp/tap && brew install hashicorp/tap/vagrant

RUN sudo apt-get update && sudo apt-get install -y pipx \
    && sudo rm -rf /var/lib/apt/lists/*

# Workaround for https://github.com/pypa/pipx/issues/754#issuecomment-951162846
# Fixed in pipx 1.5.0 but not yet available in apt which has pipx 1.4.3
RUN PIPX_HOME=/opt/pipx PIPX_BIN_DIR=/usr/local/bin sudo pipx install --include-deps ansible uv && \
    PIPX_HOME=/opt/pipx PIPX_BIN_DIR=/usr/local/bin sudo pipx inject  --include-deps ansible jmespath netaddr boto3 ansible-lint molecule molecule-plugins[docker]
