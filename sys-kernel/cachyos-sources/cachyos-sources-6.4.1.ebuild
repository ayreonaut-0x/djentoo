# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
EXTRAVERSION="-cachyos"
K_SECURITY_UNSUPPORTED="1"
ETYPE="sources"
CACHYOS_COMMIT="39140af45a00e31693021233c2405c4f5305c1de"

inherit kernel-2
detect_version

DESCRIPTION="CachyOS are improved kernels that improve performance and other aspects."
HOMEPAGE="https://github.com/CachyOS/linux-cachyos"
SRC_URI="
${KERNEL_URI}
https://raw.githubusercontent.com/cachyos/kernel-patches/${CACHYOS_COMMIT}/${KV_MAJOR}.${KV_MINOR}/all/0001-cachyos-base-all.patch -> ${PV}-0001-cachyos-base-all.patch
bore? (
   https://raw.githubusercontent.com/cachyos/kernel-patches/${CACHYOS_COMMIT}/${KV_MAJOR}.${KV_MINOR}/sched/0001-bore-cachy.patch -> ${PV}-0001-bore-cachy.patch
   https://raw.githubusercontent.com/cachyos/kernel-patches/${CACHYOS_COMMIT}/${KV_MAJOR}.${KV_MINOR}/misc/0001-bore-tuning-sysctl.patch -> ${PV}-0001-bore-tuning-sysctl.patch
)
eevdf? (
   https://raw.githubusercontent.com/cachyos/kernel-patches/${CACHYOS_COMMIT}/${KV_MAJOR}.${KV_MINOR}/sched/0001-EEVDF.patch -> ${PV}-0001-EEVDF.patch
   https://raw.githubusercontent.com/cachyos/kernel-patches/${CACHYOS_COMMIT}/${KV_MAJOR}.${KV_MINOR}/sched/0001-bore-eevdf.patch -> ${PV}-0001-bore-eevdf.patch
)
high-hz? (
	https://raw.githubusercontent.com/cachyos/kernel-patches/${CACHYOS_COMMIT}/${KV_MAJOR}.${KV_MINOR}/misc/0001-high-hz.patch -> ${PV}-0001-high-hz.patch
)
"

LICENSE="GPL"
SLOT="stable"
KEYWORDS="amd64"
IUSE="+eevdf bore prjc tt high-hz"
REQUIRED_USE="|| ( bore eevdf prjc tt ) tt? ( high-hz )"

DEPEND="virtual/linux-sources"
RDEPEND="${DEPEND}"
BDEPEND=""

src_prepare() {
	eapply "${DISTDIR}/${PV}-0001-cachyos-base-all.patch"

	if use bore; then
		eapply "${DISTDIR}/${PV}-0001-bore-cachy.patch"
		eapply "${DISTDIR}/${PV}-0001-bore-tuning-sysctl.patch"
	fi

	if use eevdf; then
		eapply "${DISTDIR}/${PV}-0001-EEVDF.patch"
      eapply "${DISTDIR}/${PV}-0001-bore-eevdf.patch"
	fi

	if use high-hz; then
		eapply "${DISTDIR}/${PV}-0001-high-hz.patch"
	fi

	#if use tt; then
	#	eapply "${FILESDIR}/${KV_MAJOR}.${KV_MINOR}/${KV_MAJOR}.${KV_MINOR}-tt-cachy.patch"
	#fi

	#if use prjc; then
	#	eapply "${FILESDIR}/${KV_MAJOR}.${KV_MINOR}/${KV_MAJOR}.${KV_MINOR}-prjc-cachy.patch"
	#fi

	eapply_user

	# prepare default config
	if use bore; then
		cp "${FILESDIR}/config-x86_64-bore" .config && elog "BORE config applied" || die
	fi

	if use eevdf; then
		cp "${FILESDIR}/config-x86_64-eevdf" .config && elog "EEVDF config applied" || die
	fi

	#if use prjc; then
	#	cp "${FILESDIR}/config-x86_64-prjc" .config && elog "PRJC config applied" || die
	#fi

	#if use tt; then
	#	cp "${FILESDIR}/config-x86_64-tt" .config && elog "TaskType config applied" || die
	#fi
}

pkg_postinst() {
	elog "Default kernel config depending on selected scheduler has been applied."
	elog "You have to build kernel manually!"
	elog "Initramfs is required for all default configurations (dracut or genkernel)"
}
