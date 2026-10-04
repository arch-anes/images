ARG DEV_CONTAINER_VERSION
ARG VERSION

FROM mcr.microsoft.com/devcontainers/base:${DEV_CONTAINER_VERSION} AS base

# Don't forget to run the update command on postgresql server
# https://immich.app/docs/administration/postgres-standalone#updating-vectorchord
ARG VCHORD_VERSION=1.1.1
ARG PG_MAJOR

RUN curl -o vchord.deb -fsSL https://github.com/tensorchord/VectorChord/releases/download/${VCHORD_VERSION}/postgresql-${PG_MAJOR}-vchord_${VCHORD_VERSION}-1_amd64.deb && \
    dpkg --force-all -i vchord.deb && rm -f vchord.deb

FROM registry.developers.crunchydata.com/crunchydata/crunchy-postgres:${VERSION}

ARG PG_MAJOR

COPY --from=base /usr/lib/postgresql/${PG_MAJOR}/lib/* /usr/pgsql-${PG_MAJOR}/lib/
COPY --from=base /usr/share/postgresql/${PG_MAJOR}/extension/* /usr/pgsql-${PG_MAJOR}/share/extension/

USER root

ARG TIMESCALEDB_VERSION=2.27.1
# https://github.com/CrunchyData/postgres-operator/issues/2692#issuecomment-1687095661
RUN curl -sSL -o /etc/yum.repos.d/timescale_timescaledb.repo "https://packagecloud.io/install/repositories/timescale/timescaledb/config_file.repo?os=el&dist=9" && \
    microdnf install -y timescaledb-2-loader-postgresql-${PG_MAJOR}-${TIMESCALEDB_VERSION} && \
    microdnf install -y timescaledb-2-postgresql-${PG_MAJOR}-${TIMESCALEDB_VERSION} && \
    microdnf clean all

USER 26
