#!/bin/bash -e

# if [ -n "$FIRST_USER_NAME" ]; then
# 	# HamoniKR-specific settings
# 	if [ -f "${ROOTFS_DIR}/etc/hamonikr/info" ]; then
# 		echo "Update hamonikr-zsh settings..."
# 		install -m 644 files/.zshrc "${ROOTFS_DIR}/etc/skel/"
# 		sed -i 's#/bin/bash#/usr/bin/zsh#g' ${ROOTFS_DIR}/etc/passwd	
# 		install -D -m 644 -v -o 1000 -g 1000 files/.zshrc "${ROOTFS_DIR}/home/${FIRST_USER_NAME}/"
# 		[ ! -d "${ROOTFS_DIR}/home/${FIRST_USER_NAME}/.config/autostart" ] && mkdir -p "${ROOTFS_DIR}/home/${FIRST_USER_NAME}/.config/autostart"	
# 		install -D -m 600 -v -o 1000 -g 1000 files/mimeapps.list "${ROOTFS_DIR}/home/${FIRST_USER_NAME}/.config/"
# 		install -D -m 644 -v -o 1000 -g 1000 files/hamonikr-theme.desktop "${ROOTFS_DIR}/home/pi/.config/autostart/"
# 		install -m 644 -v files/75source-profile "${ROOTFS_DIR}/etc/X11/Xsession.d/"
# 	else
# 		echo "Not detect HamoniKR OS... zsh step"
# 	fi
# fi

if [ -f "${ROOTFS_DIR}/etc/lightdm/lightdm.conf" ]; then
	if [ -f "${ROOTFS_DIR}/etc/hamonikr/info" ]; then
		echo "Update lightdm.conf..."
		sed -i 's/greeter-hide-users=.*$/greeter-hide-users=false/g' ${ROOTFS_DIR}/etc/lightdm/lightdm.conf
		sed -i 's/greeter-session=.*$/greeter-session=ukui-greeter/g' ${ROOTFS_DIR}/etc/lightdm/lightdm.conf
		sed -i 's/user-session=.*$/user-session=cinnamon/g' ${ROOTFS_DIR}/etc/lightdm/lightdm.conf
		sed -i 's/autologin-usern=.*$/autologin-usern=/g' ${ROOTFS_DIR}/etc/lightdm/lightdm.conf	
		sed -i 's/autologin-session=.*$/autologin=cinnamon/g' ${ROOTFS_DIR}/etc/lightdm/lightdm.conf
	else
		echo "Not detect HamoniKR OS... lightdm step"
	fi	
else
	echo "Not found lightdm.conf..."
fi

# check rpi-first-boot-wizard
# OWNER=$(cat ${ROOTFS_DIR}/etc/passwd | grep rpi-first-boot-wizard | cut -d':' -f3)
# GROUP=$(cat ${ROOTFS_DIR}/etc/passwd | grep rpi-first-boot-wizard | cut -d':' -f4)

# if [ -n "$OWNER" ] && [ -n "$OWGROUP" ]; then
# 	echo "Update setting for rpi-first-boot-wizard ..."
# 	echo "OWNER : $OWNER"
# 	echo "GROUP : $GROUP"
# 	if [ ! -d "${ROOTFS_DIR}/home/rpi-first-boot-wizard" ]; then
# 		mkdir -p ${ROOTFS_DIR}/home/rpi-first-boot-wizard
# 	fi
# 	if [ -f "${ROOTFS_DIR}/etc/hamonikr/info" ]; then	
# 		install -m 644 -v -o $OWNER -g $GROUP files/.zshrc "${ROOTFS_DIR}/home/rpi-first-boot-wizard/"
# 		install -D -m 600 -v -o $OWNER -g $GROUP files/mimeapps.list "${ROOTFS_DIR}/home/rpi-first-boot-wizard/.config/"
# 		install -D -m 644 -v -o $OWNER -g $GROUP files/norun.flag "${ROOTFS_DIR}/home/rpi-first-boot-wizard/.hamonikr/hamonikrwelcome/"
# 		install -D -m 644 -v -o $OWNER -g $GROUP files/hamonikr-theme.desktop "${ROOTFS_DIR}/home/rpi-first-boot-wizard/.config/autostart/"
# 	else
# 		echo "Not detect HamoniKR OS... rpi-first-boot-wizard step"
# 	fi		
# fi

# if [ -d "${ROOTFS_DIR}/home/rpi-first-boot-wizard/" ]; then
# 	# debug
# 	ls -al ${ROOTFS_DIR}/home
# fi

on_chroot << EOF
	SUDO_USER="${FIRST_USER_NAME}" systemctl enable NetworkManager.service

	if [ -f "/usr/bin/cinnamon-session" ] && [ -f "/etc/hamonikr/info" ]; then
		SUDO_USER="${FIRST_USER_NAME}"update-alternatives --set x-session-manager /usr/bin/cinnamon-session
	fi

EOF