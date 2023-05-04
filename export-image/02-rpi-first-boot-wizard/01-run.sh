#!/bin/bash -e

OWNER=$(cat ${ROOTFS_DIR}/etc/passwd | grep rpi-first-boot-wizard | cut -d':' -f3)
GROUP=$(cat ${ROOTFS_DIR}/etc/passwd | grep rpi-first-boot-wizard | cut -d':' -f4)

echo $OWNER
echo $GROUP

if [ ! -d "${ROOTFS_DIR}/home/rpi-first-boot-wizard" ]; then
	mkdir ${ROOTFS_DIR}/home/rpi-first-boot-wizard
fi

# rpi-first-boot-wizard
	# cp .zshrc > /home/rpi-first-boot-wizard/
install -m 644 -v -o $OWNER -g $GROUP files/.zshrc "${ROOTFS_DIR}/home/rpi-first-boot-wizard/"
	# cp .zshrc > /etc/skel
install -m 644 files/.zshrc "${ROOTFS_DIR}/etc/skel/"

	# cp mimeapps.list > /home/rpi-first-boot-wizard/.config/
install -v -o $OWNER -g $GROUP -d "${ROOTFS_DIR}/home/rpi-first-boot-wizard/.config"
install -m 600 -v -o $OWNER -g $GROUP files/mimeapps.list "${ROOTFS_DIR}/home/rpi-first-boot-wizard/.config/"

	# cp norun.flag > /home/rpi-first-boot-wizard/.hamonikr/hamonikrwelcome/
install -v -o $OWNER -g $GROUP -d "${ROOTFS_DIR}/home/rpi-first-boot-wizard/.hamonikr"
install -v -o $OWNER -g $GROUP -d "${ROOTFS_DIR}/home/rpi-first-boot-wizard/.hamonikr/hamonikrwelcome"
install -m 644 -v -o $OWNER -g $GROUP files/norun.flag "${ROOTFS_DIR}/home/rpi-first-boot-wizard/.hamonikr/hamonikrwelcome/"

	# cp hamonikr-theme.desktop > /home/rpi-first-boot-wizard/.config/autostart/
	# cp hamonikr-theme.desktop > /home/pi/.config/autostart/
install -v -o $OWNER -g $GROUP -d "${ROOTFS_DIR}/home/rpi-first-boot-wizard/.config/autostart"
install -v -o 1000 -g 1000 -d "${ROOTFS_DIR}/home/pi/.config/autostart"
install -m 644 -v -o $OWNER -g $GROUP files/hamonikr-theme.desktop "${ROOTFS_DIR}/home/rpi-first-boot-wizard/.config/autostart/"
install -m 644 -v -o 1000 -g 1000 files/hamonikr-theme.desktop "${ROOTFS_DIR}/home/pi/.config/autostart/"

# hamonikr-zsh fixes (pi user)
install -m 644 -v -o 1000 -g 1000 files/.zshrc "${ROOTFS_DIR}/home/pi/"
sed -i 's#/bin/bash#/usr/bin/zsh#g' ${ROOTFS_DIR}/etc/passwd

install -v -o 1000 -g 1000 -d "${ROOTFS_DIR}/home/pi/.config"
install -m 600 -v -o 1000 -g 1000 files/mimeapps.list "${ROOTFS_DIR}/home/pi/.config/"

# cp 75source-profile > /etc/X11/Xsession.d/
install -m 644 -v files/75source-profile "${ROOTFS_DIR}/etc/X11/Xsession.d/"

# update lightdm.conf
sed -i 's/#greeter-session=example-gtk-gnome/greeter-session=slick-greeter/g' ${ROOTFS_DIR}/etc/lightdm/lightdm.conf
sed -i 's/#greeter-hide-users=false/greeter-hide-users=false/g' ${ROOTFS_DIR}/etc/lightdm/lightdm.conf

on_chroot << EOF
	SUDO_USER="${FIRST_USER_NAME}" systemctl enable NetworkManager.service
EOF