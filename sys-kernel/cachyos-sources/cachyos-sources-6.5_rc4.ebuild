# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"
UNIPATCH_STRICTORDER="yes"
K_NOUSENAME="yes"
#K_NOSETEXTRAVERSION="yes"
K_NOUSEPR="yes"
K_SECURITY_UNSUPPORTED="1"
K_BASE_VER="6.4"
K_EXP_GENPATCHES_NOUSE="1"
K_FROM_GIT="yes"
K_NODRYRUN="yes"
EXTRAVERSION="-cachyos"
ETYPE="sources"
CKV="${PVR/-r/-git}"

# only use this if it's not an _rc/_pre release
[ "${PV/_pre}" == "${PV}" ] && [ "${PV/_rc}" == "${PV}" ] && OKV="${PV}"
inherit kernel-2
detect_version

CACHYOS_COMMIT="0be5e7995a4f38cef8eb503755c5a9038e332097"
CACHYOS_GIT_URI="https://raw.githubusercontent.com/cachyos/kernel-patches/${CACHYOS_COMMIT}/6.5"

DESCRIPTION="Linux kernel built upon CachyOS and Gentoo patchset's, aiming to provide improved performance and responsiveness for desktop workloads."
HOMEPAGE="https://www.kernel.org https://github.com/CachyOS/linux-cachyos"
SRC_URI="
	${KERNEL_URI}
	${CACHYOS_GIT_URI}/all/0001-cachyos-base-all.patch -> ${P}-0001-cachyos-base-all.patch
	${CACHYOS_GIT_URI}/misc/0001-bore-tuning-sysctl.patch -> ${P}-0001-bore-tuning-sysctl.patch
	${CACHYOS_GIT_URI}/sched/0001-bore-cachy.patch -> ${P}-0001-bore-cachy.patch
	${CACHYOS_GIT_URI}/sched/0001-EEVDF-cachy.patch -> ${P}-0001-EEVDF-cachy.patch
	${CACHYOS_GIT_URI}/sched/0001-bore-eevdf.patch -> ${P}-0001-bore-eevdf.patch
	${CACHYOS_GIT_URI}/sched/0001-tt-cachy.patch -> ${P}-0001-tt-cachy.patch
"

SLOT="rc"
KEYWORDS="~amd64"
IUSE="bore +bore-eevdf cfs eevdf tt"
REQUIRED_USE="|| ( bore bore-eevdf cfs eevdf tt )"

K_EXTRAEINFO="This kernel is not supported by Gentoo due to its unstable and
experimental nature. If you have any issues, try a matching vanilla-sources
ebuild -- if the problem is not there, please contact the upstream kernel
developers at https://bugzilla.kernel.org and on the linux-kernel mailing list to
report the problem so it can be fixed in time for the next kernel release."



BDEPEND=""
RDEPEND=""
DEPEND="
	${RDEPEND}
	>=sys-devel/patch-2.7.6-r4

"

PATCHES=( ${DISTDIR}/${P}-0001-cachyos-base-all.patch )

src_prepare() {
	use bore && PATCHES+=(
		${DISTDIR}/${P}-0001-bore-cachy.patch
		${DISTDIR}/${P}-0001-bore-tuning-sysctl.patch
	)

	use bore-eevdf && PATCHES+=(
		${DISTDIR}/${P}-0001-EEVDF-cachy.patch
      	${DISTDIR}/${P}-0001-bore-eevdf.patch
	)

	use eevdf && PATCHES+=( ${DISTDIR}/${P}-0001-EEVDF.patch )
	use tt && PATCHES+=( ${DISTDIR}/${P}-0001-tt-cachy.patch )

	eapply_user
	default
}

# src_prepare() {
# 	eapply "${P}-0001-cachyos-base-all.patch"

# 	use bore && \
# 		eapply "${P}-0001-bore-cachy.patch" && \
# 		eapply "${P}-0001-bore-tuning-sysctl.patch"

# 	use bore-eevdf && \
# 		eapply "${P}-0001-EEVDF.patch" && \
# 		eapply "${P}-0001-bore-eevdf.patch"

# 	use eevdf && eapply "${P}-0001-EEVDF.patch"
# 	use tt && eapply "${P}-0001-tt-cachy.patch"

# 	eapply_user
# 	default
# }

pkg_postinst() {
	postinst_sources
}
