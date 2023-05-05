EAPI=8

DESCRIPTION="Generate thumbnails for CBR/CBZ archives."
HOMEPAGE="https://github.com/livanh/comics-thumbnailer"
LICENSE="GPL-3"
SRC_URI="https://github.com/livanh/${PN}/archive/refs/tags/v0.2.tar.gz -> ${PN}-${PV}.tar.gz"
KEYWORDS="~amd64"
IUSE=""
SLOT=0

RDEPEND=""
DEPEND=""
BDEPEND="dev-util/make"

src_prepare() {
   default

   sed -i \
      's/\/local//g' \
      "Makefile" \
      || die
}
