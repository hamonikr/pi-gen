#!/bin/bash -e

install -m 644 files/sources.list "${ROOTFS_DIR}/etc/apt/"
install -m 644 files/raspi.list "${ROOTFS_DIR}/etc/apt/sources.list.d/"
sed -i "s/RELEASE/${RELEASE}/g" "${ROOTFS_DIR}/etc/apt/sources.list"
sed -i "s/RELEASE/${RELEASE}/g" "${ROOTFS_DIR}/etc/apt/sources.list.d/raspi.list"

if [ -n "$APT_PROXY" ]; then
	install -m 644 files/51cache "${ROOTFS_DIR}/etc/apt/apt.conf.d/51cache"
	sed "${ROOTFS_DIR}/etc/apt/apt.conf.d/51cache" -i -e "s|APT_PROXY|${APT_PROXY}|"
else
	rm -f "${ROOTFS_DIR}/etc/apt/apt.conf.d/51cache"
fi

cat files/raspberrypi.gpg.key | gpg --dearmor > "${STAGE_WORK_DIR}/raspberrypi-archive-stable.gpg"
install -m 644 "${STAGE_WORK_DIR}/raspberrypi-archive-stable.gpg" "${ROOTFS_DIR}/etc/apt/trusted.gpg.d/"

# Add missing GPG keys
echo "Add missing GPG keys..."
gpg --keyserver keyserver.ubuntu.com --recv-keys 0E98404D386FA1D9 > /dev/null 2>&1
gpg --keyserver keyserver.ubuntu.com --recv-keys 6ED0E7B82643E131 > /dev/null 2>&1
gpg --keyserver keyserver.ubuntu.com --recv-keys F8D2585B8783D481 > /dev/null 2>&1
gpg --keyserver keyserver.ubuntu.com --recv-keys 54404762BBB6E853 > /dev/null 2>&1
gpg --keyserver keyserver.ubuntu.com --recv-keys BDE6D2B9216EC7A8 > /dev/null 2>&1
gpg --export 0E98404D386FA1D9 | sudo tee ${ROOTFS_DIR}/etc/apt/trusted.gpg.d/debian-archive-bullseye-automatic.gpg > /dev/null 2>&1
gpg --export 6ED0E7B82643E131 | sudo tee ${ROOTFS_DIR}/etc/apt/trusted.gpg.d/debian-archive-bookworm-automatic.gpg > /dev/null 2>&1
gpg --export F8D2585B8783D481 | sudo tee ${ROOTFS_DIR}/etc/apt/trusted.gpg.d/debian-archive-bookworm-stable.gpg > /dev/null 2>&1
gpg --export 54404762BBB6E853 | sudo tee ${ROOTFS_DIR}/etc/apt/trusted.gpg.d/debian-archive-bullseye-security.gpg > /dev/null 2>&1
gpg --export BDE6D2B9216EC7A8 | sudo tee ${ROOTFS_DIR}/etc/apt/trusted.gpg.d/debian-archive-bookworm-security.gpg > /dev/null 2>&1


on_chroot <<- \EOF
	ARCH="$(dpkg --print-architecture)"
	if [ "$ARCH" = "armhf" ]; then
		dpkg --add-architecture arm64
	elif [ "$ARCH" = "arm64" ]; then
		dpkg --add-architecture armhf
	fi

	apt-get update
	apt-get dist-upgrade -y
	apt-get upgrade -y
EOF
