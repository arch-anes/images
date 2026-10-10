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
    "litellm",
    "nextcloud",
    "opencode",
    "strata",
    "zfs-exporter"
  ]
}

# Common settings shared by all targets
target "common" {
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
  context = "images/zfs-exporter"
  dockerfile = "Dockerfile"
  tags = tags("zfs-exporter", ZFS_EXPORTER_VERSION)
  args = {
    VERSION = ZFS_EXPORTER_VERSION
  }
}

# renovate: datasource=docker depName=registry.developers.crunchydata.com/crunchydata/crunchy-postgres versioning=regex:^ubi9-(?<major>17)\.(?<minor>\d+)-(?<patch>\d+)$
variable "CRUNCHY_POSTGRES_17_VERSION" {
  default = "ubi9-17.11-2633"
}

# renovate: datasource=docker depName=registry.developers.crunchydata.com/crunchydata/crunchy-postgres versioning=regex:^ubi9-(?<major>18)\.(?<minor>\d+)-(?<patch>\d+)$
variable "CRUNCHY_POSTGRES_18_VERSION" {
  default = "ubi9-18.6-2633"
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
  context = "images/crunchy-postgres"
  dockerfile = "Dockerfile"
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
  context = "images/dev-container"
  dockerfile = "Dockerfile"
  tags = tags("dev-container", DEV_CONTAINER_VERSION)
  args = {
    VERSION = DEV_CONTAINER_VERSION
  }
}

target "dev-container-kubernetes" {
  inherits = ["common"]
  context = "images/dev-container-kubernetes"
  dockerfile = "Dockerfile"
  tags = tags("dev-container-kubernetes", DEV_CONTAINER_VERSION)
  contexts = {
    dev-container = "target:dev-container"
  }
}

target "dev-container-kubernetes-ansible" {
  inherits = ["common"]
  context = "images/dev-container-kubernetes-ansible"
  dockerfile = "Dockerfile"
  contexts = {
    dev-container-kubernetes = "target:dev-container-kubernetes"
  }
  tags = tags("dev-container-kubernetes-ansible", DEV_CONTAINER_VERSION)
}

variable "LITELLM_VERSION" {
  default = "v1.83.14-stable"
}
target "litellm" {
  inherits = ["common"]
  context = "images/litellm"
  dockerfile = "Dockerfile"
  tags = tags("litellm", LITELLM_VERSION)
  args = {
    VERSION = LITELLM_VERSION
  }
}

# renovate: datasource=docker depName=nextcloud
variable "NEXTCLOUD_VERSION" {
  default = "35.0.1-fpm-alpine"
}
target "nextcloud" {
  inherits = ["common"]
  context = "images/nextcloud"
  dockerfile = "Dockerfile"
  tags = tags("nextcloud", NEXTCLOUD_VERSION)
  args = {
    VERSION = NEXTCLOUD_VERSION
  }
}

# renovate: datasource=github-releases depName=anomalyco/opencode
variable "OPENCODE_VERSION" {
  default = "1.18.31"
}
target "opencode" {
  inherits = ["common"]
  context = "images/opencode"
  dockerfile = "Dockerfile"
  tags = tags("opencode", OPENCODE_VERSION)
  contexts = {
    dev-container = "target:dev-container"
  }
  args = {
    VERSION = OPENCODE_VERSION
  }
}

# renovate: datasource=github-releases depName=Niko1221/Strata
variable "STRATA_VERSION" {
  default = "0.1.42"
}

# renovate: datasource=docker depName=rocm/dev-ubuntu-24.04 versioning=regex:^(?<major>\d+)\.(?<minor>\d+)\.(?<patch>\d+)-full$
variable "ROCM_VERSION" {
  default = "10.1.0-full"
}

target "strata" {
  inherits = ["common"]
  context = "images/strata"
  dockerfile = "Dockerfile"
  tags = tags("strata", STRATA_VERSION)
  args = {
    ROCM_VERSION = ROCM_VERSION
    STRATA_VERSION = STRATA_VERSION
  }
}

variable "UBUNTU_SYSTEMD_VERSION" {
  default = "26.04"
}
