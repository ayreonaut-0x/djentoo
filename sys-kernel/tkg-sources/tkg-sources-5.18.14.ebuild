# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
ETYPE="sources"
K_WANT_GENPATCHES="base extras"
K_GENPATCHES_VER="18"
K_SECURITY_UNSUPPORTED="1"
K_NOSETEXTRAVERSION="1"
PRJC_R=2

inherit kernel-2 optfeature
detect_version
detect_arch

# major kernel version, e.g. 5.14
SHPV="${KV_MAJOR}.${KV_MINOR}"

COMMUNITY_SHPY="${KV_MAJOR}${KV_MINOR}"

KEYWORDS="~amd64"

IUSE="bcachefs bmq cfs experimental lrng mglru pds tt"
DESCRIPTION="The Linux Kernel with a selection of patches aiming for better desktop/gaming experience and Gentoo's genpatches"
HOMEPAGE="https://github.com/Frogging-Family/linux-tkg"
SLOT="${SHPV}"
REQUIRED_USE="
	^^ ( bmq pds tt cfs )
	bcachefs? ( experimental )
	lrng? ( experimental )
	mglru? ( experimental )
	tt? ( experimental )
"

TKG_PATCH_URI="${HOMEPAGE}/raw/master/linux-tkg-patches/${SHPV}"

SRC_URI="${GENPATCHES_URI} ${KERNEL_URI} ${ARCH_URI}
		https://github.com/graysky2/kernel_compiler_patch/raw/master/more-uarches-for-kernel-5.17%2B.patch -> more-uarches-for-kernel-${SHPV}%2B-${PV}.patch
		https://github.com/sirlucjan/kernel-patches/raw/master/${SHPV}/bbr2-patches/0001-bbr2-${SHPV}-introduce-BBRv2.patch
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
		lrng? ( https://github.com/ptr1337/kernel-patches/raw/master/${SHPV}/0006-lrng.patch -> 0006-${SHPV}-lrng.patch )
		mglru? ( ${TKG_PATCH_URI}/0010-lru_${SHPV}.patch -> 0010-lru_${SHPV}.patch )
		pds? ( ${TKG_PATCH_URI}/0005-glitched-pds.patch -> 0005-glitched-pds-${PV}.patch )
		tt? ( https://github.com/ptr1337/kernel-patches/raw/master/${SHPV}/sched/0001-tt-${SHPV}.patch )
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

	eapply "${DISTDIR}/0001-add-sysctl-to-disallow-unprivileged-CLONE_NEWUSER-by-${PV}.patch"
	eapply "${DISTDIR}/0001-bbr2-${SHPV}-introduce-BBRv2.patch"
	eapply "${DISTDIR}/more-uarches-for-kernel-${SHPV}%2B-${PV}.patch"
	eapply "${DISTDIR}/0002-clear-patches-${PV}.patch"
	eapply "${DISTDIR}/0003-glitched-base-${PV}.patch"
	eapply "${DISTDIR}/0001-mm-Support-soft-dirty-flag-reset-for-VA-range-${PV}.patch"
	eapply "${DISTDIR}/0002-mm-Support-soft-dirty-flag-read-with-reset-${PV}.patch"
	eapply "${DISTDIR}/0006-add-acs-overrides_iommu-${PV}.patch"
	eapply "${DISTDIR}/0007-v${SHPV}-fsync1_via_futex_waitv-${PV}.patch"
	eapply "${DISTDIR}/0007-v${SHPV}-winesync-${PV}.patch"

	use lrng && eapply "${DISTDIR}/0006-${SHPV}-lrng.patch"
	use bcachefs && eapply "${DISTDIR}/0008-${SHPV}-bcachefs-${PV}.patch"

	if use bmq; then
		eapply "${DISTDIR}/0009-prjc_v${SHPV}-r${PRJC_R}-${PV}.patch"
		eapply "${DISTDIR}/0009-glitched-ondemand-bmq-${PV}.patch"
		eapply "${DISTDIR}/0009-glitched-bmq-${PV}.patch"
		version_string+="-bmq"
	elif use pds; then
		eapply "${DISTDIR}/0005-glitched-pds-${PV}.patch"
		version_string+="-pds"
	elif use tt; then
		eapply "${DISTDIR}/0001-tt-${SHPV}.patch"
		version_string+="-tt"
	else
		# eapply "${DISTDIR}/0003-glitched-base-${PV}.patch"
		eapply "${DISTDIR}/0003-glitched-cfs-${PV}.patch"
		eapply "${DISTDIR}/0003-glitched-cfs-additions-${PV}.patch"
	fi

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
