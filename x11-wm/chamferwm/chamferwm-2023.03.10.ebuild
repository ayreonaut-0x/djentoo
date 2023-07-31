# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )

DESCRIPTION="A tiling X11 window manager with Vulkan compositor."
HOMEPAGE="https://github.com/jaelpark/chamferwm"
SRC_URI=""

EGIT_REPO_URI="https://github.com/jaelpark/chamferwm.git"
EGIT_COMMIT="93b8f79e91b63b8ac61df64541167c9dd9bb6fb7"
EMESON_BUILDTYPE="release"

inherit git-r3 meson python-single-r1

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="
	${PYTHON_DEPS}
	$(python_gen_cond_dep '
		dev-libs/boost[${PYTHON_USEDEP}]
	')
	media-libs/shaderc
	>=dev-util/vulkan-headers-1.3
	>=media-libs/vulkan-loader-1.3
	>=x11-libs/libxcb-1.12
	x11-libs/xcb-util
	x11-libs/xcb-util-cursor
	x11-libs/xcb-util-wm
	x11-libs/xcb-util-xrm
	x11-libs/xcb-util-renderutil
	x11-libs/xcb-util-keysyms
	x11-libs/xcb-util-image
"

RDEPEND="${DEPEND}"

BDEPEND="${PYTHON_DEPS}"

pkg_setup() {
	python-single-r1_pkg_setup
}

src_prepare(){
	#local pyver="${EPYTHON:6:}"
	#ewarn "${pyver}"
	sed -i "s/python3')/python-3.11')/g" meson.build
	eapply "${FILESDIR}/0000-fix-desktop-qa-warnings-gentoo.patch"

	default
}

src_install(){
	into /usr
	dobin "${BUILD_DIR}/chamfer"

	insinto /usr/share/chamfer/shaders
	doins "${BUILD_DIR}/default_fragment.spv"
	doins "${BUILD_DIR}/default_geometry.spv"
	doins "${BUILD_DIR}/default_vertex.spv"
	doins "${BUILD_DIR}/frame_fragment_basic.spv"
	doins "${BUILD_DIR}/frame_fragment_ext_basic.spv"
	doins "${BUILD_DIR}/frame_fragment_ext.spv"
	doins "${BUILD_DIR}/frame_fragment.spv"
	doins "${BUILD_DIR}/frame_geometry.spv"
	doins "${BUILD_DIR}/frame_vertex.spv"
	doins "${BUILD_DIR}/solid_fragment.spv"
	doins "${BUILD_DIR}/text_fragment.spv"
	doins "${BUILD_DIR}/text_vertex.spv"

	insinto /usr/share/chamfer/config
	doins "${S}/config/config.py"

	insinto /usr/share/applications/
	doins "${S}/share/chamfer.desktop"
}
