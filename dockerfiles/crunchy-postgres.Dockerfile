ARG DEV_CONTAINER_VERSION
ARG VERSION

FROM mcr.microsoft.com/devcontainers/base:${DEV_CONTAINER_VERSION} AS base

# Don't forget to run the update command on postgresql server
# https://immich.app/docs/administration/postgres-standalone#updating-vectorchord
ARG VCHORD_VERSION=1.1.1

RUN curl -o vchord.deb -fsSL https://github.com/tensorchord/VectorChord/releases/download/${VCHORD_VERSION}/postgresql-17-vchord_${VCHORD_VERSION}-1_amd64.deb && \
    dpkg --force-all -i vchord.deb && rm -f vchord.deb

FROM registry.developers.crunchydata.com/crunchydata/crunchy-postgres:${VERSION}

COPY --from=base /usr/lib/postgresql/17/lib/* /usr/pgsql-17/lib/
COPY --from=base /usr/share/postgresql/17/extension/* /usr/pgsql-17/share/extension/

USER root

ARG TIMESCALEDB_VERSION=2.26.3
# https://github.com/CrunchyData/postgres-operator/issues/2692#issuecomment-1687095661
RUN curl -sSL -o /etc/yum.repos.d/timescale_timescaledb.repo "https://packagecloud.io/install/repositories/timescale/timescaledb/config_file.repo?os=el&dist=9" && \
    microdnf update -y && \
    microdnf install -y timescaledb-2-loader-postgresql-17-${TIMESCALEDB_VERSION} && \
    microdnf install -y timescaledb-2-postgresql-17-${TIMESCALEDB_VERSION} && \
    microdnf clean all

USER 26
