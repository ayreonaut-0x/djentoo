# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
EXTRAVERSION="-cachyos-bore"
K_SECURITY_UNSUPPORTED="1"
ETYPE="sources"
inherit kernel-2
detect_version

DESCRIPTION="CachyOS are improved kernels that improve performance and other aspects."
HOMEPAGE="https://github.com/CachyOS/linux-cachyos"
SRC_URI="${KERNEL_URI}"

LICENSE="GPL"
SLOT="6.1"
KEYWORDS="amd64"
IUSE="lto"
#REQUIRED_USE="bore? ( !cacule latency !prjc !tt ) cacule? ( !bore !latency !prjc !tt ) prjc? ( !bore !cacule !latency !tt ) tt? ( !bore !cacule !latency !prjc )"

DEPEND=""
RDEPEND=""
BDEPEND=""

src_prepare() {
#	eapply "${FILESDIR}/${KV_MAJOR}.${KV_MINOR}/${KV_MAJOR}.${KV_MINOR}-amd-pstate-epp-enhancement.patch"

	eapply "${FILESDIR}/0001-cachyos-base-all.patch"
	eapply "${FILESDIR}/0001-Add-latency-priority-for-CFS-class.patch"
	eapply "${FILESDIR}/0001-bore-cachy.patch"
	eapply "${FILESDIR}/0001-bore-tuning-sysctl.patch"

	if use lto; then
		eapply "${FILESDIR}/0001-gcc-LTO-support-for-the-kernel.patch"
		eapply "${FILESDIR}/0002-gcc-lto-no-pie.patch"
	fi

	eapply_user
}

pkg_postinst() {
	elog "You have to build kernel manually!"
}
