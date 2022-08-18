EAPI=8

inherit git-r3 cmake

EGIT_MIN_CLONE_TYPE="single"
EGIT_REPO_URI="https://github.com/docopt/docopt.cpp.git"
EGIT_BRANCH="master"

if ! [[ ${PV} == *9999 ]]; then
    EGIT_COMMIT="400e6dd8e59196c914dcc2c56caf7dae7efa5eb3"
    KEYWORDS="~amd64"
fi

IUSE="boost examples"
DESCRIPTION="C++ port of the Python command-line argument parser."
HOMEPAGE="https://github.com/docopt/docopt.cpp"
SLOT=0
SRC_URI=""

src_configure() {
    CMAKE_BUILD_TYPE=Release
    local mycmakeargs=(
        -DWITH_TESTS=OFF
        -DWITH_EXAMPLE=$(usex examples)
        -DUSE_BOOST_REGEX=$(usex boost)
    )

    cmake_src_configure
}
