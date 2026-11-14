ARG LLAMA_CPP_TAG=b10423

FROM ghcr.io/ggml-org/llama.cpp:server-rocm-${LLAMA_CPP_TAG} AS hip-build

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        build-essential \
        ca-certificates \
        cmake \
        curl \
        git \
        libgomp1 \
        libnuma-dev \
        libomp-dev \
        libssl-dev \
        python3 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /src
ARG LLAMA_CPP_TAG
RUN git clone --filter=blob:none --depth 1 --branch "${LLAMA_CPP_TAG}" \
        https://github.com/ggml-org/llama.cpp.git \
    && git -C llama.cpp describe --tags --exact-match | grep -Fx "${LLAMA_CPP_TAG}"

WORKDIR /src/llama.cpp
ARG ROCM_DOCKER_ARCH=gfx908;gfx90a;gfx942;gfx1010;gfx1030;gfx1100;gfx1101;gfx1102;gfx1150;gfx1151;gfx1200;gfx1201
RUN HIPCXX="$(hipconfig -l)/clang" HIP_PATH="$(hipconfig -R)" \
    cmake -S . -B build-hip \
        -DGGML_HIP=ON \
        -DAMDGPU_TARGETS="${ROCM_DOCKER_ARCH}" \
        -DGGML_BACKEND_DL=ON \
        -DGGML_CPU_ALL_VARIANTS=ON \
        -DGGML_CUDA_FORCE_MMQ=ON \
        -DGGML_HIP_GRAPHS=OFF \
        -DGGML_NATIVE=OFF \
        -DCMAKE_BUILD_TYPE=Release \
        -DLLAMA_BUILD_TESTS=OFF \
        -DGGML_BUILD_TESTS=OFF \
        -DGGML_BUILD_EXAMPLES=OFF \
    && cmake --build build-hip --config Release --target ggml-hip --parallel "$(nproc)" \
    && for arch in $(printf '%s' "${ROCM_DOCKER_ARCH}" | tr ';' ' '); do \
           strings build-hip/bin/libggml-hip.so | grep -q "${arch}"; \
       done \
    && mkdir -p /out \
    && cp -P build-hip/bin/libggml-hip.so /out/ \
    && printf '%s\n' "${LLAMA_CPP_TAG}" > /out/llama.cpp-tag

FROM ghcr.io/ggml-org/llama.cpp:server-rocm-${LLAMA_CPP_TAG} AS server-rocm

COPY --from=hip-build /out/ /app/

LABEL org.opencontainers.image.description="Server-only llama.cpp ROCm fat backend"
