#!/bin/bash -e

if [[ "${DISABLE_FIRST_BOOT_USER_RENAME}" == "0" ]]; then
	on_chroot <<- EOF
		SUDO_USER="${FIRST_USER_NAME}" rename-user -f -s

		sed -i 's/autologin-user=.*$/autologin-user=${FIRST_USER_NAME}/g' /etc/lightdm/lightdm.conf || true

	EOF
else
	rm -f "${ROOTFS_DIR}/etc/xdg/autostart/piwiz.desktop"
fi
