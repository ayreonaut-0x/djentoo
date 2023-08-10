# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
EXTRAVERSION="-cachyos"
ETYPE="sources"
K_SECURITY_UNSUPPORTED="1"
K_EXP_GENPATCHES_NOUSE="1"
K_WANT_GENPATCHES="base extras"
K_GENPATCHES_VER="11"

inherit kernel-2
detect_version

CACHYOS_COMMIT="13c4b94b6065c6e70ac966a32b4a5e825a48cac3"
CACHYOS_GIT_URI="https://raw.githubusercontent.com/cachyos/kernel-patches/${CACHYOS_COMMIT}/${KV_MAJOR}.${KV_MINOR}"

DESCRIPTION="Linux kernel built upon CachyOS and Gentoo patchset's, aiming to provide improved performance and responsiveness for desktop workloads."
HOMEPAGE="https://github.com/CachyOS/linux-cachyos"
SRC_URI="
	${KERNEL_URI} ${GENPATCHES_URI}
	${CACHYOS_GIT_URI}/all/0001-cachyos-base-all.patch -> ${P}-0001-cachyos-base-all.patch
	${CACHYOS_GIT_URI}/misc/0001-bore-tuning-sysctl.patch -> ${P}-0001-bore-tuning-sysctl.patch
	${CACHYOS_GIT_URI}/misc/0001-high-hz.patch -> ${P}-0001-high-hz.patch
	${CACHYOS_GIT_URI}/sched/0001-bore-cachy.patch -> ${P}-0001-bore-cachy.patch
	${CACHYOS_GIT_URI}/sched/0001-EEVDF.patch -> ${P}-0001-EEVDF.patch
	${CACHYOS_GIT_URI}/sched/0001-bore-eevdf.patch -> ${P}-0001-bore-eevdf.patch
	${CACHYOS_GIT_URI}/sched/0001-tt-cachy.patch -> ${P}-0001-tt-cachy.patch
	${CACHYOS_GIT_URI}/sched/0001-prjc-cachy.patch -> ${P}-0001-prjc-cachy.patch
"

LICENSE="GPL"
SLOT="stable"
KEYWORDS="amd64"
IUSE="bore +bore-eevdf cfs eevdf high-hz prjc tt"
REQUIRED_USE="
	|| ( bore bore-eevdf cfs eevdf prjc tt )
	tt? ( high-hz )
"

DEPEND="virtual/linux-sources"
RDEPEND="${DEPEND}"
BDEPEND=""

PATCHES=( ${DISTDIR}/${P}-0001-cachyos-base-all.patch )

pkg_setup() {
	use bore && PATCHES+=(
		${DISTDIR}/${P}-0001-bore-cachy.patch
		${DISTDIR}/${P}-0001-bore-tuning-sysctl.patch
	)

	use bore-eevdf && PATCHES+=(
		${DISTDIR}/${P}-0001-EEVDF.patch
      	${DISTDIR}/${P}-0001-bore-eevdf.patch
	)

	use eevdf && PATCHES+=( ${DISTDIR}/${P}-0001-EEVDF.patch )
	use prjc && PATCHES+=( ${DISTDIR}/${P}-0001-prjc-cachy.patch )
	use tt && PATCHES+=( ${DISTDIR}/${P}-0001-tt-cachy.patch )
	use high-hz && PATCHES+=( ${DISTDIR}/${P}-0001-high-hz.patch )
}

src_prepare() {
	default
	eapply_user
}

pkg_postinst() {
	elog "Default kernel config depending on selected scheduler has been applied."
	elog "You have to build kernel manually!"
	elog "Initramfs is required for all default configurations (dracut or genkernel)"
}
