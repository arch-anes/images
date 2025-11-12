FROM ghcr.io/dockur/windows:5.13

RUN apt-get update && \ 
    apt-get --no-install-recommends -y install \
        qemu-system-gui \
        qemu-system-modules-spice
