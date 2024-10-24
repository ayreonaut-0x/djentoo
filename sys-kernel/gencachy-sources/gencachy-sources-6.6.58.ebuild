# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
EXTRAVERSION="-gencachy"
ETYPE="sources"
K_SECURITY_UNSUPPORTED="1"
K_EXP_GENPATCHES_NOUSE="1"
K_WANT_GENPATCHES="base extras"
K_GENPATCHES_VER="64"

inherit kernel-2
detect_version

CACHYOS_COMMIT="8a99e4759fb78b541dce29df2b52e04e29225495"
CACHYOS_GIT_URI="https://raw.githubusercontent.com/cachyos/kernel-patches/${CACHYOS_COMMIT}/${KV_MAJOR}.${KV_MINOR}"

DESCRIPTION="Linux kernel built upon CachyOS and Gentoo patchsets, aiming to provide improved performance and responsiveness for desktop workloads."
HOMEPAGE="https://github.com/CachyOS/linux-cachyos"
SRC_URI="
	${KERNEL_URI} ${GENPATCHES_URI}
	${CACHYOS_GIT_URI}/all/0001-cachyos-base-all.patch -> 0001-cachyos-base-all-${KV_MAJOR}.${KV_MINOR}-${CACHYOS_COMMIT}.patch
	${CACHYOS_GIT_URI}/sched/0001-bore-cachy.patch -> 0001-bore-cachy-${KV_MAJOR}.${KV_MINOR}-${CACHYOS_COMMIT}.patch
	${CACHYOS_GIT_URI}/misc/0001-lrng.patch -> 0001-lrng-${KV_MAJOR}.${KV_MINOR}-${CACHYOS_COMMIT}.patch
"

LICENSE="GPL"
SLOT="lts"
KEYWORDS="amd64"
IUSE=""
RESTRICT="-binchecks mirror"
REQUIRED_USE=""

DEPEND="virtual/linux-sources"
RDEPEND="${DEPEND}"
BDEPEND=""

src_prepare() {
	default

	eapply "${DISTDIR}/0001-cachyos-base-all-${KV_MAJOR}.${KV_MINOR}-${CACHYOS_COMMIT}.patch"
	eapply "${DISTDIR}/0001-bore-cachy-${KV_MAJOR}.${KV_MINOR}-${CACHYOS_COMMIT}.patch"
	eapply "${DISTDIR}/0001-lrng-${KV_MAJOR}.${KV_MINOR}-${CACHYOS_COMMIT}.patch"

	eapply_user
}