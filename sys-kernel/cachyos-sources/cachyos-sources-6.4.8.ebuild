# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
EXTRAVERSION="-cachyos"
ETYPE="sources"
K_SECURITY_UNSUPPORTED="1"
K_EXP_GENPATCHES_NOUSE="1"
K_WANT_GENPATCHES="base extras"
K_GENPATCHES_VER="10"

inherit kernel-2
detect_version

CACHYOS_COMMIT="ae00d555cc75d868752fae562c44c18c249a960f"
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
SLOT="${KV_MAJOR}.${KV_MINOR}"
KEYWORDS="amd64"
IUSE="bore +bore-eevdf eevdf high-hz prjc tt"
REQUIRED_USE="
	|| ( bore bore-eevdf eevdf prjc tt )
	tt? ( high-hz )
"

DEPEND="virtual/linux-sources"
RDEPEND="${DEPEND}"
BDEPEND=""

src_prepare() {
	eapply "${DISTDIR}/${P}-0001-cachyos-base-all.patch"

	use bore && \
		eapply "${DISTDIR}/${P}-0001-bore-cachy.patch" && \
		eapply "${DISTDIR}/${P}-0001-bore-tuning-sysctl.patch" \

	use bore-eevdf && \
		eapply "${DISTDIR}/${P}-0001-EEVDF.patch" && \
      	eapply "${DISTDIR}/${P}-0001-bore-eevdf.patch" \

	use eevdf && eapply "${DISTDIR}/${P}-0001-EEVDF.patch"
	use prjc && eapply	"${DISTDIR}/${P}-0001-prjc-cachy.patch"
	use tt && eapply "${DISTDIR}/${P}-0001-tt-cachy.patch"
	use high-hz && eapply "${DISTDIR}/${P}-0001-high-hz.patch"

	eapply_user
}

pkg_postinst() {
	elog "Default kernel config depending on selected scheduler has been applied."
	elog "You have to build kernel manually!"
	elog "Initramfs is required for all default configurations (dracut or genkernel)"
}
