# syntax=docker/dockerfile:1.28
#
# Build the Strata HIP engine into the image for an AMD RX 9070 XT (gfx1201).
# The GPU is not needed during the image build. The model and setup data live
# in /data, which should be mounted from persistent host storage.
#
# Build from the images repository root:
#   docker build --build-arg ROCM_VERSION=10.0.0-full \
#     --build-arg STRATA_VERSION=0.1.39 -t strata:latest images/strata/
#
# Run on Linux with the AMD GPU devices:
#   docker run --rm --network host \
#     --device /dev/kfd --device /dev/dri \
#     --group-add video --group-add render \
#     --security-opt seccomp=unconfined \
#     -v /storage/default/starta:/data \
#     -e LOW_RAM=on strata:latest
ARG ROCM_VERSION
FROM rocm/dev-ubuntu-24.04:${ROCM_VERSION}

ARG STRATA_VERSION

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 \
    PYTHONUNBUFFERED=1 \
    STRATA_EXECV=1 \
    HIP_PLATFORM=amd \
    HIP_COMPILER=clang \
    HIP_RUNTIME=rocclr \
    ROCM_PATH=/opt/rocm \
    HIP_PATH=/opt/rocm \
    LD_LIBRARY_PATH=/opt/rocm/lib:/opt/rocm/lib64

RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential ca-certificates curl git libatomic1 libgomp1 \
        python3 python3-pip python3-venv unzip \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt/strata
RUN git clone --depth 1 --branch "v${STRATA_VERSION}" \
        https://github.com/Niko1221/Strata.git /opt/strata \
    && rm -rf /opt/strata/.git

RUN --mount=type=cache,target=/root/.cache/pip \
    python3 -m venv .venv \
    && .venv/bin/pip install --upgrade pip \
    && .venv/bin/pip install -r requirements.txt

# Compile once while building the image. Supply gfx1201 directly because no GPU
# device is available during a normal Docker build.
RUN .venv/bin/python - <<'PY'
import shutil
import setup

llama = setup.get_llama_cpp()
setup.build_engine_hip({"arch": "gfx1201", "archs": ["gfx1201"]}, llama, vision="none")
shutil.rmtree(setup.ROOT / "build-hip", ignore_errors=True)
PY

COPY entrypoint.sh /usr/local/bin/strata-entrypoint
RUN chmod 0755 /usr/local/bin/strata-entrypoint

VOLUME ["/data"]
EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=5s --start-period=600s --retries=3 \
    CMD curl -fs "http://127.0.0.1:${PORT:-8080}/health" || exit 1

ENTRYPOINT ["/usr/local/bin/strata-entrypoint"]
