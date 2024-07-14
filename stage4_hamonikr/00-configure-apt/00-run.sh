#!/bin/bash -e

# add hamonikr repo
install -m 644 files/hamonikr.list "${ROOTFS_DIR}/etc/apt/sources.list.d/"

# add hamonikr gpg key
cat files/hamonikr.gpg.key | gpg --dearmor > "${ROOTFS_DIR}/etc/apt/trusted.gpg.d/hamonikr.gpg"

on_chroot << EOF
apt-get update
EOF
