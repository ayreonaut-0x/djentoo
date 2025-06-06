# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

PYTHON_COMPAT=( python3_{8,9,10,11,12} )
inherit python-any-r1

DESCRIPTION="A system programming language based on C"
HOMEPAGE="https://c3-lang.org/"
SRC_URI="https://github.com/c3lang/c3c/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
IUSE="+mimalloc test"
KEYWORDS="~amd64"
RESTRICT="!test? ( test )"

DEPEND=">=llvm-core/llvm-15"
RDEPEND="${DEPEND}"
BDEPEND="test? ( ${PYTHON_DEPS} )"

S="${WORKDIR}/c3c-${PV}"

src_prepare() {
	eapply "${FILESDIR}/0000-lib-to-lib64.patch"
	use mimalloc && eapply "${FILESDIR}/0000-reenable-mimalloc.patch"
	cmake_src_prepare
}

src_configure() (
	mycmakeargs=(
		-DCMAKE_BUILD_WITH_INSTALL_RPATH=TRUE
		-DCMAKE_INSTALL_PREFIX=/usr
		-DC3_ENABLE_CLANGD_LSP=TRUE
		-DC3_LINK_DYNAMIC=TRUE
	)
	use mimalloc && mycmakeargs+=( -DC3_USE_MIMALLOC=TRUE )
	cmake_src_configure
)

src_test() (
	C3C=$(realpath --canonicalize-existing --relative-to="${PWD}" "${BUILD_DIR}/c3c")
	python3 test/src/tester.py "${C3C}" test/test_suite || die
)

# src_install() {
# 	into /usr
# 	dobin "${BUILD_DIR}/c3c"
# 	dolib.a "${BUILD_DIR}/libc3c_wrappers.a"
# 	dolib.a "${BUILD_DIR}/libminiz.a"
# }
