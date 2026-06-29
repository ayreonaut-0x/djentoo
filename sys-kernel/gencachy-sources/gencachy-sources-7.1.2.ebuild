# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
ETYPE="sources"
EXTRAVERSION="-gencachy"
K_NOSETEXTRAVERSION="1"
K_SECURITY_UNSUPPORTED="1"
K_EXP_GENPATCHES_NOUSE="1"
K_WANT_GENPATCHES="base extras"
K_GENPATCHES_VER="3"

inherit kernel-2
detect_version
detect_arch

CACHYOS_RELEASE="${OKV}-2"
CACHYOS_COMMIT="19250dcc39862169961756c733b8a6ba77754c22"
CACHYOS_VERSION="${KV_MAJOR}.${KV_MINOR}-${CACHYOS_COMMIT}"
CACHYOS_SRC_URI="https://github.com/CachyOS/linux/releases/download/cachyos-${CACHYOS_RELEASE}/cachyos-${CACHYOS_RELEASE}.tar.gz"
CACHYOS_PATCH_URI="https://raw.githubusercontent.com/cachyos/kernel-patches/${CACHYOS_COMMIT}/${KV_MAJOR}.${KV_MINOR}"

DESCRIPTION="Linux kernel built upon CachyOS and Gentoo patchsets, aiming to provide improved performance and responsiveness for desktop workloads."
HOMEPAGE="https://github.com/CachyOS/linux-cachyos"

SRC_URI="
	${CACHYOS_SRC_URI} ${GENPATCHES_URI}
	${CACHYOS_PATCH_URI}/sched/0001-bore-cachy.patch -> 0001-bore-cachy-${CACHYOS_VERSION}.patch
	${CACHYOS_PATCH_URI}/sched/0001-prjc-cachy.patch -> 0001-prjc-cachy-${CACHYOS_VERSION}.patch
	${CACHYOS_PATCH_URI}/misc/0001-aufs-${KV_MAJOR}.${KV_MINOR}-merge-v20260621.patch -> 0001-aufs-${CACHYOS_VERSION}.patch
	${CACHYOS_PATCH_URI}/misc/0001-clang-polly.patch -> 0001-clang-polly-${CACHYOS_VERSION}.patch
	${CACHYOS_PATCH_URI}/misc/dkms-clang.patch -> dkms-clang-${CACHYOS_VERSION}.patch
"

LICENSE="GPL"
SLOT="stable"
KEYWORDS="~amd64"
IUSE="misc aufs +bore clang-dkms clang-polly prjc"
RESTRICT="mirror"
REQUIRED_USE="
	|| ( bore prjc )
	aufs? ( misc )
	clang-dkms? ( misc )
	clang-polly? ( misc )
"

DEPEND="virtual/linux-sources"
RDEPEND=""
BDEPEND=""

src_unpack() {
	cd "${WORKDIR}" || die

	tar xf "${DISTDIR}/cachyos-${CACHYOS_RELEASE}.tar.gz" || die
	mv "cachyos-${CACHYOS_RELEASE}" "linux-${OKV}${EXTRAVERSION}" || die

	local genpatch_archives=( base extras )
	for gpa in "${genpatch_archives[@]}"; do
		tar xf "${DISTDIR}/genpatches-${KV_MAJOR}.${KV_MINOR}-${K_GENPATCHES_VER}.${gpa}.tar.xz" || die
	done

	S="${WORKDIR}/linux-${OKV}${EXTRAVERSION}"
	echo "${EXTRAVERSION}" > "${S}/localversion" || die
	rm "${S}/tools/testing/selftests/tc-testing/action-ebpf"
}

src_prepare() {
	local plist=()

	use bore        && plist+=("${DISTDIR}/0001-bore-cachy-${CACHYOS_VERSION}.patch")
	use prjc        && plist+=("${DISTDIR}/0001-prjc-cachy-${CACHYOS_VERSION}.patch")
	use aufs        && plist+=("${DISTDIR}/0001-aufs-${CACHYOS_VERSION}.patch")
	use clang-polly && plist+=("${DISTDIR}/0001-clang-polly-${CACHYOS_VERSION}.patch")

	plist+=(
		"${WORKDIR}/1510_fs-enable-link-security-restrictions-by-default.patch"
		"${WORKDIR}/1605_crypto-nx-fix-nx-crypto-ctx-exit-arg.patch"
		"${WORKDIR}/1700_sparc-address-warray-bound-warnings.patch"
		"${WORKDIR}/1710_x86-tools-vdso2c.patch"
		"${WORKDIR}/1730_parisc-Disable-prctl.patch"
		"${WORKDIR}/2000_BT-Check-key-sizes-only-if-Secure-Simple-Pairing-enabled.patch"
		"${WORKDIR}/2901_permit-menuconfig-sorting.patch"
		"${WORKDIR}/2902_Replace-CONST-CAST-with-const-cast.patch"
		"${WORKDIR}/2990_libbpf-v2-workaround-Wmaybe-uninitialized-false-pos.patch"
		"${WORKDIR}/2991_libbpf_add_WERROR_option.patch"
		"${WORKDIR}/3000_Support-printing-firmware-info.patch"
		"${WORKDIR}/4567_distro-Gentoo-Kconfig.patch"
	)

	use clang-dkms && plist+=("${DISTDIR}/dkms-clang-${CACHYOS_VERSION}.patch")

	for p in "${plist[@]}"; do
		eapply "${p}"
	done

	eapply_user
}
