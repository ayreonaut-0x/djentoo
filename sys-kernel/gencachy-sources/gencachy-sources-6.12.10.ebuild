# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
EXTRAVERSION="-gencachy"
ETYPE="sources"
K_SECURITY_UNSUPPORTED="1"
K_EXP_GENPATCHES_NOUSE="1"
K_WANT_GENPATCHES="base extras"
K_GENPATCHES_VER="13"

inherit kernel-2
detect_version

CACHYOS_COMMIT="f5bbf91fc68f0afb0e5a9d9ccfa15dc9d8015f75"
CACHYOS_GIT_URI="https://raw.githubusercontent.com/cachyos/kernel-patches/${CACHYOS_COMMIT}/${KV_MAJOR}.${KV_MINOR}"

DESCRIPTION="Linux kernel built upon CachyOS and Gentoo patchsets, aiming to provide improved performance and responsiveness for desktop workloads."
HOMEPAGE="https://github.com/CachyOS/linux-cachyos"
SRC_URI="
	${KERNEL_URI} ${GENPATCHES_URI}
	${CACHYOS_GIT_URI}/all/0001-cachyos-base-all.patch -> 0001-cachyos-base-all-${KV_MAJOR}.${KV_MINOR}-${CACHYOS_COMMIT}.patch
	${CACHYOS_GIT_URI}/sched/0001-bore-cachy.patch -> 0001-bore-cachy-${KV_MAJOR}.${KV_MINOR}-${CACHYOS_COMMIT}.patch
	${CACHYOS_GIT_URI}/sched/0001-prjc-cachy.patch -> 0001-prjc-cachy-${KV_MAJOR}.${KV_MINOR}-${CACHYOS_COMMIT}.patch
	${CACHYOS_GIT_URI}/misc/dkms-clang.patch -> dkms-clang-${KV_MAJOR}.${KV_MINOR}-${CACHYOS_COMMIT}.patch
	${CACHYOS_GIT_URI}/misc/0001-clang-polly.patch -> 0001-clang-polly-${KV_MAJOR}.${KV_MINOR}-${CACHYOS_COMMIT}.patch
	${CACHYOS_GIT_URI}/misc/0001-preempt-lazy.patch -> 0001-preempt-lazy-${KV_MAJOR}.${KV_MINOR}-${CACHYOS_COMMIT}.patch
"

LICENSE="GPL"
SLOT="${KV_MAJOR}.${KV_MINOR}"
KEYWORDS="~amd64"
IUSE="+bore clang-extra prjc"
RESTRICT="mirror"
REQUIRED_USE="|| ( bore prjc )"

DEPEND="virtual/linux-sources"
RDEPEND=""
BDEPEND=""

src_prepare() {
	default

	eapply "${DISTDIR}/0001-cachyos-base-all-${KV_MAJOR}.${KV_MINOR}-${CACHYOS_COMMIT}.patch"
	use clang-extra && eapply "${DISTDIR}/dkms-clang-${KV_MAJOR}.${KV_MINOR}-${CACHYOS_COMMIT}.patch"
	use bore && eapply "${DISTDIR}/0001-bore-cachy-${KV_MAJOR}.${KV_MINOR}-${CACHYOS_COMMIT}.patch"
	use prjc && eapply "${DISTDIR}/0001-prjc-cachy-${KV_MAJOR}.${KV_MINOR}-${CACHYOS_COMMIT}.patch"
	use clang-extra && eapply "${DISTDIR}/0001-clang-polly-${KV_MAJOR}.${KV_MINOR}-${CACHYOS_COMMIT}.patch"
	eapply "${DISTDIR}/0001-preempt-lazy-${KV_MAJOR}.${KV_MINOR}-${CACHYOS_COMMIT}.patch"

	eapply_user
	rm "${S}/tools/testing/selftests/tc-testing/action-ebpf"
}
