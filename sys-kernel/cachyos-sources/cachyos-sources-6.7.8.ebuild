# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
EXTRAVERSION="-cachyos"
ETYPE="sources"
K_SECURITY_UNSUPPORTED="1"
K_EXP_GENPATCHES_NOUSE="1"
K_WANT_GENPATCHES="base extras"
K_GENPATCHES_VER="12"

inherit kernel-2
detect_version

CACHYOS_COMMIT="dcc305b239ed92e39a9cdcf5b5ce3fb2345b8329"
CACHYOS_GIT_URI="https://raw.githubusercontent.com/cachyos/kernel-patches/${CACHYOS_COMMIT}/${KV_MAJOR}.${KV_MINOR}"

DESCRIPTION="Linux kernel built upon CachyOS and Gentoo patchsets, aiming to provide improved performance and responsiveness for desktop workloads."
HOMEPAGE="https://github.com/CachyOS/linux-cachyos"
SRC_URI="
	${KERNEL_URI} ${GENPATCHES_URI}
	${CACHYOS_GIT_URI}/all/0001-cachyos-base-all.patch -> 0001-cachyos-base-all-${CACHYOS_COMMIT}.patch
	${CACHYOS_GIT_URI}/sched/0001-bore-cachy.patch -> 0001-bore-cachy-${CACHYOS_COMMIT}.patch
	${CACHYOS_GIT_URI}/misc/0001-amd-hdr.patch -> 0001-amd-hdr-${CACHYOS_COMMIT}.patch
	${CACHYOS_GIT_URI}/misc/0001-lrng.patch -> 0001-lrng-${CACHYOS_COMMIT}.patch
	${CACHYOS_GIT_URI}/misc/0001-mm-Mitigate-a-vmap-lock-contention-v3.patch -> 0001-mm-Mitigate-a-vmap-lock-contention-v3-${CACHYOS_COMMIT}.patch
	${CACHYOS_GIT_URI}/misc/0001-ntsync.patch -> 0001-ntsync-${CACHYOS_COMMIT}.patch
"

LICENSE="GPL"
SLOT="stable"
KEYWORDS="amd64"
IUSE=""
REQUIRED_USE=""

DEPEND="virtual/linux-sources"
RDEPEND="
	${DEPEND}
	sys-fs/bcachefs-tools
"
BDEPEND=""

PATCHES=(
	${DISTDIR}/0001-cachyos-base-all-${CACHYOS_COMMIT}.patch
	${DISTDIR}/0001-bore-cachy-${CACHYOS_COMMIT}.patch
	${DISTDIR}/0001-amd-hdr-${CACHYOS_COMMIT}.patch
	${DISTDIR}/0001-lrng-${CACHYOS_COMMIT}.patch
	${DISTDIR}/0001-mm-Mitigate-a-vmap-lock-contention-v3-${CACHYOS_COMMIT}.patch
	${DISTDIR}/0001-ntsync-${CACHYOS_COMMIT}.patch
)

src_prepare() {
	default
	eapply_user
}
