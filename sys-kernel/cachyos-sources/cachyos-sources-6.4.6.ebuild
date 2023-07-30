# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
EXTRAVERSION="-cachyos"
ETYPE="sources"
K_SECURITY_UNSUPPORTED="1"
K_EXP_GENPATCHES_NOUSE="1"
K_WANT_GENPATCHES="base extras"
K_GENPATCHES_VER="8"

inherit kernel-2
detect_version

CACHYOS_COMMIT="a85bf36d6d6928f5a4020e0d5f4479ba4e052870"
CACHYOS_GIT_URI="https://raw.githubusercontent.com/cachyos/kernel-patches/${CACHYOS_COMMIT}/${KV_MAJOR}.${KV_MINOR}"

DESCRIPTION="Linux kernel built upon CachyOS and Gentoo patchset's, aiming to provide improved performance and responsiveness for desktop workloads."
HOMEPAGE="https://github.com/CachyOS/linux-cachyos"
SRC_URI="
	${KERNEL_URI} ${GENPATCHES_URI}
	${CACHYOS_GIT_URI}/all/0001-cachyos-base-all.patch -> ${PV}-0001-cachyos-base-all.patch
	${CACHYOS_GIT_URI}/sched/0001-bore-cachy.patch -> ${PV}-0001-bore-cachy.patch
	${CACHYOS_GIT_URI}/misc/0001-bore-tuning-sysctl.patch -> ${PV}-0001-bore-tuning-sysctl.patch
	${CACHYOS_GIT_URI}/sched/0001-bore-eevdf.patch -> ${PV}-0001-bore-eevdf.patch
	${CACHYOS_GIT_URI}/sched/0001-EEVDF.patch -> ${PV}-0001-EEVDF.patch
	${CACHYOS_GIT_URI}/misc/0001-high-hz.patch -> ${PV}-0001-high-hz.patch
"

LICENSE="GPL"
SLOT="${KV_MAJOR}.${KV_MINOR}"
KEYWORDS="amd64"
IUSE="bore-eevdf eevdf bore high-hz"
REQUIRED_USE="
	|| ( bore bore-eevdf eevdf )
"

DEPEND="virtual/linux-sources"
RDEPEND="${DEPEND}"
BDEPEND=""

src_prepare() {
	eapply "${DISTDIR}/${PV}-0001-cachyos-base-all.patch"

	if use bore; then
		eapply "${DISTDIR}/${PV}-0001-bore-cachy.patch"
		eapply "${DISTDIR}/${PV}-0001-bore-tuning-sysctl.patch"
		# cp "${FILESDIR}/config-x86_64-bore" .config && elog "BORE config applied" || die
	fi

	if use bore-eevdf; then
		eapply "${DISTDIR}/${PV}-0001-EEVDF.patch"
      	eapply "${DISTDIR}/${PV}-0001-bore-eevdf.patch"
		# cp "${FILESDIR}/config-x86_64-eevdf" .config && elog "EEVDF config applied" || die
	fi

	if use eevdf; then
		eapply "${DISTDIR}/${PV}-0001-EEVDF.patch"
		# cp "${FILESDIR}/config-x86_64-eevdf" .config && elog "EEVDF config applied" || die
	fi

	if use high-hz; then
		eapply "${DISTDIR}/${PV}-0001-high-hz.patch"
	fi

	eapply_user
}

pkg_postinst() {
	elog "Default kernel config depending on selected scheduler has been applied."
	elog "You have to build kernel manually!"
	elog "Initramfs is required for all default configurations (dracut or genkernel)"
}
