variable "USER" {
  default = "arch-anes"
}

variable "REGISTRY" {
  default = "ghcr.io"
}

group "default" {
  targets = [
    "crunchy-postgres",
    "dev-container-kubernetes-ansible",
    "dev-container-kubernetes-go",
    "github-actions-runner",
    "inventree",
    "litellm",
    "nextcloud",
    "stalwart-cli",
    "ubuntu-systemd",
    "windows"
  ]
}

# Common settings shared by all targets
target "common" {
  context = "."
  platforms = ["linux/amd64"]
}

function "tags" {
  params = [name]
  result = ["${REGISTRY}/${USER}/${name}:latest"]
}

target "crunchy-postgres" {
  inherits = ["common"]
  dockerfile = "dockerfiles/crunchy-postgres.Dockerfile"
  tags = tags("crunchy-postgres")
}

target "dev-container-kubernetes-ansible" {
  inherits = ["common"]
  dockerfile = "dockerfiles/dev-container-kubernetes-ansible.Dockerfile"
  tags = tags("dev-container-kubernetes-ansible")
}

target "dev-container-kubernetes-go" {
  inherits = ["common"]
  dockerfile = "dockerfiles/dev-container-kubernetes-go.Dockerfile"
  tags = tags("dev-container-kubernetes-go")
}

target "github-actions-runner" {
  inherits = ["common"]
  dockerfile = "dockerfiles/github-actions-runner.Dockerfile"
  tags = tags("github-actions-runner")
}

target "inventree" {
  inherits = ["common"]
  dockerfile = "dockerfiles/inventree.Dockerfile"
  tags = tags("inventree")
}

target "litellm" {
  inherits = ["common"]
  dockerfile = "dockerfiles/litellm.Dockerfile"
  tags = tags("litellm")
}

target "nextcloud" {
  inherits = ["common"]
  dockerfile = "dockerfiles/nextcloud.Dockerfile"
  tags = tags("nextcloud")
}

target "stalwart-cli" {
  inherits = ["common"]
  dockerfile = "dockerfiles/stalwart-cli.Dockerfile"
  tags = tags("stalwart-cli")
}

target "ubuntu-systemd" {
  inherits = ["common"]
  dockerfile = "dockerfiles/ubuntu-systemd.Dockerfile"
  tags = tags("ubuntu-systemd")
}

target "windows" {
  inherits = ["common"]
  dockerfile = "dockerfiles/windows.Dockerfile"
  tags = tags("windows")
}
