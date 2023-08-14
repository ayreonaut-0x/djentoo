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

CACHYOS_COMMIT="f3cdc0bfd3df3644ec6c207e9509a894d1a50a45"
CACHYOS_GIT_URI="https://raw.githubusercontent.com/cachyos/kernel-patches/${CACHYOS_COMMIT}/${KV_MAJOR}.${KV_MINOR}"

DESCRIPTION="Linux kernel built upon CachyOS and Gentoo patchset's, aiming to provide improved performance and responsiveness for desktop workloads."
HOMEPAGE="https://github.com/CachyOS/linux-cachyos"
SRC_URI="
	${KERNEL_URI} ${GENPATCHES_URI}
	${CACHYOS_GIT_URI}/all/0001-cachyos-base-all.patch -> 0001-cachyos-base-all-${CACHYOS_COMMIT}.patch
	${CACHYOS_GIT_URI}/misc/0001-bore-tuning-sysctl.patch -> 0001-bore-tuning-sysctl-${CACHYOS_COMMIT}.patch
	${CACHYOS_GIT_URI}/misc/0001-high-hz.patch -> 0001-high-hz-${CACHYOS_COMMIT}.patch
	${CACHYOS_GIT_URI}/sched/0001-bore-cachy.patch -> 0001-bore-cachy-${CACHYOS_COMMIT}.patch
	${CACHYOS_GIT_URI}/sched/0001-EEVDF.patch -> 0001-EEVDF-${CACHYOS_COMMIT}.patch
	${CACHYOS_GIT_URI}/sched/0001-bore-eevdf.patch -> 0001-bore-eevdf-${CACHYOS_COMMIT}.patch
	${CACHYOS_GIT_URI}/sched/0001-tt-cachy.patch -> 0001-tt-cachy-${CACHYOS_COMMIT}.patch
	${CACHYOS_GIT_URI}/sched/0001-prjc-cachy.patch -> 0001-prjc-cachy-${CACHYOS_COMMIT}.patch
	experimental? (
		${CACHYOS_GIT_URI}/sched-dev/0001-bore-eevdf.patch -> 0001-bore-eevdf-dev-${CACHYOS_COMMIT}.patch
		${CACHYOS_GIT_URI}/queue-for-6.4.11/amd-pstate-patches/0001-cpufreq-Fail-driver-register-if-it-has-adjust_perf-w.patch -> 0001-cpufreq-Fail-driver-register-if-it-has-adjust_perf-w-${CACHYOS_COMMIT}.patch
		${CACHYOS_GIT_URI}/queue-for-6.4.11/amd-pstate-patches/0002-cpufreq-amd-pstate-Write-CPPC-enable-bit-per-socket.patch -> 0002-cpufreq-amd-pstate-Write-CPPC-enable-bit-per-socket-${CACHYOS_COMMIT}.patch
		${CACHYOS_GIT_URI}/queue-for-6.4.11/amd-pstate-patches/0003-ACPI-CPPC-Add-definition-for-undefined-FADT-preferre.patch -> 0003-ACPI-CPPC-Add-definition-for-undefined-FADT-preferre-${CACHYOS_COMMIT}.patch
		${CACHYOS_GIT_URI}/queue-for-6.4.11/amd-pstate-patches/0004-cpufreq-amd-pstate-Set-a-fallback-policy-based-on-pr.patch -> 0004-cpufreq-amd-pstate-Set-a-fallback-policy-based-on-pr-${CACHYOS_COMMIT}.patch
		${CACHYOS_GIT_URI}/queue-for-6.4.11/amd-pstate-patches/0005-cpufreq-amd-pstate-Add-a-kernel-config-option-to-set.patch -> 0005-cpufreq-amd-pstate-Add-a-kernel-config-option-to-set-${CACHYOS_COMMIT}.patch
		${CACHYOS_GIT_URI}/queue-for-6.4.11/amd-pstate-patches/0006-ACPI-CPPC-Add-get-the-highest-performance-cppc-contr.patch -> 0006-ACPI-CPPC-Add-get-the-highest-performance-cppc-contr-${CACHYOS_COMMIT}.patch
		${CACHYOS_GIT_URI}/queue-for-6.4.11/amd-pstate-patches/0007-cpufreq-amd-pstate-Enable-AMD-Pstate-Preferred-Core-.patch -> 0007-cpufreq-amd-pstate-Enable-AMD-Pstate-Preferred-Core-${CACHYOS_COMMIT}.patch
		${CACHYOS_GIT_URI}/queue-for-6.4.11/amd-pstate-patches/0008-cpufreq-Add-a-notification-message-that-the-highest-.patch -> 0008-cpufreq-Add-a-notification-message-that-the-highest-${CACHYOS_COMMIT}.patch
		${CACHYOS_GIT_URI}/queue-for-6.4.11/amd-pstate-patches/0009-cpufreq-amd-pstate-Update-AMD-Pstate-Preferred-Core-.patch -> 0009-cpufreq-amd-pstate-Update-AMD-Pstate-Preferred-Core-${CACHYOS_COMMIT}.patch
		${CACHYOS_GIT_URI}/queue-for-6.4.11/amd-pstate-patches/0010-Documentation-amd-pstate-introduce-AMD-Pstate-Prefer.patch -> 0010-Documentation-amd-pstate-introduce-AMD-Pstate-Prefer-${CACHYOS_COMMIT}.patch
		${CACHYOS_GIT_URI}/queue-for-6.4.11/amd-pstate-patches/0011-Documentation-introduce-AMD-Pstate-Preferrd-Core-mod.patch -> 0011-Documentation-introduce-AMD-Pstate-Preferrd-Core-mod-${CACHYOS_COMMIT}.patch
	)
