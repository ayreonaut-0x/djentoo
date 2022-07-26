# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
ETYPE="sources"
K_WANT_GENPATCHES="base extras"
K_GENPATCHES_VER="9"
K_SECURITY_UNSUPPORTED="1"
K_NOSETEXTRAVERSION="1"
PRJC_R=0

inherit kernel-2 optfeature
detect_version
detect_arch

# major kernel version, e.g. 5.14
SHPV="${KV_MAJOR}.${KV_MINOR}"

COMMUNITY_SHPY="${KV_MAJOR}${KV_MINOR}"

KEYWORDS="~amd64"

IUSE="lrng mglru"
DESCRIPTION="The Linux Kernel with a selection of patches aiming for better desktop/gaming experience and Gentoo's genpatches"
HOMEPAGE="https://github.com/Frogging-Family/linux-tkg"
SLOT="${SHPV}"
REQUIRED_USE=""

TKG_PATCH_URI="${HOMEPAGE}/raw/master/linux-tkg-patches/${SHPV}"

SRC_URI="${KERNEL_URI} ${GENPATCHES_URI} ${ARCH_URI}
		https://github.com/graysky2/kernel_compiler_patch/raw/master/more-uarches-for-kernel-5.17%2B.patch -> more-uarches-for-kernel-${SHPV}%2B-${PV}.patch
		${TKG_PATCH_URI}/0001-add-sysctl-to-disallow-unprivileged-CLONE_NEWUSER-by.patch -> 0001-add-sysctl-to-disallow-unprivileged-CLONE_NEWUSER-by-${PV}.patch
		${TKG_PATCH_URI}/0001-mm-Support-soft-dirty-flag-reset-for-VA-range.patch -> 0001-mm-Support-soft-dirty-flag-reset-for-VA-range-${PV}.patch
		${TKG_PATCH_URI}/0002-clear-patches.patch -> 0002-clear-patches-${PV}.patch
		${TKG_PATCH_URI}/0002-mm-Support-soft-dirty-flag-read-with-reset.patch -> 0002-mm-Support-soft-dirty-flag-read-with-reset-${PV}.patch
		${TKG_PATCH_URI}/0003-glitched-base.patch -> 0003-glitched-base-${PV}.patch
		${TKG_PATCH_URI}/0006-add-acs-overrides_iommu.patch -> 0006-add-acs-overrides_iommu-${PV}.patch
		${TKG_PATCH_URI}/0007-v${SHPV}-fsync1_via_futex_waitv.patch -> 0007-v${SHPV}-fsync1_via_futex_waitv-${PV}.patch
		${TKG_PATCH_URI}/0007-v${SHPV}-winesync.patch -> 0007-v${SHPV}-winesync-${PV}.patch
		${TKG_PATCH_URI}/0003-glitched-cfs.patch -> 0003-glitched-cfs-${PV}.patch
		${TKG_PATCH_URI}/0003-glitched-cfs-additions.patch -> 0003-glitched-cfs-additions-${PV}.patch
		lrng? ( https://github.com/CachyOS/kernel-patches/raw/master/${SHPV}/0012-lrng.patch -> 0012-${SHPV}-lrng.patch )
		mglru? ( ${TKG_PATCH_URI}/0010-lru_${SHPV}.patch -> 0010-lru_${SHPV}.patch )
"

src_prepare() {
	# kernel-2_src_prepare doesn't apply PATCHES().
	kernel-2_src_prepare

	eapply "${DISTDIR}/0001-add-sysctl-to-disallow-unprivileged-CLONE_NEWUSER-by-${PV}.patch"
	eapply "${DISTDIR}/more-uarches-for-kernel-${SHPV}%2B-${PV}.patch"
	eapply "${DISTDIR}/0002-clear-patches-${PV}.patch"
	eapply "${DISTDIR}/0003-glitched-base-${PV}.patch"
	eapply "${DISTDIR}/0001-mm-Support-soft-dirty-flag-reset-for-VA-range-${PV}.patch"
	eapply "${DISTDIR}/0002-mm-Support-soft-dirty-flag-read-with-reset-${PV}.patch"
	eapply "${DISTDIR}/0003-glitched-cfs-${PV}.patch"
	eapply "${DISTDIR}/0003-glitched-cfs-additions-${PV}.patch"
	eapply "${DISTDIR}/0006-add-acs-overrides_iommu-${PV}.patch"
	eapply "${DISTDIR}/0007-v${SHPV}-fsync1_via_futex_waitv-${PV}.patch"
	eapply "${DISTDIR}/0007-v${SHPV}-winesync-${PV}.patch"

	if use mglru; then
		eapply "${DISTDIR}/0010-lru_${SHPV}.patch"
	fi

	if use lrng; then
		eapply "${DISTDIR}/0012-${SHPV}-lrng.patch"
	fi

	echo "-tkg" > ${S}/localversion
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
