FROM mcr.microsoft.com/vscode/devcontainers/base:ubuntu-24.04 AS base

# Don't forget to run the update command on postgresql server
# https://immich.app/docs/administration/postgres-standalone#updating-vectorchord
ARG VCHORD_VERSION=1.0.0

RUN curl -o vchord.deb -fsSL https://github.com/tensorchord/VectorChord/releases/download/${VCHORD_VERSION}/postgresql-18-vchord_${VCHORD_VERSION}-1_amd64.deb && \
    dpkg --force-all -i vchord.deb && rm -f vchord.deb

FROM registry.developers.crunchydata.com/crunchydata/crunchy-postgres:ubi9-18.1-2550

COPY --from=base /usr/lib/postgresql/18/lib/* /usr/pgsql-18/lib/
COPY --from=base /usr/share/postgresql/18/extension/* /usr/pgsql-18/share/extension/
