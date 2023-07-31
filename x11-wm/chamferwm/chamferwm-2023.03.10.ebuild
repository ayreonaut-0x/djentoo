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

inherit git-r3 meson python-any-r1 python-utils-r1

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	x11-libs/libxcb
	x11-libs/xcb-util
	x11-libs/xcb-util-cursor
	x11-libs/xcb-util-wm
	x11-libs/xcb-util-xrm
	x11-libs/xcb-util-renderutil
	x11-libs/xcb-util-keysyms
	x11-libs/xcb-util-image
	dev-libs/boost[python]
	>=dev-util/vulkan-headers-1.3
"

RDEPEND="
	dev-libs/boost[python]
	media-libs/shaderc
	>=media-libs/vulkan-loader-1.3
"

BDEPEND="
	${PYTHON_DEPS}
"

src_prepare(){
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
	doins "${BUILD_DIR}/frame_fragment.spv"
	doins "${BUILD_DIR}/frame_geometry.spv"
	doins "${BUILD_DIR}/frame_vertex.spv"

	insinto /usr/share/applications/

	doins "${S}/share/chamfer.desktop"
}
