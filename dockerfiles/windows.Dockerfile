FROM ghcr.io/dockur/windows:5.14

RUN apt-get update && \ 
    apt-get --no-install-recommends -y install \
        qemu-system-gui \
        qemu-system-modules-spice
