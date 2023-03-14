#!/bin/bash -e

if [ -d "${ROOTFS_DIR}/home/rpi-first-boot-wizard" ]; then
	#rpi-first-boot-wizard
	install -m 644 files/.zshrc "${ROOTFS_DIR}/home/rpi-first-boot-wizard/"
	sed -i 's#/bin/bash#/usr/bin/zsh#g' ${ROOTFS_DIR}/etc/passwd
else
	mkdir ${ROOTFS_DIR}/home/rpi-first-boot-wizard
	install -m 644 files/.zshrc "${ROOTFS_DIR}/home/rpi-first-boot-wizard/"
	sed -i 's#/bin/bash#/usr/bin/zsh#g' ${ROOTFS_DIR}/etc/passwd
fi