"

LICENSE="GPL"
SLOT="stable"
KEYWORDS="amd64"
IUSE="bore +bore-eevdf cfs eevdf experimental high-hz prjc tt"
REQUIRED_USE="
	|| ( bore bore-eevdf cfs eevdf prjc tt )
	experimental? ( bore-eevdf )
	tt? ( high-hz )
"

DEPEND="virtual/linux-sources"
RDEPEND="${DEPEND}"
BDEPEND=""

PATCHES=( ${DISTDIR}/0001-cachyos-base-all-${CACHYOS_COMMIT}.patch )

pkg_setup() {
	use bore && PATCHES+=(
		${DISTDIR}/0001-bore-cachy-${CACHYOS_COMMIT}.patch
		${DISTDIR}/0001-bore-tuning-sysctl-${CACHYOS_COMMIT}.patch
	)

	if use bore-eevdf ; then
		PATCHES+=( ${DISTDIR}/0001-EEVDF-${CACHYOS_COMMIT}.patch )
		
		if use experimental ; then
			PATCHES+=(
				${DISTDIR}/0001-bore-eevdf-dev-${CACHYOS_COMMIT}.patch
				# ${DISTDIR}/0001-cpufreq-Fail-driver-register-if-it-has-adjust_perf-w-${CACHYOS_COMMIT}.patch
				# ${DISTDIR}/0002-cpufreq-amd-pstate-Write-CPPC-enable-bit-per-socket-${CACHYOS_COMMIT}.patch
				# ${DISTDIR}/0003-ACPI-CPPC-Add-definition-for-undefined-FADT-preferre-${CACHYOS_COMMIT}.patch
				# ${DISTDIR}/0004-cpufreq-amd-pstate-Set-a-fallback-policy-based-on-pr-${CACHYOS_COMMIT}.patch
				# ${DISTDIR}/0005-cpufreq-amd-pstate-Add-a-kernel-config-option-to-set-${CACHYOS_COMMIT}.patch
				# ${DISTDIR}/0006-ACPI-CPPC-Add-get-the-highest-performance-cppc-contr-${CACHYOS_COMMIT}.patch
				# ${DISTDIR}/0007-cpufreq-amd-pstate-Enable-AMD-Pstate-Preferred-Core-${CACHYOS_COMMIT}.patch
				# ${DISTDIR}/0008-cpufreq-Add-a-notification-message-that-the-highest-${CACHYOS_COMMIT}.patch
				# ${DISTDIR}/0009-cpufreq-amd-pstate-Update-AMD-Pstate-Preferred-Core-${CACHYOS_COMMIT}.patch
				# ${DISTDIR}/0010-Documentation-amd-pstate-introduce-AMD-Pstate-Prefer-${CACHYOS_COMMIT}.patch
				# ${DISTDIR}/0011-Documentation-introduce-AMD-Pstate-Preferrd-Core-mod-${CACHYOS_COMMIT}.patch
			)
		else
			PATCHES+=( ${DISTDIR}/0001-bore-eevdf-${CACHYOS_COMMIT}.patch )
		fi
	fi

	use eevdf && PATCHES+=( ${DISTDIR}/0001-EEVDF-${CACHYOS_COMMIT}.patch )
	use prjc && PATCHES+=( ${DISTDIR}/0001-prjc-cachy-${CACHYOS_COMMIT}.patch )
	use tt && PATCHES+=( ${DISTDIR}/0001-tt-cachy-${CACHYOS_COMMIT}.patch )
	use high-hz && PATCHES+=( ${DISTDIR}/0001-high-hz-${CACHYOS_COMMIT}.patch )
}

src_prepare() {
	default
	eapply_user
}
