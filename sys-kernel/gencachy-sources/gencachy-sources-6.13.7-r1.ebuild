# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
EXTRAVERSION="-gencachy"
ETYPE="sources"
K_SECURITY_UNSUPPORTED="1"

inherit kernel-2
detect_version

CACHYOS_COMMIT="f86f23d2b7b200b3a486e6819a7ea895cc82e8f6"
CACHYOS_GIT_URI="https://raw.githubusercontent.com/cachyos/kernel-patches/${CACHYOS_COMMIT}/${KV_MAJOR}.${KV_MINOR}"

DESCRIPTION="Linux kernel built upon CachyOS and Gentoo patchsets, aiming to provide improved performance and responsiveness for desktop workloads."
HOMEPAGE="https://github.com/CachyOS/linux-cachyos"
SRC_URI="
	${KERNEL_URI}
	${CACHYOS_GIT_URI}/all/0001-cachyos-base-all.patch -> 0001-cachyos-base-all-${KV_MAJOR}.${KV_MINOR}-${CACHYOS_COMMIT}.patch
	${CACHYOS_GIT_URI}/sched/0001-bore-cachy.patch -> 0001-bore-cachy-${KV_MAJOR}.${KV_MINOR}-${CACHYOS_COMMIT}.patch
	${CACHYOS_GIT_URI}/sched/0001-prjc-cachy.patch -> 0001-prjc-cachy-${KV_MAJOR}.${KV_MINOR}-${CACHYOS_COMMIT}.patch
	${CACHYOS_GIT_URI}/misc/dkms-clang.patch -> dkms-clang-${KV_MAJOR}.${KV_MINOR}-${CACHYOS_COMMIT}.patch
	${CACHYOS_GIT_URI}/misc/0001-clang-polly.patch -> 0001-clang-polly-${KV_MAJOR}.${KV_MINOR}-${CACHYOS_COMMIT}.patch
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

UNIPATCH_STRICT_ORDER=1
UNIPATCH_LIST=" \
	${FILESDIR}/${PV}/1000_linux-6.13.1.patch \
	${FILESDIR}/${PV}/1001_linux-6.13.2.patch \
	${FILESDIR}/${PV}/1002_linux-6.13.3.patch \
	${FILESDIR}/${PV}/1003_linux-6.13.4.patch \
	${FILESDIR}/${PV}/1004_linux-6.13.5.patch \
	${FILESDIR}/${PV}/1005_linux-6.13.6.patch \
	${FILESDIR}/${PV}/1006_linux-6.13.7.patch \
	${FILESDIR}/${PV}/1510_fs-enable-link-security-restrictions-by-default.patch \
	${FILESDIR}/${PV}/1700_sparc-address-warray-bound-warnings.patch \
	${FILESDIR}/${PV}/1730_parisc-Disable-prctl.patch \
	${FILESDIR}/${PV}/1751_KVM-SVM-Manually-zero-restore-DEBUGCTL.patch \
	${FILESDIR}/${PV}/2000_BT-Check-key-sizes-only-if-Secure-Simple-Pairing-enabled.patch \
	${FILESDIR}/${PV}/2901_permit-menuconfig-sorting.patch \
	${FILESDIR}/${PV}/2910_bfp-mark-get-entry-ip-as--maybe-unused.patch \
	${FILESDIR}/${PV}/2920_sign-file-patch-for-libressl.patch \
	${FILESDIR}/${PV}/2980_kbuild-gcc15-gnu23-to-gnu11-fix.patch \
	${FILESDIR}/${PV}/2990_libbpf-v2-workaround-Wmaybe-uninitialized-false-pos.patch \
	${FILESDIR}/${PV}/3000_Support-printing-firmware-info.patch \
	${FILESDIR}/${PV}/4567_distro-Gentoo-Kconfig.patch \
	${DISTDIR}/0001-cachyos-base-all-${KV_MAJOR}.${KV_MINOR}-${CACHYOS_COMMIT}.patch
"

src_unpack() {
	pushd "${WORKDIR}" || die
	tar xf "${DISTDIR}/linux-${SLOT}.tar.xz"
	mv "linux-${SLOT}" "linux-${SLOT}${EXTRAVERSION}" || die
	popd
	S="${WORKDIR}/linux-${SLOT}${EXTRAVERSION}"
}

src_prepare() {
	eapply "${FILESDIR}/${PV}/1000_linux-6.13.1.patch"
	eapply "${FILESDIR}/${PV}/1001_linux-6.13.2.patch"
	eapply "${FILESDIR}/${PV}/1002_linux-6.13.3.patch"
	eapply "${FILESDIR}/${PV}/1003_linux-6.13.4.patch"
	eapply "${FILESDIR}/${PV}/1004_linux-6.13.5.patch"
	eapply "${FILESDIR}/${PV}/1005_linux-6.13.6.patch"
	eapply "${FILESDIR}/${PV}/1006_linux-6.13.7.patch"
	eapply "${FILESDIR}/${PV}/1510_fs-enable-link-security-restrictions-by-default.patch"
	eapply "${FILESDIR}/${PV}/1700_sparc-address-warray-bound-warnings.patch"
	eapply "${FILESDIR}/${PV}/1730_parisc-Disable-prctl.patch"
	eapply "${FILESDIR}/${PV}/1751_KVM-SVM-Manually-zero-restore-DEBUGCTL.patch"
	eapply "${FILESDIR}/${PV}/2000_BT-Check-key-sizes-only-if-Secure-Simple-Pairing-enabled.patch"
	eapply "${FILESDIR}/${PV}/2901_permit-menuconfig-sorting.patch"
	eapply "${FILESDIR}/${PV}/2910_bfp-mark-get-entry-ip-as--maybe-unused.patch"
	eapply "${FILESDIR}/${PV}/2920_sign-file-patch-for-libressl.patch"
	eapply "${FILESDIR}/${PV}/2980_kbuild-gcc15-gnu23-to-gnu11-fix.patch"
	eapply "${FILESDIR}/${PV}/2990_libbpf-v2-workaround-Wmaybe-uninitialized-false-pos.patch"
	eapply "${FILESDIR}/${PV}/3000_Support-printing-firmware-info.patch"
	eapply "${FILESDIR}/${PV}/4567_distro-Gentoo-Kconfig.patch"

	eapply "${DISTDIR}/0001-cachyos-base-all-${KV_MAJOR}.${KV_MINOR}-${CACHYOS_COMMIT}.patch"
	use bore && eapply "${DISTDIR}/0001-bore-cachy-${KV_MAJOR}.${KV_MINOR}-${CACHYOS_COMMIT}.patch"
	use prjc && eapply "${DISTDIR}/0001-prjc-cachy-${KV_MAJOR}.${KV_MINOR}-${CACHYOS_COMMIT}.patch"
	use clang-dkms && eapply "${DISTDIR}/dkms-clang-${KV_MAJOR}.${KV_MINOR}-${CACHYOS_COMMIT}.patch"
	use clang-polly && eapply "${DISTDIR}/0001-clang-polly-${KV_MAJOR}.${KV_MINOR}-${CACHYOS_COMMIT}.patch"

	eapply_user
	rm "${S}/tools/testing/selftests/tc-testing/action-ebpf"
}
