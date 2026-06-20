# This assumes dev-container-kubernetes is built and tagged locally
# or available in your registry.
FROM dev-container-kubernetes

RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list

RUN sudo apt-get update && sudo apt-get install -y qemu-system-x86 libvirt-daemon-system libvirt-dev vagrant \
    && sudo rm -rf /var/lib/apt/lists/*

RUN sudo usermod -G libvirt -a vscode

RUN brew install pipx

# https://github.com/ansible-community/molecule-plugins/issues/301#issuecomment-2629683469
RUN sudo $(which pipx) install --global --include-deps         ansible && \
    sudo $(which pipx) inject  --global --include-deps --force ansible uv jmespath netaddr boto3 ansible-lint "molecule==25.1.0" "molecule-plugins==23.7.0" "molecule-plugins[vagrant]==23.7.0" molecule-plugins[docker]

RUN vagrant plugin install vagrant-libvirt
