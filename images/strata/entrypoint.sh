#!/bin/sh
set -eu

cd /opt/strata

STRATA_DATA="${STRATA_DATA:-/data}"
FAMILY="${FAMILY:-qwen}"
MODEL="${MODEL:-IQ2_XS}"
CONTEXT="${CONTEXT:-32768}"
VISION="${VISION:-no}"
HOST="${HOST:-127.0.0.1}"
PORT="${PORT:-8080}"
API_KEY="${API_KEY:-}"
LOW_RAM="${LOW_RAM:-auto}"
KV="${KV:-}"

if [ "$HOST" != "127.0.0.1" ] && [ -z "$API_KEY" ]; then
    echo "Set API_KEY when HOST is not 127.0.0.1." >&2
    exit 1
fi

case "$FAMILY" in
    qwen) prefix="" ;;
    *) prefix="${FAMILY}-" ;;
esac
tag="${prefix}$(printf '%s' "$MODEL" | tr 'A-Z' 'a-z')"
cfg="$STRATA_DATA/config/strata-$tag.json"
mkdir -p "$STRATA_DATA/config"

if [ "${REINSTALL:-0}" = "1" ] || [ ! -f "$cfg" ]; then
    echo "Setting up $tag. The engine is already included in this image."
    set -- --family "$FAMILY" --model "$MODEL" --context "$CONTEXT" \
        --vision "$VISION" --data-dir "$STRATA_DATA" --host "$HOST" \
        --api-key "$API_KEY" --port "$PORT" --no-start --low-ram "$LOW_RAM"
    if [ -n "$KV" ]; then set -- "$@" --kv "$KV"; fi
    if [ -n "${GPUS:-}" ]; then set -- "$@" --gpus "$GPUS"; fi
    if [ -n "${GPU:-}" ]; then set -- "$@" --gpu "$GPU"; fi
    if [ -n "${LAYER_SPLIT:-}" ]; then set -- "$@" --layer-split "$LAYER_SPLIT"; fi
    .venv/bin/python setup.py --setup --yes --backend hip "$@"
    if [ -e "/opt/strata/strata-$tag.json" ]; then
        if ! cmp -s "/opt/strata/strata-$tag.json" "$cfg"; then
            cp -f "/opt/strata/strata-$tag.json" "$cfg"
        fi
    fi
elif [ ! -e "/opt/strata/strata-$tag.json" ]; then
    ln -s "$cfg" "/opt/strata/strata-$tag.json"
fi

set -- --port "$PORT"
if [ -n "${GPUS:-}" ]; then set -- "$@" --gpus "$GPUS"; fi
if [ -n "${GPU:-}" ]; then set -- "$@" --gpu "$GPU"; fi
if [ -n "${LAYER_SPLIT:-}" ]; then set -- "$@" --layer-split "$LAYER_SPLIT"; fi
exec .venv/bin/python setup.py "$@"
