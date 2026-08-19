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
    "litellm",
    "llama-cpp",
    "nextcloud",
    "opencode",
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
  default = "2.4.1"
}
target "zfs-exporter" {
  inherits = ["common"]
  dockerfile = "dockerfiles/zfs-exporter.Dockerfile"
  tags = tags("zfs-exporter", ZFS_EXPORTER_VERSION)
  args = {
    VERSION = ZFS_EXPORTER_VERSION
  }
}

# renovate: datasource=docker depName=registry.developers.crunchydata.com/crunchydata/crunchy-postgres versioning=regex:^ubi9-(?<major>17)\.(?<minor>\d+)-(?<patch>\d+)$
variable "CRUNCHY_POSTGRES_17_VERSION" {
  default = "ubi9-17.9-2610"
}

# renovate: datasource=docker depName=registry.developers.crunchydata.com/crunchydata/crunchy-postgres versioning=regex:^ubi9-(?<major>18)\.(?<minor>\d+)-(?<patch>\d+)$
variable "CRUNCHY_POSTGRES_18_VERSION" {
  default = "ubi9-18.4-2621"
}

target "crunchy-postgres" {
  inherits = ["common"]
  matrix = {
    item = [
      { major = "17", version = CRUNCHY_POSTGRES_17_VERSION },
      { major = "18", version = CRUNCHY_POSTGRES_18_VERSION }
    ]
  }
  name = "crunchy-postgres-${item.major}"
  dockerfile = "dockerfiles/crunchy-postgres.Dockerfile"
  tags = [
    "${REGISTRY}/${USER}/crunchy-postgres:${item.version}",
    item.major == "18" ? "${REGISTRY}/${USER}/crunchy-postgres:latest" : ""
  ]
  args = {
    VERSION = item.version
    PG_MAJOR = item.major
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

# renovate: datasource=docker depName=ghcr.io/ggml-org/llama.cpp
variable "LLAMA_CPP_VERSION" {
  default = "b10499"
}

target "llama-cpp" {
  inherits = ["common"]
  dockerfile = "dockerfiles/llama.cpp.Dockerfile"
  tags = ["${REGISTRY}/${USER}/llama.cpp:server-rocm-${LLAMA_CPP_VERSION}"]
  args = {
    LLAMA_CPP_TAG = LLAMA_CPP_VERSION
  }
}

# renovate: datasource=docker depName=nextcloud
variable "NEXTCLOUD_VERSION" {
  default = "34.0.3-fpm-alpine"
}
target "nextcloud" {
  inherits = ["common"]
  dockerfile = "dockerfiles/nextcloud.Dockerfile"
  tags = tags("nextcloud", NEXTCLOUD_VERSION)
  args = {
    VERSION = NEXTCLOUD_VERSION
  }
}

# renovate: datasource=github-releases depName=anomalyco/opencode
variable "OPENCODE_VERSION" {
  default = "1.18.18"
}
target "opencode" {
  inherits = ["common"]
  dockerfile = "dockerfiles/opencode.Dockerfile"
  tags = tags("opencode", OPENCODE_VERSION)
  contexts = {
    dev-container = "target:dev-container"
  }
  args = {
    VERSION = OPENCODE_VERSION
  }
}

variable "UBUNTU_SYSTEMD_VERSION" {
  default = "26.04"
}

# renovate: datasource=docker depName=ghcr.io/dockur/windows
variable "WINDOWS_VERSION" {
  default = "6.04"
}
target "windows" {
  inherits = ["common"]
  dockerfile = "dockerfiles/windows.Dockerfile"
  tags = tags("windows", WINDOWS_VERSION)
  args = {
    VERSION = WINDOWS_VERSION
  }
}
