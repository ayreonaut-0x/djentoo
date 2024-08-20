# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
EXTRAVERSION="-cachyos"
ETYPE="sources"
K_SECURITY_UNSUPPORTED="1"
K_EXP_GENPATCHES_NOUSE="1"
K_WANT_GENPATCHES="base extras"
K_GENPATCHES_VER="7"

inherit kernel-2
detect_version

CACHYOS_COMMIT="9c4712879224cbd52880e1d66283e13ffdf152bc"
CACHYOS_GIT_URI="https://raw.githubusercontent.com/cachyos/kernel-patches/${CACHYOS_COMMIT}/${KV_MAJOR}.${KV_MINOR}"

DESCRIPTION="Linux kernel built upon CachyOS and Gentoo patchsets, aiming to provide improved performance and responsiveness for desktop workloads."
HOMEPAGE="https://github.com/CachyOS/linux-cachyos"
SRC_URI="
	${KERNEL_URI} ${GENPATCHES_URI}
	${CACHYOS_GIT_URI}/all/0001-cachyos-base-all.patch -> 0001-cachyos-base-all-${CACHYOS_COMMIT}.patch
	${CACHYOS_GIT_URI}/sched/0001-bore-cachy.patch -> 0001-bore-cachy-${CACHYOS_COMMIT}.patch
	${CACHYOS_GIT_URI}/sched/0001-echo-cachy.patch -> 0001-echo-cachy-${CACHYOS_COMMIT}.patch
"

LICENSE="GPL"
SLOT="mainline"
KEYWORDS="~amd64"
IUSE="+bore echo"
RESTRICT="-binchecks mirror"
REQUIRED_USE="^^ ( bore echo )"

DEPEND="virtual/linux-sources"
RDEPEND="
	${DEPEND}
	sys-fs/bcachefs-tools
"
BDEPEND=""

PATCHES=(
	${DISTDIR}/0001-cachyos-base-all-${CACHYOS_COMMIT}.patch
)

src_prepare() {
	use bore && PATCHES+=( ${DISTDIR}/0001-bore-cachy-${CACHYOS_COMMIT}.patch )
	use echo && PATCHES+=( ${DISTDIR}/0001-echo-cachy-${CACHYOS_COMMIT}.patch )
	default
	eapply_user
}
