# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"
ETYPE="sources"
K_WANT_GENPATCHES="base extras"
K_GENPATCHES_VER="12"

inherit kernel-2
detect_version
detect_arch

GENPATCHES_HOMEPAGE="https://dev.gentoo.org/~mpagano/genpatches"
CACHYOS_HOMEPAGE="https://github.com/CachyOS/linux-cachyos"
CACHYOS_SRC_URI="https://raw.githubusercontent.com/CachyOS/kernel-patches/master/${KV_MAJOR}.${KV_MINOR}"

LICENSE="GPL"
KEYWORDS="~amd64 ~x86"
HOMEPAGE="${GENPATCHES_HOMEPAGE} ${CACHYOS_HOMEPAGE}"
IUSE="+bore prjc tt clang-pgo experimental"
REQUIRED_USE="
	^^ ( bore prjc tt )
	clang-pgo? ( experimental )
"
SLOT="${KV_MAJOR}.${KV_MINOR}"

DESCRIPTION="Linux ${KV_MAJOR}.${KV_MINOR} sources with Gentoo and CachyOS patches."
SRC_URI="
	${KERNEL_URI} ${GENPATCHES_URI} ${ARCH_URI}
	${CACHYOS_SRC_URI}/0001-bbr2.patch -> ${P}-0001-bbr2.patch
	${CACHYOS_SRC_URI}/0002-bfq.patch -> ${P}-0002-bfq.patch
	${CACHYOS_SRC_URI}/0003-bitmap.patch -> ${P}-0003-bitmap.patch
	${CACHYOS_SRC_URI}/0004-cachy.patch -> ${P}-0004-cachy.patch
	${CACHYOS_SRC_URI}/0005-clr.patch -> ${P}-0005-clr.patch
	${CACHYOS_SRC_URI}/0006-fixes.patch -> ${P}-0006-fixes.patch
	${CACHYOS_SRC_URI}/0007-folio.patch -> ${P}-0007-folio.patch
	${CACHYOS_SRC_URI}/0008-fs-patches.patch -> ${P}-0008-fs-patches.patch
	${CACHYOS_SRC_URI}/0009-Implement-AMD-Pstate-EPP-Driver.patch -> ${P}-0009-Implement-AMD-Pstate-EPP-Driver.patch
	${CACHYOS_SRC_URI}/0010-Implement-amd-pstate-guided-autonomous-mode-support.patch -> ${P}-0010-Implement-amd-pstate-guided-autonomous-mode-support.patch
	${CACHYOS_SRC_URI}/0011-kallsyms-modules.patch -> ${P}-0011-kallsyms-modules.patch
	${CACHYOS_SRC_URI}/0012-ksm.patch -> ${P}-0012-ksm.patch
	${CACHYOS_SRC_URI}/0013-maple-lru.patch -> ${P}-0013-maple-lru.patch
	${CACHYOS_SRC_URI}/0014-perf.patch -> ${P}-0014-perf.patch
	${CACHYOS_SRC_URI}/0015-printk.patch -> ${P}-0015-printk.patch
	${CACHYOS_SRC_URI}/0016-rcu.patch -> ${P}-0016-rcu.patch
	${CACHYOS_SRC_URI}/0017-sched.patch -> ${P}-0017-sched.patch
	${CACHYOS_SRC_URI}/0018-zram.patch -> ${P}-0018-zram.patch
	${CACHYOS_SRC_URI}/0019-zstd-Update-to-upstream-v1.5.2.patch -> ${P}-0019-zstd-Update-to-upstream-v1.5.2.patch
	${CACHYOS_SRC_URI}/misc/0001-Add-latency-priority-for-CFS-class.patch -> ${P}-0001-Add-latency-priority-for-CFS-class.patch
	${CACHYOS_SRC_URI}/misc/0001-Clang-PGO.patch -> ${P}-0001-Clang-PGO.patch
	${CACHYOS_SRC_URI}/misc/0001-Introduce-per-VMA-lock.patch -> ${P}-0001-Introduce-per-VMA-lock.patch
	${CACHYOS_SRC_URI}/misc/0001-PCI-Allow-BAR-movement-during-boot-and-hotplug.patch -> ${P}-0001-PCI-Allow-BAR-movement-during-boot-and-hotplug.patch
	${CACHYOS_SRC_URI}/misc/0001-lrng.patch -> ${P}-0001-lrng.patch
	${CACHYOS_SRC_URI}/misc/0001-mm-add-zblock-new-allocator-for-use-via-zpool-API.patch -> ${P}-0001-mm-add-zblock-new-allocator-for-use-via-zpool-API.patch
	${CACHYOS_SRC_URI}/misc/0001-mm-introduce-THP-Shrinker.patch -> ${P}-0001-mm-introduce-THP-Shrinker.patch
	${CACHYOS_SRC_URI}/misc/0001-x86-sched-Avoid-unnecessary-migrations-within-SMT-do.patch -> ${P}-0001-x86-sched-Avoid-unnecessary-migrations-within-SMT-do.patch
	${CACHYOS_SRC_URI}/misc/0002-sched-Introduce-IPC-classes-for-load-balance.patch -> ${P}-0002-sched-Introduce-IPC-classes-for-load-balance.patch
	${CACHYOS_SRC_URI}/misc/enable-resizable-bar-support-nv-driver.patch -> ${P}-enable-resizable-bar-support-nv-driver.patch
	bore? (
		${CACHYOS_SRC_URI}/sched/0001-bore-cachy.patch -> ${P}-0001-bore-cachy.patch
		${CACHYOS_SRC_URI}/misc/0001-bore-tuning-sysctl.patch -> ${P}-0001-bore-tuning-sysctl.patch
	)
	prjc? (
		${CACHYOS_SRC_URI}/sched/0001-prjc-cachy.patch -> ${P}-0001-prjc-cachy.patch
	)
	tt? (
		${CACHYOS_SRC_URI}/sched/0001-tt-cachy.patch -> ${P}-0001-tt-cachy.patch
	)
