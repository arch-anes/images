FROM jrei/systemd-ubuntu:24.04

RUN apt update && apt install -y apt-transport-https curl iputils-ping software-properties-common sudo wget fuse-overlayfs
