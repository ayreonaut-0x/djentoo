# Copyright 2017-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CRATES="
	anyhow-1.0.42
	atk-0.14.0
	atk-sys-0.14.0
	autocfg-1.0.1
	bitflags-1.2.1
	cairo-rs-0.14.1
	cairo-sys-rs-0.14.0
	cfg-expr-0.7.4
	chrono-0.4.19
	either-1.6.1
	field-offset-0.3.4
	futures-channel-0.3.15
	futures-core-0.3.15
	futures-executor-0.3.15
	futures-io-0.3.15
	futures-task-0.3.15
	futures-util-0.3.15
	gdk-0.14.0
	gdk-pixbuf-0.14.0
	gdk-pixbuf-sys-0.14.0
	gdk-sys-0.14.0
	gio-0.14.0
	gio-sys-0.14.0
	glib-0.14.2
	glib-macros-0.14.1
	glib-sys-0.14.0
	gobject-sys-0.14.0
	gtk-0.14.0
	gtk-sys-0.14.0
	gtk3-macros-0.14.0
	heck-0.3.3
	humansize-1.1.1
	itertools-0.10.1
	libc-0.2.98
	memoffset-0.6.4
	num-integer-0.1.44
	num-traits-0.2.14
	once_cell-1.8.0
	open-1.7.1
	pango-0.14.0
	pango-sys-0.14.0
	pathdiff-0.2.0
	pest-2.1.3
	pin-project-lite-0.2.7
	pin-utils-0.1.0
	pkg-config-0.3.19
	proc-macro-crate-1.0.0
	proc-macro-error-1.0.4
	proc-macro-error-attr-1.0.4
	proc-macro2-1.0.27
	quote-1.0.9
	rustc_version-0.3.3
	same-file-1.0.6
	semver-0.11.0
	semver-parser-0.10.2
	serde-1.0.126
	slab-0.4.3
	smallvec-1.6.1
	strum-0.21.0
	strum_macros-0.21.1
	syn-1.0.73
	system-deps-3.1.2
	thiserror-1.0.26
	thiserror-impl-1.0.26
	time-0.1.44
	toml-0.5.8
	ucd-trie-0.1.3
	unicode-segmentation-1.8.0
	unicode-xid-0.2.2
	version-compare-0.0.11
	version_check-0.9.3
	walkdir-2.3.2
	wasi-0.10.0+wasi-snapshot-preview1
	winapi-0.3.9
	winapi-i686-pc-windows-gnu-0.4.0
	winapi-util-0.1.5
	winapi-x86_64-pc-windows-gnu-0.4.0
"

inherit desktop xdg cargo

DESCRIPTION="Simple, powerful and easy to use file renamer"
HOMEPAGE="https://github.com/qarmin/szyszka"
SRC_URI="https://www.github.com/qarmin/szyszka/archive/${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" $(cargo_crate_uris ${CRATES})"
RESTRICT="mirror"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
DEPEND=""
RDEPEND=">=x11-libs/gtk+-3"
QA_FLAGS_IGNORED="usr/bin/szyszka"

src_install() {
	dobin ./target/release/szyszka

	doicon ./data/icons/com.github.qarmin.szyszka.svg

	domenu ./data/com.github.qarmin.szyszka.desktop
}
