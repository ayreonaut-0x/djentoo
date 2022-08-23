# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
ETYPE="sources"
K_WANT_GENPATCHES="base extras"
K_GENPATCHES_VER="5"
K_SECURITY_UNSUPPORTED="1"
K_NOSETEXTRAVERSION="1"

inherit kernel-2 optfeature
detect_version
detect_arch

# major kernel version, e.g. 5.14
SHPV="${KV_MAJOR}.${KV_MINOR}"

COMMUNITY_SHPY="${KV_MAJOR}${KV_MINOR}"

KEYWORDS="~amd64"

IUSE="lrng mglru"
DESCRIPTION="The Linux Kernel with a selection of patches aiming for better desktop/gaming experience and Gentoo's genpatches"
HOMEPAGE="https://github.com/blacksky3/linux-bore"
SLOT="${SHPV}"

TKG_PATCH_URI="https://github.com/Frogging-Family/linux-tkg/raw/master/linux-tkg-patches/${SHPV}"

# BORE_URI="https://github.com/firelzrd/bore-scheduler/raw/main/bore"
PATCH_URI="https://github.com/blacksky3/patches/raw/main"

SRC_URI="${KERNEL_URI} ${GENPATCHES_URI} ${ARCH_URI}
		https://github.com/graysky2/kernel_compiler_patch/raw/master/more-uarches-for-kernel-5.17%2B.patch -> more-uarches-for-kernel-${SHPV}.patch
		${PATCH_URI}/bore/0001-bore1.4.31.0.patch -> 0001-bore-${SHPV}.patch
		${PATCH_URI}/bore/0001-peterz-sched-patches-2-3-8.patch -> 0001-peterz-sched-patches-${SHPV}.patch
		${PATCH_URI}/bore/0001-Disallow-sync-wakeup-from-interrupt-context.patch -> 0001-Disallow-sync-wakeup-from-interrupt-context-${SHPV}.patch
		${PATCH_URI}/${SHPV}/arch/0001-ZEN-Add-sysctl-and-CONFIG-to-disallow-unprivileged-C.patch -> 0001-ZEN-Add-sysctl-and-CONFIG-to-disallow-unprivileged-C-${SHPV}.patch
		${PATCH_URI}/${SHPV}/futex/tkg/0007-v${SHPV}-fsync1_via_futex_waitv-v1.patch -> 0007-v${SHPV}-fsync1_via_futex_waitv-${SHPV}.patch
		${PATCH_URI}/${SHPV}/cpu/xanmod/0013-XANMOD-init-Kconfig-Enable-O3-KBUILD_CFLAGS-optimiza.patch -> 0013-XANMOD-init-Kconfig-Enable-O3-KBUILD_CFLAGS-optimiza-${SHPV}.patch
		${PATCH_URI}/${SHPV}/cpu/xanmod/0014-XANMOD-Makefile-Turn-off-loop-vectorization-for-GCC-.patch -> 0014-XANMOD-Makefile-Turn-off-loop-vectorization-for-GCC-${SHPV}.patch
		${TKG_PATCH_URI}/0001-mm-Support-soft-dirty-flag-reset-for-VA-range.patch -> 0001-mm-Support-soft-dirty-flag-reset-for-VA-range-${PV}.patch
		${TKG_PATCH_URI}/0002-mm-Support-soft-dirty-flag-read-with-reset.patch -> 0002-mm-Support-soft-dirty-flag-read-with-reset-${PV}.patch
		${TKG_PATCH_URI}/0002-clear-patches.patch -> 0002-clear-patches-${PV}.patch
		${TKG_PATCH_URI}/0006-add-acs-overrides_iommu.patch -> 0006-add-acs-overrides_iommu-${PV}.patch
		mglru? ( ${TKG_PATCH_URI}/0010-lru_${SHPV}.patch -> 0010-lru_${SHPV}.patch )
		lrng? ( https://github.com/CachyOS/kernel-patches/raw/master/${SHPV}/0012-lrng.patch -> 0012-${SHPV}-lrng.patch )
"

pkg_setup() {
	kernel-2_pkg_setup
}

src_prepare() {
	# kernel-2_src_prepare doesn't apply PATCHES().
	kernel-2_src_prepare

	eapply "${DISTDIR}/0001-bore-${SHPV}.patch"
	eapply "${DISTDIR}/0001-peterz-sched-patches-${SHPV}.patch"
	eapply "${DISTDIR}/0001-Disallow-sync-wakeup-from-interrupt-context-${SHPV}.patch"
	eapply "${DISTDIR}/0001-ZEN-Add-sysctl-and-CONFIG-to-disallow-unprivileged-C-${SHPV}.patch"
	eapply "${DISTDIR}/0001-mm-Support-soft-dirty-flag-reset-for-VA-range-${PV}.patch"
	eapply "${DISTDIR}/0002-mm-Support-soft-dirty-flag-read-with-reset-${PV}.patch"
	eapply "${DISTDIR}/0002-clear-patches-${PV}.patch"
	eapply "${DISTDIR}/0006-add-acs-overrides_iommu-${PV}.patch"
	eapply "${DISTDIR}/0007-v${SHPV}-fsync1_via_futex_waitv-${SHPV}.patch"

	if use mglru; then
		eapply "${DISTDIR}/0010-lru_${SHPV}.patch"
	fi

	if use lrng; then
		eapply "${DISTDIR}/0012-${SHPV}-lrng.patch"
	fi

	eapply "${DISTDIR}/0013-XANMOD-init-Kconfig-Enable-O3-KBUILD_CFLAGS-optimiza-${SHPV}.patch"
	eapply "${DISTDIR}/0014-XANMOD-Makefile-Turn-off-loop-vectorization-for-GCC-${SHPV}.patch"
	eapply "${DISTDIR}/more-uarches-for-kernel-${SHPV}.patch"

	echo "-bore" > ${S}/localversion
}

src_install() {
	kernel-2_src_install
}

pkg_postinst() {
	elog "MICROCODES"
	elog "Use linux-tkg-sources with microcodes for CPU vulnerability fixes."
	elog "Read https://wiki.gentoo.org/wiki/Intel_microcode"

	kernel-2_pkg_postinst
}

pkg_postrm() {
	kernel-2_pkg_postrm
}
