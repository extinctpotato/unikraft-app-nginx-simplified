#!/bin/sh

kernel="build/unikraft-nginx_qemu-x86_64"
cmd="-c /nginx/conf/nginx.conf"
rootfs="rootfs/"

qemu-system-x86_64 \
    -kernel "$kernel" \
    -m 64M \
    -netdev tap,id=en0,ifname=tap0,script=no,downscript=no \
    -device virtio-net-pci,netdev=en0 \
    -append "netdev.ipv4_addr=172.44.0.2 netdev.ipv4_gw_addr=172.44.0.1 netdev.ipv4_subnet_mask=255.255.255.0 -- $cmd" \
    -fsdev local,id=myid,path="$rootfs",security_model=none \
    -device virtio-9p-pci,fsdev=myid,mount_tag=fs1,disable-modern=on,disable-legacy=off \
    -cpu max \
    -nographic \
    -no-shutdown
