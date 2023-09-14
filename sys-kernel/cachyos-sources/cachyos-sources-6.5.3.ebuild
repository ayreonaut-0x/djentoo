# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
EXTRAVERSION="-cachyos"
ETYPE="sources"
K_SECURITY_UNSUPPORTED="1"
K_EXP_GENPATCHES_NOUSE="1"
K_WANT_GENPATCHES="base extras"
K_GENPATCHES_VER="4"

inherit kernel-2
detect_version

CACHYOS_COMMIT="3eacfc172f022b4c326febf331698cab23047ccc"
CACHYOS_GIT_URI="https://raw.githubusercontent.com/cachyos/kernel-patches/${CACHYOS_COMMIT}/${KV_MAJOR}.${KV_MINOR}"

DESCRIPTION="Linux kernel built upon CachyOS and Gentoo patchsets, aiming to provide improved performance and responsiveness for desktop workloads."
HOMEPAGE="https://github.com/CachyOS/linux-cachyos"
SRC_URI="
	${KERNEL_URI} ${GENPATCHES_URI}
	${CACHYOS_GIT_URI}/all/0001-cachyos-base-all.patch -> 0001-cachyos-base-all-${CACHYOS_COMMIT}.patch
	${CACHYOS_GIT_URI}/misc/0001-bcachefs.patch -> 0001-bcachefs-${CACHYOS_COMMIT}.patch
	${CACHYOS_GIT_URI}/misc/0001-bore-tuning-sysctl.patch -> 0001-bore-tuning-sysctl-${CACHYOS_COMMIT}.patch
	${CACHYOS_GIT_URI}/misc/0001-high-hz.patch -> 0001-high-hz-${CACHYOS_COMMIT}.patch
	${CACHYOS_GIT_URI}/misc/0001-lrng.patch -> 0001-lrng-${CACHYOS_COMMIT}.patch
	${CACHYOS_GIT_URI}/sched/0001-bore-cachy.patch -> 0001-bore-cachy-${CACHYOS_COMMIT}.patch
	${CACHYOS_GIT_URI}/sched/0001-EEVDF-cachy.patch -> 0001-EEVDF-cachy-${CACHYOS_COMMIT}.patch
	${CACHYOS_GIT_URI}/sched/0001-bore-eevdf.patch -> 0001-bore-eevdf-${CACHYOS_COMMIT}.patch
"

LICENSE="GPL"
SLOT="stable"
KEYWORDS="amd64"
IUSE="bcachefs bore +bore-eevdf cfs eevdf experimental high-hz lrng"
REQUIRED_USE="
	^^ ( bore bore-eevdf cfs eevdf )
	bcachefs? ( experimental )
	lrng? ( experimental )
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
		${DISTDIR}/0001-EEVDF-cachy-${CACHYOS_COMMIT}.patch
      	${DISTDIR}/0001-bore-eevdf-${CACHYOS_COMMIT}.patch
	)

	use eevdf && PATCHES+=( ${DISTDIR}/0001-EEVDF-${CACHYOS_COMMIT}.patch )
	use high-hz && PATCHES+=( ${DISTDIR}/0001-high-hz-${CACHYOS_COMMIT}.patch )
	use bcachefs && PATCHES+=( ${DISTDIR}/0001-bcachefs-${CACHYOS_COMMIT}.patch )
	use lrng && PATCHES+=( ${DISTDIR}/0001-lrng-${CACHYOS_COMMIT}.patch )
}

src_prepare() {
	default
	eapply_user
}
