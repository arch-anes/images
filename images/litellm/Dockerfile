ARG VERSION
FROM ghcr.io/berriai/litellm-database:${VERSION}

# Workaround for https://github.com/BerriAI/litellm/issues/19361
RUN apk add --no-cache uv --quiet
