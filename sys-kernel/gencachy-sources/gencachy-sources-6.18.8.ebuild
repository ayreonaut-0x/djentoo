# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
ETYPE="sources"
EXTRAVERSION="-gencachy"
K_NOSETEXTRAVERSION="1"
K_SECURITY_UNSUPPORTED="1"
K_EXP_GENPATCHES_NOUSE="1"
K_WANT_GENPATCHES="base extras"
K_GENPATCHES_VER="10"

inherit kernel-2
detect_version
detect_arch

CACHYOS_COMMIT="4d397e5fe57a149c3b37dc0926058eb32e31f1ad"
CACHYOS_VERSION="${KV_MAJOR}.${KV_MINOR}-${CACHYOS_COMMIT}"
CACHYOS_GIT_URI="https://raw.githubusercontent.com/cachyos/kernel-patches/${CACHYOS_COMMIT}/${KV_MAJOR}.${KV_MINOR}"

DESCRIPTION="Linux kernel built upon CachyOS and Gentoo patchsets, aiming to provide improved performance and responsiveness for desktop workloads."
HOMEPAGE="https://github.com/CachyOS/linux-cachyos"
SRC_URI="
	${KERNEL_URI} ${GENPATCHES_URI}
	${CACHYOS_GIT_URI}/all/0001-cachyos-base-all.patch -> 0001-cachyos-base-all-${CACHYOS_VERSION}.patch
	${CACHYOS_GIT_URI}/sched/0001-bore-cachy.patch -> 0001-bore-cachy-${CACHYOS_VERSION}.patch
	${CACHYOS_GIT_URI}/sched/0001-prjc-cachy.patch -> 0001-prjc-cachy-${CACHYOS_VERSION}.patch
	${CACHYOS_GIT_URI}/misc/0001-aufs-${KV_MAJOR}.${KV_MINOR}-merge-v20251208.patch -> 0001-aufs-${CACHYOS_VERSION}.patch
	${CACHYOS_GIT_URI}/misc/0001-clang-polly.patch -> 0001-clang-polly-${CACHYOS_VERSION}.patch
	${CACHYOS_GIT_URI}/misc/dkms-clang.patch -> dkms-clang-${CACHYOS_VERSION}.patch
	${CACHYOS_GIT_URI}/misc/poc-selector.patch -> poc-selector-${CACHYOS_VERSION}.patch
"

LICENSE="GPL"
SLOT="${KV_MAJOR}.${KV_MINOR}"
KEYWORDS="~amd64"
IUSE="aufs +bore clang-dkms clang-polly prjc"
RESTRICT="mirror"
REQUIRED_USE="|| ( bore prjc )"

DEPEND="virtual/linux-sources"
RDEPEND=""
BDEPEND=""

src_unpack() {
	cd "${WORKDIR}" || die

	tar xf "${DISTDIR}/linux-${SLOT}.tar.xz" || die
	mv "linux-${SLOT}" "linux-${SLOT}.${KV_PATCH}${EXTRAVERSION}" || die

	local genpatch_archives=( base extras )
	for gpa in ${genpatch_archives[@]};	do
		tar xf "${DISTDIR}/genpatches-${SLOT}-${K_GENPATCHES_VER}.${gpa}.tar.xz" || die
	done

	S="${WORKDIR}/linux-${SLOT}.${KV_PATCH}${EXTRAVERSION}"
	echo "${EXTRAVERSION}" > "${S}/localversion" || die
	rm "${S}/tools/testing/selftests/tc-testing/action-ebpf"
}

src_prepare() {
	local _patchlist=(
		"${WORKDIR}/1000_linux-6.18.1.patch"
		"${WORKDIR}/1001_linux-6.18.2.patch"
		"${WORKDIR}/1002_linux-6.18.3.patch"
		"${WORKDIR}/1003_linux-6.18.4.patch"
		"${WORKDIR}/1004_linux-6.18.5.patch"
		"${WORKDIR}/1005_linux-6.18.6.patch"
		"${WORKDIR}/1006_linux-6.18.7.patch"
		"${WORKDIR}/1007_linux-6.18.8.patch"
		"${WORKDIR}/1510_fs-enable-link-security-restrictions-by-default.patch"
		"${WORKDIR}/1700_sparc-address-warray-bound-warnings.patch"
		"${WORKDIR}/1730_parisc-Disable-prctl.patch"
		"${WORKDIR}/1910_ceph_fix_kernel_crash_in_ceph_open.patch"
		"${WORKDIR}/2000_BT-Check-key-sizes-only-if-Secure-Simple-Pairing-enabled.patch"
		"${WORKDIR}/2901_permit-menuconfig-sorting.patch"
		"${WORKDIR}/2920_sign-file-patch-for-libressl.patch"
		"${WORKDIR}/2990_libbpf-v2-workaround-Wmaybe-uninitialized-false-pos.patch"
		"${WORKDIR}/2991_libbpf_add_WERROR_option.patch"
		"${WORKDIR}/3000_Support-printing-firmware-info.patch"
		"${WORKDIR}/4567_distro-Gentoo-Kconfig.patch"
		"${DISTDIR}/0001-cachyos-base-all-${CACHYOS_VERSION}.patch"
	)

	use bore && _patchlist+=( "${DISTDIR}/0001-bore-cachy-${CACHYOS_VERSION}.patch" )
	use prjc && _patchlist+=( "${DISTDIR}/0001-prjc-cachy-${CACHYOS_VERSION}.patch" )
	use aufs && _patchlist+=( "${DISTDIR}/0001-aufs-${CACHYOS_VERSION}.patch" )
	use clang-polly && _patchlist+=( "${DISTDIR}/0001-clang-polly-${CACHYOS_VERSION}.patch" )
	use clang-dkms && _patchlist+=( "${DISTDIR}/dkms-clang-${CACHYOS_VERSION}.patch" )
	_patchlist+=( "${DISTDIR}/poc-selector-${CACHYOS_VERSION}.patch" )

	for p in ${_patchlist[@]}; do eapply "${p}"; done

	eapply_user
}
