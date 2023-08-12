# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
EXTRAVERSION="-cachyos"
ETYPE="sources"
K_SECURITY_UNSUPPORTED="1"
K_EXP_GENPATCHES_NOUSE="1"
K_WANT_GENPATCHES="base extras"
K_GENPATCHES_VER="12"

inherit kernel-2
detect_version

CACHYOS_COMMIT="8a4e292e96a334f46fb03ba35fe51e5546099f40"
CACHYOS_GIT_URI="https://raw.githubusercontent.com/cachyos/kernel-patches/${CACHYOS_COMMIT}/${KV_MAJOR}.${KV_MINOR}"

DESCRIPTION="Linux kernel built upon CachyOS and Gentoo patchset's, aiming to provide improved performance and responsiveness for desktop workloads."
HOMEPAGE="https://github.com/CachyOS/linux-cachyos"
SRC_URI="
	${KERNEL_URI} ${GENPATCHES_URI}
	${CACHYOS_GIT_URI}/all/0001-cachyos-base-all.patch -> 0001-cachyos-base-all-${CACHYOS_COMMIT}.patch
	${CACHYOS_GIT_URI}/misc/0001-bore-tuning-sysctl.patch -> 0001-bore-tuning-sysctl-${CACHYOS_COMMIT}.patch
	${CACHYOS_GIT_URI}/misc/0001-high-hz.patch -> 0001-high-hz-${CACHYOS_COMMIT}.patch
	${CACHYOS_GIT_URI}/sched/0001-bore-cachy.patch -> 0001-bore-cachy-${CACHYOS_COMMIT}.patch
	${CACHYOS_GIT_URI}/sched/0001-EEVDF.patch -> 0001-EEVDF-${CACHYOS_COMMIT}.patch
	${CACHYOS_GIT_URI}/sched/0001-bore-eevdf.patch -> 0001-bore-eevdf-${CACHYOS_COMMIT}.patch
	${CACHYOS_GIT_URI}/sched/0001-tt-cachy.patch -> 0001-tt-cachy-${CACHYOS_COMMIT}.patch
	${CACHYOS_GIT_URI}/sched/0001-prjc-cachy.patch -> 0001-prjc-cachy-${CACHYOS_COMMIT}.patch
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

PATCHES=( ${DISTDIR}/0001-cachyos-base-all-${CACHYOS_COMMIT}.patch )

pkg_setup() {
	use bore && PATCHES+=(
		${DISTDIR}/0001-bore-cachy-${CACHYOS_COMMIT}.patch
		${DISTDIR}/0001-bore-tuning-sysctl-${CACHYOS_COMMIT}.patch
	)

	use bore-eevdf && PATCHES+=(
		${DISTDIR}/0001-EEVDF-${CACHYOS_COMMIT}.patch
      	${DISTDIR}/0001-bore-eevdf-${CACHYOS_COMMIT}.patch
	)

	use eevdf && PATCHES+=( ${DISTDIR}/0001-EEVDF-${CACHYOS_COMMIT}.patch )
	use prjc && PATCHES+=( ${DISTDIR}/0001-prjc-cachy-${CACHYOS_COMMIT}.patch )
	use tt && PATCHES+=( ${DISTDIR}/0001-tt-cachy-${CACHYOS_COMMIT}.patch )
	use high-hz && PATCHES+=( ${DISTDIR}/0001-high-hz-${CACHYOS_COMMIT}.patch )
}

src_prepare() {
	default
	eapply_user
}
