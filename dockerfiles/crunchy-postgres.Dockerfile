FROM mcr.microsoft.com/vscode/devcontainers/base:ubuntu-24.04 AS base

# Don't forget to run the update command on postgresql server
# https://immich.app/docs/administration/postgres-standalone#updating-vectorchord
ARG VCHORD_VERSION=0.4.2

RUN curl -o vchord.deb -fsSL https://github.com/tensorchord/VectorChord/releases/download/${VCHORD_VERSION}/postgresql-17-vchord_${VCHORD_VERSION}-1_amd64.deb && \
    dpkg -i vchord.deb && rm -f vchord.deb

FROM registry.developers.crunchydata.com/crunchydata/crunchy-postgres:ubi9-17.5-2520

COPY --from=base /usr/lib/postgresql/17/lib/* /usr/pgsql-17/lib/
COPY --from=base /usr/share/postgresql/17/extension/* /usr/pgsql-17/share/extension/

USER root

RUN curl -o pgdg-repo.rpm -fsSL https://download.postgresql.org/pub/repos/yum/reporpms/EL-9-x86_64/pgdg-redhat-repo-latest.noarch.rpm && \
    rpm -i pgdg-repo.rpm && \
    rm -f pgdg-repo.rpm && \
    microdnf install -y pgvector_17

USER postgres
