
EAPI=8

inherit cmake

DESCRIPTION="RAD tool for wxWidgets GUI design."
HOMEPAGE="https://github.com/${PN}/${PN}"
LICENSE="GPL-2"
SRC_URI="https://github.com/${PN}/${PN}/releases/download/v${PV}/${PN}-${PV}-source-full.tar.gz"
S=${WORKDIR}/${P}

KEYWORDS="~amd64"
IUSE="debug"
SLOT=0

RDEPEND="x11-libs/wxGTK:3.1-gtk3[X]"
DEPEND="${RDEPEND}"
BDEPEND="
	>=dev-util/cmake-3.21
	dev-util/ninja"

CMAKE_BUILD_TYPE="Release"

src_prepare()
{
	cmake_src_prepare
}

src_configure()
{
	use debug && CMAKE_BUILD_TYPE="RelWithDebInfo"
	# sed -i 's/usr\/lib/usr\/lib64/g' ${S}/install/linux/create_src_tarball || die
	cmake_src_configure
}

src_compile()
{
	cmake_src_compile
}

src_install()
{
	cmake_src_install
}
