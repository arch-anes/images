#!/bin/bash
set -e

echo "Configuring Libvirt/QEMU..."

if ! sudo grep -q '^user = "root"' /etc/libvirt/qemu.conf; then
    echo 'user = "root"' | sudo tee -a /etc/libvirt/qemu.conf
    echo 'group = "root"' | sudo tee -a /etc/libvirt/qemu.conf
fi

if [ -e /dev/kvm ]; then
    sudo chmod 666 /dev/kvm
fi

if ! pidof virtlogd > /dev/null; then
    echo "Starting virtlogd..."
    sudo nohup /usr/sbin/virtlogd -d > /tmp/virtlogd.log 2>&1 &
    sleep 2
fi

if ! pidof libvirtd > /dev/null; then
    echo "Starting libvirtd..."
    sudo nohup /usr/sbin/libvirtd -d > /tmp/libvirtd.log 2>&1 &
fi

echo "Waiting for libvirt socket..."
TIMEOUT=10
while [ ! -S /var/run/libvirt/libvirt-sock ]; do
    if [ $TIMEOUT -le 0 ]; then
        echo "Error: Timed out waiting for libvirt socket."
        exit 1
    fi
    sleep 1
    ((TIMEOUT--))
done

echo "Fixing socket permissions..."
sudo chown root:libvirt /var/run/libvirt/libvirt-sock
sudo chmod 770 /var/run/libvirt/libvirt-sock

echo "Libvirt setup complete."
