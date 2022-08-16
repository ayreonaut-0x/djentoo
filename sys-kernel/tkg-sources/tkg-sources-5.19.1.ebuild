# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
ETYPE="sources"
K_WANT_GENPATCHES="base extras"
K_GENPATCHES_VER="2"
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

IUSE="bcachefs bmq +cfs experimental lrng mglru pds tt"
DESCRIPTION="The Linux Kernel with a selection of patches aiming for better desktop/gaming experience and Gentoo's genpatches"
HOMEPAGE="https://github.com/Frogging-Family/linux-tkg"
SLOT="${SHPV}"
REQUIRED_USE="
	^^ ( bmq pds tt cfs )
	bcachefs? ( experimental )
	bmq? ( experimental )
	lrng? ( experimental )
	mglru? ( experimental )
	pds? ( experimental )
	tt? ( experimental )
"

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
		bcachefs? ( ${TKG_PATCH_URI}/0008-${SHPV}-bcachefs.patch -> 0008-${SHPV}-bcachefs-${PV}.patch )
		bmq? ( ${TKG_PATCH_URI}/0009-glitched-bmq.patch -> 0009-glitched-bmq-${PV}.patch )
		bmq? ( ${TKG_PATCH_URI}/0009-glitched-ondemand-bmq.patch -> 0009-glitched-ondemand-bmq-${PV}.patch )
		bmq? ( ${TKG_PATCH_URI}/0009-prjc_v${SHPV}-r${PRJC_R}.patch -> 0009-prjc_v${SHPV}-r${PRJC_R}-${PV}.patch )
		cfs? ( ${TKG_PATCH_URI}/0003-glitched-cfs.patch -> 0003-glitched-cfs-${PV}.patch )
		cfs? ( ${TKG_PATCH_URI}/0003-glitched-cfs-additions.patch -> 0003-glitched-cfs-additions-${PV}.patch )
		lrng? ( https://github.com/CachyOS/kernel-patches/raw/master/${SHPV}/0012-lrng.patch -> 0012-${SHPV}-lrng.patch )
		mglru? ( ${TKG_PATCH_URI}/0010-lru_${SHPV}.patch -> 0010-lru_${SHPV}.patch )
		pds? ( ${TKG_PATCH_URI}/0005-glitched-pds.patch -> 0005-glitched-pds-${PV}.patch )
		tt? ( https://github.com/CachyOS/kernel-patches/raw/master/${SHPV}/sched/0001-tt.patch -> 0001-tt-${SHPV}.patch )
"

pkg_setup() {
	kernel-2_pkg_setup

	if use experimental; then
		ewarn "Experimental USE flags enabled."
		ewarn "No support is provided for experimental USE flags."
	fi
}

src_prepare() {
	# kernel-2_src_prepare doesn't apply PATCHES().
	kernel-2_src_prepare

	local version_string="-tkg"

	eapply -s "${DISTDIR}/more-uarches-for-kernel-${SHPV}%2B-${PV}.patch"
	eapply -s "${DISTDIR}/0001-add-sysctl-to-disallow-unprivileged-CLONE_NEWUSER-by-${PV}.patch"
	eapply -s "${DISTDIR}/0002-clear-patches-${PV}.patch"
	eapply -s "${DISTDIR}/0003-glitched-base-${PV}.patch"

	eapply -s "${DISTDIR}/0001-mm-Support-soft-dirty-flag-reset-for-VA-range-${PV}.patch"
	eapply -s "${DISTDIR}/0002-mm-Support-soft-dirty-flag-read-with-reset-${PV}.patch"

	if use tt; then
		eapply -s "${DISTDIR}/0001-tt-${SHPV}.patch"
		version_string+="-tt"
	fi

	if use cfs; then
		eapply -s "${DISTDIR}/0003-glitched-cfs-${PV}.patch"
		eapply -s "${DISTDIR}/0003-glitched-cfs-additions-${PV}.patch"
	fi

	if use pds; then
		eapply -s "${DISTDIR}/0005-glitched-pds-${PV}.patch"
		version_string+="-pds"
	fi

	if use bmq; then
		eapply -s "${DISTDIR}/0009-prjc_v${SHPV}-r${PRJC_R}-${PV}.patch"
		eapply -s "${DISTDIR}/0009-glitched-ondemand-bmq-${PV}.patch"
		eapply -s "${DISTDIR}/0009-glitched-bmq-${PV}.patch"
		version_string+="-bmq"
	fi

	eapply -s "${DISTDIR}/0006-add-acs-overrides_iommu-${PV}.patch"

	if use bcachefs; then
		eapply -s "${DISTDIR}/0008-${SHPV}-bcachefs-${PV}.patch"
	fi

	if use mglru; then
		eapply -s "${DISTDIR}/0010-lru_${SHPV}.patch"
	fi

	if use lrng; then
		eapply -s "${DISTDIR}/0012-${SHPV}-lrng.patch"
	fi

	eapply -s "${DISTDIR}/0007-v${SHPV}-fsync1_via_futex_waitv-${PV}.patch"
	eapply -s "${DISTDIR}/0007-v${SHPV}-winesync-${PV}.patch"

	echo "${version_string}" > ${S}/localversion
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
