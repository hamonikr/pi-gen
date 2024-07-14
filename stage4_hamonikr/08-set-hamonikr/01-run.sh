#!/bin/bash -e

# lightdm setting
if [ -f "${ROOTFS_DIR}/etc/lightdm/lightdm.conf" ]; then
	if [ -f "${ROOTFS_DIR}/etc/hamonikr/info" ]; then
		echo "Update lightdm.conf..."
		sed -i 's/greeter-hide-users=.*$/greeter-hide-users=false/g' ${ROOTFS_DIR}/etc/lightdm/lightdm.conf
		sed -i 's/greeter-session=.*$/greeter-session=ukui-greeter/g' ${ROOTFS_DIR}/etc/lightdm/lightdm.conf
		sed -i 's/user-session=.*$/user-session=cinnamon/g' ${ROOTFS_DIR}/etc/lightdm/lightdm.conf
		# sed -i 's/autologin-user=.*$/autologin-user=/g' ${ROOTFS_DIR}/etc/lightdm/lightdm.conf
		sed -i 's/autologin-session=.*$/autologin-sessio=cinnamon/g' ${ROOTFS_DIR}/etc/lightdm/lightdm.conf
	else
		echo "Not detect HamoniKR OS... lightdm step"
	fi	
else
	echo "Not found lightdm.conf..."
fi

if [ -f "${ROOTFS_DIR}/etc/hamonikr/info" ] && [ -f "${ROOTFS_DIR}/usr/bin/zsh" ] ; then
	echo "Update hamonikr-zsh settings..."
	install -m 644 files/.zshrc "${ROOTFS_DIR}/etc/skel/"
	sed -i 's#/bin/bash#/usr/bin/zsh#g' ${ROOTFS_DIR}/etc/passwd	
	install -D -m 644 -v -o 1000 -g 1000 files/.zshrc "${ROOTFS_DIR}/home/${FIRST_USER_NAME}/"

	echo "Update hamonikr-theme settings..."
	[ ! -d "${ROOTFS_DIR}/home/${FIRST_USER_NAME}/.config/autostart" ] && install -v -o 1000 -g 1000 -d "${ROOTFS_DIR}/home/${FIRST_USER_NAME}/.config/autostart"
	install -D -m 644 -v -o 1000 -g 1000 files/hamonikr-theme.desktop "${ROOTFS_DIR}/home/${FIRST_USER_NAME}/.config/autostart/"

	echo "Update plank settings..."
	[ ! -d "${ROOTFS_DIR}/home/${FIRST_USER_NAME}/.config/plank/dock1/launchers/" ] && install -v -o 1000 -g 1000 -d "${ROOTFS_DIR}/home/${FIRST_USER_NAME}/.config/plank/dock1/launchers/"	
	install -D -m 644 -v -o 1000 -g 1000 ${ROOTFS_DIR}/etc/skel/.config/plank/dock1/launchers/*.dockitem "${ROOTFS_DIR}/home/${FIRST_USER_NAME}/.config/plank/dock1/launchers/"

	echo "Update welcome settings..."
	[ ! -d "${ROOTFS_DIR}/home/${FIRST_USER_NAME}/.hamonikr/hamonikrwelcome" ] && install -v -o 1000 -g 1000 -d "${ROOTFS_DIR}/home/${FIRST_USER_NAME}/.hamonikr/hamonikrwelcome"
	install -D -m 644 -v -o 1000 -g 1000 files/norun.flag "${ROOTFS_DIR}/home/${FIRST_USER_NAME}/.hamonikr/hamonikrwelcome/"

	echo "Update other settings..."
	install -D -m 600 -v -o 1000 -g 1000 files/mimeapps.list "${ROOTFS_DIR}/home/${FIRST_USER_NAME}/.config/"		
	install -m 644 -v files/75source-profile "${ROOTFS_DIR}/etc/X11/Xsession.d/"

	echo "Update user home permission..."
	chown 1000:1000 -R ${ROOTFS_DIR}/home/${FIRST_USER_NAME}/.*
	chown 1000:1000 -R ${ROOTFS_DIR}/home/${FIRST_USER_NAME}/*

	# update-pi-first-boot-wizard
	# OWNER=$(cat ${ROOTFS_DIR}/etc/passwd | grep rpi-first-boot-wizard | cut -d':' -f3)
	# GROUP=$(cat ${ROOTFS_DIR}/etc/passwd | grep rpi-first-boot-wizard | cut -d':' -f4)
	# if [ -n "$OWNER" ] && [ -n "$OWGROUP" ]; then
	# 	echo "Update setting for rpi-first-boot-wizard ..."
	# 	echo "OWNER : $OWNER"
	# 	echo "GROUP : $GROUP"
	# else
	# 	echo "Can not detect rpi-first-boot-wizard in /etc/passwd ..."
	# 	cat ${ROOTFS_DIR}/etc/passwd
	# 	OWNER="rpi-first-boot-wizard"
	# 	GROUP="65534"
	# fi
	# mkdir -pv ${ROOTFS_DIR}/home/rpi-first-boot-wizard/
	# cp -av ${ROOTFS_DIR}/home/${FIRST_USER_NAME}/.config ${ROOTFS_DIR}/home/rpi-first-boot-wizard/
	# cp -av ${ROOTFS_DIR}/home/${FIRST_USER_NAME}/.hamonikr ${ROOTFS_DIR}/home/rpi-first-boot-wizard/
	# cp -av ${ROOTFS_DIR}/home/${FIRST_USER_NAME}/.zshrc ${ROOTFS_DIR}/home/rpi-first-boot-wizard/

	# chown $OWNER:$GROUP -R ${ROOTFS_DIR}/home/${FIRST_USER_NAME}/.*

fi

on_chroot << EOF
	SUDO_USER="${FIRST_USER_NAME}" systemctl enable NetworkManager.service

	if [ -f "/usr/bin/cinnamon-session" ] && [ -f "/etc/hamonikr/info" ]; then
		echo "Set cinnamon as default..."
		SUDO_USER="${FIRST_USER_NAME}" update-alternatives --set x-session-manager /usr/bin/cinnamon-session
	fi

	if [ -f "/usr/share/plymouth/themes/hamonikr-black/hamonikr-black.plymouth" ] && [ -f "/etc/hamonikr/info" ]; then
		echo "Set plymouth theme as hamonikr-black..."
		SUDO_USER="${FIRST_USER_NAME}" plymouth-set-default-theme hamonikr-black
		SUDO_USER="${FIRST_USER_NAME}" update-initramfs -u
	fi
EOF