# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
ETYPE="sources"
EXTRAVERSION="-gencachy"
K_NOSETEXTRAVERSION="1"
K_SECURITY_UNSUPPORTED="1"
K_EXP_GENPATCHES_NOUSE="1"
K_WANT_GENPATCHES="base extras"
K_GENPATCHES_VER="5"

inherit kernel-2
detect_version
detect_arch

CACHYOS_RELEASE="${OKV}-1"
CACHYOS_COMMIT="f98908d8b5cacc4c24a6039ffd9f41f6a0de4ba2"
CACHYOS_VERSION="${KV_MAJOR}.${KV_MINOR}-${CACHYOS_COMMIT}"
CACHYOS_SRC_URI="https://github.com/CachyOS/linux/releases/download/cachyos-${CACHYOS_RELEASE}/cachyos-${CACHYOS_RELEASE}.tar.gz"
CACHYOS_PATCH_URI="https://raw.githubusercontent.com/cachyos/kernel-patches/${CACHYOS_COMMIT}/${KV_MAJOR}.${KV_MINOR}"

DESCRIPTION="Linux kernel built upon CachyOS and Gentoo patchsets, aiming to provide improved performance and responsiveness for desktop workloads."
HOMEPAGE="https://github.com/CachyOS/linux-cachyos"

SRC_URI="
	${CACHYOS_SRC_URI} ${GENPATCHES_URI}
	${CACHYOS_PATCH_URI}/sched-dev/0001-bore-cachy.patch -> 0001-bore-cachy-${CACHYOS_VERSION}.patch
	${CACHYOS_PATCH_URI}/sched/0001-prjc-cachy-lfbmq.patch -> 0001-prjc-cachy-lfbmq-${CACHYOS_VERSION}.patch
	${CACHYOS_PATCH_URI}/sched/0001-prjc-cachy.patch -> 0001-prjc-cachy-${CACHYOS_VERSION}.patch
	${CACHYOS_PATCH_URI}/misc/0001-aufs-${KV_MAJOR}.${KV_MINOR}-merge-v20260621.patch -> 0001-aufs-${CACHYOS_VERSION}.patch
	${CACHYOS_PATCH_URI}/misc/0001-clang-polly.patch -> 0001-clang-polly-${CACHYOS_VERSION}.patch
	${CACHYOS_PATCH_URI}/misc/dkms-clang.patch -> dkms-clang-${CACHYOS_VERSION}.patch
"

LICENSE="GPL"
SLOT="stable"
KEYWORDS="~amd64"
IUSE="misc aufs +bore clang-dkms clang-polly prjc lfbmq"
RESTRICT="mirror"
REQUIRED_USE="
	|| ( bore prjc )
	aufs? ( misc )
	clang-dkms? ( misc )
	clang-polly? ( misc )
	lfbmq? ( prjc )
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

	if use prjc; then
	        if use lfbmq; then
				plist+=("${DISTDIR}/0001-prjc-cachy-lfbmq-${CACHYOS_VERSION}.patch")
			else
				plist+=("${DISTDIR}/0001-prjc-cachy-${CACHYOS_VERSION}.patch")
			fi
	fi

	use aufs        && plist+=("${DISTDIR}/0001-aufs-${CACHYOS_VERSION}.patch")
	use clang-polly && plist+=("${DISTDIR}/0001-clang-polly-${CACHYOS_VERSION}.patch")

	plist+=(
		"${WORKDIR}/1510_fs-enable-link-security-restrictions-by-default.patch"
		"${WORKDIR}/1700_sparc-address-warray-bound-warnings.patch"
		"${WORKDIR}/1710_x86-tools-vdso2c.patch"
		"${WORKDIR}/1730_parisc-Disable-prctl.patch"
		"${WORKDIR}/2000_BT-Check-key-sizes-only-if-Secure-Simple-Pairing-enabled.patch"
		"${WORKDIR}/2010_can-bcm-defer-rx_op-deallocation-to-workqueue-to-fix.patch"
		"${WORKDIR}/2200_cpufreq-hotplug-suspend-race-fix.patch"
		"${WORKDIR}/2700_drm-amdgpu-fix-check-in-amdgpu-hmm-invalidate-gfx.patch"
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
