#!/bin/bash -e

#Alacarte fixes
install -v -o 1000 -g 1000 -d "${ROOTFS_DIR}/home/${FIRST_USER_NAME}/.local"
install -v -o 1000 -g 1000 -d "${ROOTFS_DIR}/home/${FIRST_USER_NAME}/.local/share"
install -v -o 1000 -g 1000 -d "${ROOTFS_DIR}/home/${FIRST_USER_NAME}/.local/share/applications"
install -v -o 1000 -g 1000 -d "${ROOTFS_DIR}/home/${FIRST_USER_NAME}/.local/share/desktop-directories"

#hamonikr-zsh fixes
cp ${ROOTFS_DIR}/etc/skel/.zshrc ${ROOTFS_DIR}/home/pi/
sed -i 's#/bin/bash#/usr/bin/zsh#g' ${ROOTFS_DIR}/etc/passwd

on_chroot << EOF
	SUDO_USER="${FIRST_USER_NAME}" systemctl enable NetworkManager.service
EOF