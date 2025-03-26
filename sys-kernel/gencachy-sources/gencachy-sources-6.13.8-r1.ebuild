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

CACHYOS_COMMIT="0f5dad7df79e904e8a6d752aa2ed71b6e3b7de75"
CACHYOS_VERSION="${KV_MAJOR}.${KV_MINOR}-${CACHYOS_COMMIT}"
CACHYOS_GIT_URI="https://raw.githubusercontent.com/cachyos/kernel-patches/${CACHYOS_COMMIT}/${KV_MAJOR}.${KV_MINOR}"

DESCRIPTION="Linux kernel built upon CachyOS and Gentoo patchsets, aiming to provide improved performance and responsiveness for desktop workloads."
HOMEPAGE="https://github.com/CachyOS/linux-cachyos"
SRC_URI="
	${KERNEL_URI} ${GENPATCHES_URI}
	${CACHYOS_GIT_URI}/all/0001-cachyos-base-all.patch -> 0001-cachyos-base-all-${CACHYOS_VERSION}.patch
	${CACHYOS_GIT_URI}/sched/0001-bore-cachy.patch -> 0001-bore-cachy-${CACHYOS_VERSION}.patch
	${CACHYOS_GIT_URI}/sched/0001-prjc-cachy.patch -> 0001-prjc-cachy-${CACHYOS_VERSION}.patch
	${CACHYOS_GIT_URI}/misc/dkms-clang.patch -> dkms-clang-${CACHYOS_VERSION}.patch
	${CACHYOS_GIT_URI}/misc/0001-clang-polly.patch -> 0001-clang-polly-${CACHYOS_VERSION}.patch
"

LICENSE="GPL"
SLOT="${KV_MAJOR}.${KV_MINOR}"
KEYWORDS="~amd64"
IUSE="+bore clang-dkms clang-polly prjc"
RESTRICT="mirror"
REQUIRED_USE="|| ( bore prjc )"

DEPEND="virtual/linux-sources"
RDEPEND=""
BDEPEND=""

_GENPATCHNAME="genpatches-${SLOT}-${K_GENPATCHES_VER}"
_GENPATCHES_BASE=(
	"1000_linux-6.13.1.patch"
	"1001_linux-6.13.2.patch"
	"1002_linux-6.13.3.patch"
	"1003_linux-6.13.4.patch"
	"1004_linux-6.13.5.patch"
	"1005_linux-6.13.6.patch"
	"1006_linux-6.13.7.patch"
	"1007_linux-6.13.8.patch"
	"1510_fs-enable-link-security-restrictions-by-default.patch"
	"1700_sparc-address-warray-bound-warnings.patch"
	"1730_parisc-Disable-prctl.patch"
	"2000_BT-Check-key-sizes-only-if-Secure-Simple-Pairing-enabled.patch"
	"2901_permit-menuconfig-sorting.patch"
	"2910_bfp-mark-get-entry-ip-as--maybe-unused.patch"
	"2920_sign-file-patch-for-libressl.patch"
	"2980_kbuild-gcc15-gnu23-to-gnu11-fix.patch"
	"2990_libbpf-v2-workaround-Wmaybe-uninitialized-false-pos.patch"
)
_GENPATCHES_EXTRA=(
	"3000_Support-printing-firmware-info.patch"
	"4567_distro-Gentoo-Kconfig.patch"
)

src_unpack() {
	pushd "${WORKDIR}" || die
	tar xf "${DISTDIR}/linux-${SLOT}.tar.xz"
	mv "linux-${SLOT}" "linux-${SLOT}.${KV_PATCH}${EXTRAVERSION}" || die
	popd

	mkdir "${WORKDIR}/${_GENPATCHNAME}.base" && pushd "${WORKDIR}/${_GENPATCHNAME}.base" || die
	tar xf "${DISTDIR}/${_GENPATCHNAME}.base.tar.xz" || die
	popd

	mkdir "${WORKDIR}/${_GENPATCHNAME}.extras" && pushd "${WORKDIR}/${_GENPATCHNAME}.extras" || die
	tar xf "${DISTDIR}/${_GENPATCHNAME}.extras.tar.xz" || die
	popd

	S="${WORKDIR}/linux-${SLOT}.${KV_PATCH}${EXTRAVERSION}"
	echo "${EXTRAVERSION}" > "${S}/localversion" || die
	rm "${S}/tools/testing/selftests/tc-testing/action-ebpf"
}

src_prepare() {
	for p in ${_GENPATCHES_BASE[@]}; do
		eapply "${WORKDIR}/${_GENPATCHNAME}.base/${p}"
	done

	for p in ${_GENPATCHES_EXTRA[@]}; do
		eapply "${WORKDIR}/${_GENPATCHNAME}.extras/${p}"
	done

	eapply "${DISTDIR}/0001-cachyos-base-all-${CACHYOS_VERSION}.patch"
	use bore && eapply "${DISTDIR}/0001-bore-cachy-${CACHYOS_VERSION}.patch"
	use prjc && eapply "${DISTDIR}/0001-prjc-cachy-${CACHYOS_VERSION}.patch"
	use clang-dkms && eapply "${DISTDIR}/dkms-clang-${CACHYOS_VERSION}.patch"
	use clang-polly && eapply "${DISTDIR}/0001-clang-polly-${CACHYOS_VERSION}.patch"

	eapply_user
}
