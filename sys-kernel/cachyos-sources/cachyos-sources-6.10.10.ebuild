# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
EXTRAVERSION="-cachyos"
ETYPE="sources"
K_SECURITY_UNSUPPORTED="1"
K_EXP_GENPATCHES_NOUSE="1"
K_WANT_GENPATCHES="base extras"
K_GENPATCHES_VER="13"

inherit kernel-2
detect_version

CACHYOS_COMMIT="f69feddfbc2deddd69e8f0126be9b61a2a8ad8d2"
CACHYOS_GIT_URI="https://raw.githubusercontent.com/cachyos/kernel-patches/${CACHYOS_COMMIT}/${KV_MAJOR}.${KV_MINOR}"

DESCRIPTION="Linux kernel built upon CachyOS and Gentoo patchsets, aiming to provide improved performance and responsiveness for desktop workloads."
HOMEPAGE="https://github.com/CachyOS/linux-cachyos"
SRC_URI="
	${KERNEL_URI} ${GENPATCHES_URI}
	${CACHYOS_GIT_URI}/all/0001-cachyos-base-all.patch -> 0001-cachyos-base-all-${CACHYOS_COMMIT}.patch
	${CACHYOS_GIT_URI}/sched/0001-bore-cachy.patch -> 0001-bore-cachy-${CACHYOS_COMMIT}.patch
"

LICENSE="GPL"
SLOT="mainline"
KEYWORDS="~amd64"
IUSE=""
RESTRICT="-binchecks mirror"
REQUIRED_USE=""

DEPEND="virtual/linux-sources"
RDEPEND=""
BDEPEND=""

PATCHES=(
	${DISTDIR}/0001-cachyos-base-all-${CACHYOS_COMMIT}.patch
	${DISTDIR}/0001-bore-cachy-${CACHYOS_COMMIT}.patch
)

# src_unpack() {
# 	UNIPATCH_STRICTORDER=1
# 	UNIPATCH_LIST_DEFAULT="${DISTDIR}/0001-cachyos-base-all-${CACHYOS_COMMIT}.patch"
# 	use bore && UNIPATCH_LIST_DEFAULT="${UNIPATCH_LIST_DEFAULT} ${DISTDIR}/0001-bore-cachy-${CACHYOS_COMMIT}.patch"
# 	use echo && UNIPATCH_LIST_DEFAULT="${UNIPATCH_LIST_DEFAULT} ${DISTDIR}/0001-echo-cachy-${CACHYOS_COMMIT}.patch"
# 	kernel-2_src_unpack
# }

src_prepare() {
	default
	eapply_user
}
