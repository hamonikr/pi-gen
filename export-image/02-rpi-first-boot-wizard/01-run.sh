#!/bin/bash -e

OWNER=$(cat ${ROOTFS_DIR}/etc/passwd | grep rpi-first-boot-wizard | cut -d':' -f3)
GROUP=$(cat ${ROOTFS_DIR}/etc/passwd | grep rpi-first-boot-wizard | cut -d':' -f4)

echo $OWNER
echo $GROUP

# first boot user is rpi-first-boot-wizard
if [ -d "${ROOTFS_DIR}/home/rpi-first-boot-wizard" ]; then
	#rpi-first-boot-wizard
	install -m 644 -v -o $OWNER -g $GROUP files/.zshrc "${ROOTFS_DIR}/home/rpi-first-boot-wizard/"
	install -m 644 files/.zshrc "${ROOTFS_DIR}/etc/skel/"
	install -v -o $OWNER -g $GROUP -d "${ROOTFS_DIR}/home/rpi-first-boot-wizard/.config"
	install -m 600 -v -o 1000 -g 1000 files/mimeapps.list "${ROOTFS_DIR}/home/rpi-first-boot-wizard/.config/"
else
	mkdir ${ROOTFS_DIR}/home/rpi-first-boot-wizard
	install -m 644 -v -o $OWNER -g $GROUP files/.zshrc "${ROOTFS_DIR}/home/rpi-first-boot-wizard/"
	install -m 644 files/.zshrc "${ROOTFS_DIR}/etc/skel/"
	install -v -o $OWNER -g $GROUP -d "${ROOTFS_DIR}/home/rpi-first-boot-wizard/.config"
	install -m 600 -v -o 1000 -g 1000 files/mimeapps.list "${ROOTFS_DIR}/home/rpi-first-boot-wizard/.config/"
fi

#hamonikr-zsh fixes (pi user)
install -m 644 -v -o 1000 -g 1000 files/.zshrc "${ROOTFS_DIR}/home/pi/"
sed -i 's#/bin/bash#/usr/bin/zsh#g' ${ROOTFS_DIR}/etc/passwd

install -v -o 1000 -g 1000 -d "${ROOTFS_DIR}/home/pi/.config"
install -m 600 -v -o 1000 -g 1000 files/mimeapps.list "${ROOTFS_DIR}/home/pi/.config/"

on_chroot << EOF
	SUDO_USER="${FIRST_USER_NAME}" systemctl enable NetworkManager.service
EOF