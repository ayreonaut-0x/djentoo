# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"
ETYPE="sources"
K_WANT_GENPATCHES="base extras"
K_GENPATCHES_VER="13"

inherit kernel-2
detect_version

GENPATCHES_HOMEPAGE="https://dev.gentoo.org/~mpagano/genpatches"
CACHYOS_HOMEPAGE="https://github.com/CachyOS/linux-cachyos"

KEYWORDS="~amd64"
LICENSE="GPL"
DESCRIPTION="Linux ${SLOT} sources with Gentoo and CachyOS patches."
HOMEPAGE="${GENPATCHES_HOMEPAGE} ${CACHYOS_HOMEPAGE}"
SRC_URI="${KERNEL_URI} ${GENPATCHES_URI} ${ARCH_URI}"

MY_KV="${KV_MAJOR}.${KV_MINOR}"
SLOT="${MY_KV}"

IUSE="+clang-pgo +experimental"
REQUIRED_USE="clang-pgo? ( experimental )"

DEPEND="virtual/linux-sources"
RDEPEND="${DEPEND}"
BDEPEND="clang-pgo? ( >=sys-devel/clang-14 )" 


src_unpack() {
	kernel-2_src_unpack

	# Add non-experimental patches to this list in the correct order!
	local patches=(
		"0001-cachyos-base-all.patch"
		"0001-Add-latency-priority-for-CFS-class.patch"
		"0001-bore-cachy.patch"
		"0001-bore-tuning-sysctl.patch"
		"0001-Introduce-per-VMA-lock.patch"
		"0001-PCI-Allow-BAR-movement-during-boot-and-hotplug.patch"
		"0001-lrng.patch"
		"0001-mm-introduce-THP-Shrinker.patch"
	)

	for p in ${patches[*]}; do
		eapply "${FILESDIR}/${MY_KV}/${p}"
	done

	if use clang-pgo; then
		eapply "${FILESDIR}/${MY_KV}/0001-Clang-PGO.patch"
	fi
}

pkg_postinst() {
	kernel-2_pkg_postinst
	einfo "For more info on the Gentoo patchset, and how to report problems, see:"
	einfo "${GENPATCHES_HOMEPAGE}"
	einfo "For more info on the CachyOS patchset, and to report problems, see:"
	einfo "${CACHYOS_HOMEPAGE}"

	if use clang-pgo; then
		ewarn "clang-pgo USE flag is enabled."
		ewarn "This is untested and may result in an unbootable system. Keep a working kernel!"
		einfo "For build instructions refer to Documentation/dev-tools/pgo.rst"
	fi
}

pkg_postrm() {
	kernel-2_pkg_postrm
}
