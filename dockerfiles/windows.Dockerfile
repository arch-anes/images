FROM ghcr.io/dockur/windows:5.15

RUN apt-get update && \ 
    apt-get --no-install-recommends -y install \
        qemu-system-gui \
        qemu-system-modules-spice \
    && rm -rf /var/lib/apt/lists/*
