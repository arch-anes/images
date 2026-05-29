variable "USER" {
  default = "arch-anes"
}

variable "REGISTRY" {
  default = "ghcr.io"
}

group "default" {
  targets = [
    "crunchy-postgres",
    "dev-container",
    "dev-container-kubernetes",
    "dev-container-kubernetes-ansible",
    "dev-container-kubernetes-go",
    "inventree",
    "litellm",
    "nextcloud",
    "stalwart-cli",
    "ubuntu-systemd",
    "windows",
    "zfs-exporter"
  ]
}

# Common settings shared by all targets
target "common" {
  context = "."
  platforms = ["linux/amd64"]
}

function "tags" {
  params = [name, version]
  result = distinct([
    "${REGISTRY}/${USER}/${name}:latest",
    "${REGISTRY}/${USER}/${name}:${version}"
  ])
}

# renovate: datasource=github-releases depName=pdf/zfs_exporter
variable "ZFS_EXPORTER_VERSION" {
  default = "2.3.12"
}
target "zfs-exporter" {
  inherits = ["common"]
  dockerfile = "dockerfiles/zfs-exporter.Dockerfile"
  tags = tags("zfs-exporter", ZFS_EXPORTER_VERSION)
  args = {
    VERSION = ZFS_EXPORTER_VERSION
  }
}

# renovate: datasource=docker depName=registry.developers.crunchydata.com/crunchydata/crunchy-postgres
variable "CRUNCHY_POSTGRES_VERSION" {
  default = "ubi9-17.9-2610"
}
target "crunchy-postgres" {
  inherits = ["common"]
  dockerfile = "dockerfiles/crunchy-postgres.Dockerfile"
  tags = tags("crunchy-postgres", CRUNCHY_POSTGRES_VERSION)
  args = {
    VERSION = CRUNCHY_POSTGRES_VERSION
    DEV_CONTAINER_VERSION = DEV_CONTAINER_VERSION
  }
}

variable "DEV_CONTAINER_VERSION" {
  default = "ubuntu26.04"
}
target "dev-container" {
  inherits = ["common"]
  dockerfile = "dockerfiles/dev-container.Dockerfile"
  tags = tags("dev-container", DEV_CONTAINER_VERSION)
  args = {
    VERSION = DEV_CONTAINER_VERSION
  }
}

target "dev-container-kubernetes" {
  inherits = ["common"]
  dockerfile = "dockerfiles/dev-container-kubernetes.Dockerfile"
  tags = tags("dev-container-kubernetes", DEV_CONTAINER_VERSION)
  contexts = {
    dev-container = "target:dev-container"
  }
}

target "dev-container-kubernetes-ansible" {
  inherits = ["common"]
  dockerfile = "dockerfiles/dev-container-kubernetes-ansible.Dockerfile"
  contexts = {
    dev-container-kubernetes = "target:dev-container-kubernetes"
  }
  tags = tags("dev-container-kubernetes-ansible", DEV_CONTAINER_VERSION)
}

target "dev-container-kubernetes-go" {
  inherits = ["common"]
  dockerfile = "dockerfiles/dev-container-kubernetes-go.Dockerfile"
  contexts = {
    dev-container-kubernetes = "target:dev-container-kubernetes"
  }
  tags = tags("dev-container-kubernetes-go", DEV_CONTAINER_VERSION)
}

# renovate: datasource=docker depName=inventree/inventree
variable "INVENTREE_VERSION" {
  default = "1.3.3"
}
target "inventree" {
  inherits = ["common"]
  dockerfile = "dockerfiles/inventree.Dockerfile"
  tags = tags("inventree", INVENTREE_VERSION)
  args = {
    VERSION = INVENTREE_VERSION
  }
}

variable "LITELLM_VERSION" {
  default = "v1.83.14-stable"
}
target "litellm" {
  inherits = ["common"]
  dockerfile = "dockerfiles/litellm.Dockerfile"
  tags = tags("litellm", LITELLM_VERSION)
  args = {
    VERSION = LITELLM_VERSION
  }
}

# renovate: datasource=docker depName=nextcloud
variable "NEXTCLOUD_VERSION" {
  default = "33.0.3-fpm-alpine"
}
target "nextcloud" {
  inherits = ["common"]
  dockerfile = "dockerfiles/nextcloud.Dockerfile"
  tags = tags("nextcloud", NEXTCLOUD_VERSION)
  args = {
    VERSION = NEXTCLOUD_VERSION
  }
}

target "stalwart-cli" {
  inherits = ["common"]
  dockerfile = "dockerfiles/stalwart-cli.Dockerfile"
  tags = tags("stalwart-cli", "latest")
}

variable "UBUNTU_SYSTEMD_VERSION" {
  default = "26.04"
}
target "ubuntu-systemd" {
  inherits = ["common"]
  dockerfile = "dockerfiles/ubuntu-systemd.Dockerfile"
  tags = tags("ubuntu-systemd", UBUNTU_SYSTEMD_VERSION)
  args = {
    VERSION = UBUNTU_SYSTEMD_VERSION
  }
}

# renovate: datasource=docker depName=ghcr.io/dockur/windows
variable "WINDOWS_VERSION" {
  default = "5.15"
}
target "windows" {
  inherits = ["common"]
  dockerfile = "dockerfiles/windows.Dockerfile"
  tags = tags("windows", WINDOWS_VERSION)
  args = {
    VERSION = WINDOWS_VERSION
  }
}