"

src_unpack() {
	kernel-2_src_unpack
	
	eapply "${DISTDIR}/${P}-0001-bbr2.patch"
#	eapply "${DISTDIR}/${P}-0002-bfq.patch"
	eapply "${DISTDIR}/${P}-0003-bitmap.patch"
	eapply "${DISTDIR}/${P}-0004-cachy.patch"
	eapply "${DISTDIR}/${P}-0005-clr.patch"
	eapply "${DISTDIR}/${P}-0006-fixes.patch"
	eapply "${DISTDIR}/${P}-0007-folio.patch"
	eapply "${DISTDIR}/${P}-0008-fs-patches.patch"
	eapply "${DISTDIR}/${P}-0009-Implement-AMD-Pstate-EPP-Driver.patch"
	eapply "${DISTDIR}/${P}-0010-Implement-amd-pstate-guided-autonomous-mode-support.patch"
	eapply "${DISTDIR}/${P}-0011-kallsyms-modules.patch"
	eapply "${DISTDIR}/${P}-0012-ksm.patch"
	eapply "${DISTDIR}/${P}-0013-maple-lru.patch"
	eapply "${DISTDIR}/${P}-0014-perf.patch"
	eapply "${DISTDIR}/${P}-0015-printk.patch"
	eapply "${DISTDIR}/${P}-0016-rcu.patch"
	eapply "${DISTDIR}/${P}-0017-sched.patch"
	eapply "${DISTDIR}/${P}-0018-zram.patch"
	eapply "${DISTDIR}/${P}-0019-zstd-Update-to-upstream-v1.5.2.patch"
	eapply "${DISTDIR}/${P}-0001-Add-latency-priority-for-CFS-class.patch"

	if use clang-pgo; then
		eapply "${DISTDIR}/${P}-0001-Clang-PGO.patch"
		einfo "Experimental Clang PGO patch applied."
		einfo "For more information consult Documentation/dev-tools/pgo.rst"
	fi
	
	eapply "${DISTDIR}/${P}-0001-Introduce-per-VMA-lock.patch"
	eapply "${DISTDIR}/${P}-0001-PCI-Allow-BAR-movement-during-boot-and-hotplug.patch"
	eapply "${DISTDIR}/${P}-0001-lrng.patch"
	eapply "${DISTDIR}/${P}-0001-mm-add-zblock-new-allocator-for-use-via-zpool-API.patch"
	eapply "${DISTDIR}/${P}-0001-mm-introduce-THP-Shrinker.patch"
#	eapply "${DISTDIR}/${P}-0001-x86-sched-Avoid-unnecessary-migrations-within-SMT-do.patch"
#	eapply "${DISTDIR}/${P}-0002-sched-Introduce-IPC-classes-for-load-balance.patch"
#	eapply "${DISTDIR}/${P}-enable-resizable-bar-support-nv-driver.patch"
	
	
	if use bore; then
		eapply "${DISTDIR}/${P}-0001-bore-cachy.patch"
		eapply "${DISTDIR}/${P}-0001-bore-tuning-sysctl.patch"
	fi
}

pkg_postinst() {
	kernel-2_pkg_postinst
	einfo "For more info on the Gentoo patchset, and how to report problems, see:"
	einfo "${GENPATCHES_HOMEPAGE}"
	einfo "For more info on the Gentoo patchset, and how to report problems, see:"
	einfo "${CACHYOS_HOMEPAGE}"
}

pkg_postrm() {
	kernel-2_pkg_postrm
}
