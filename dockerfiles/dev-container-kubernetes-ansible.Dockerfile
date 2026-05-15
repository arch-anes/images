# This assumes dev-container-kubernetes is built and tagged locally
# or available in your registry.
FROM dev-container-kubernetes

RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list

RUN apt-get update && apt-get install -y pipx vagrant \
    && rm -rf /var/lib/apt/lists/*

# Workaround for https://github.com/pypa/pipx/issues/754#issuecomment-951162846
# Fixed in pipx 1.5.0 but not yet available in apt which has pipx 1.4.3
RUN PIPX_HOME=/opt/pipx PIPX_BIN_DIR=/usr/local/bin pipx install --include-deps ansible uv && \
    PIPX_HOME=/opt/pipx PIPX_BIN_DIR=/usr/local/bin pipx inject  --include-deps ansible jmespath netaddr boto3 ansible-lint molecule molecule-plugins[docker]
