FROM ghcr.io/berriai/litellm-database:v1.83.7-stable

# Workaround for https://github.com/BerriAI/litellm/issues/19361
RUN apk add --no-cache uv --quiet
