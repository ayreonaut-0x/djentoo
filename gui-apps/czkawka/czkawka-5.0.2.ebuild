# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	adler-1.0.2
	adler32-1.2.0
	aes-0.6.0
	aes-0.7.5
	aes-soft-0.6.4
	aesni-0.10.0
	aho-corasick-0.7.18
	android_system_properties-0.1.5
	anyhow-1.0.62
	arrayref-0.3.6
	arrayvec-0.7.2
	atty-0.2.14
	audio_checker-0.1.0
	autocfg-1.1.0
	base64-0.13.0
	base64-0.20.0-alpha.1
	base64ct-1.0.1
	bincode-1.3.3
	bit_field-0.10.1
	bitflags-1.3.2
	bk-tree-0.4.0
	blake3-1.3.1
	block-0.1.6
	block-buffer-0.9.0
	block-buffer-0.10.2
	block-modes-0.7.0
	block-padding-0.2.1
	bumpalo-3.11.0
	bytemuck-1.12.1
	byteorder-1.4.3
	bzip2-0.4.3
	bzip2-sys-0.1.11+1.0.8
	cairo-rs-0.15.12
	cairo-sys-rs-0.15.1
	cc-1.0.73
	cfb-0.7.3
	cfg-expr-0.10.3
	cfg-if-1.0.0
	chrono-0.4.22
	cipher-0.2.5
	cipher-0.3.0
	clap-3.2.18
	clap_derive-3.2.18
	clap_lex-0.2.4
	color_quant-1.1.0
	constant_time_eq-0.1.5
	core-foundation-sys-0.8.3
	cpufeatures-0.2.4
	crc32fast-1.3.2
	crossbeam-channel-0.5.6
	crossbeam-deque-0.8.2
	crossbeam-epoch-0.9.10
	crossbeam-utils-0.8.11
	crypto-common-0.1.6
	dashmap-5.3.4
	deflate-0.9.1
	deflate-1.0.0
	digest-0.9.0
	digest-0.10.3
	directories-next-2.0.0
	dirs-sys-next-0.1.2
	doc-comment-0.3.3
	either-1.8.0
	encoding_rs-0.8.31
	enumn-0.1.5
	exr-1.5.0
	fastrand-1.8.0
	fax-0.1.1
	fax_derive-0.1.0
	ffmpeg_cmdline_utils-0.1.2
	field-offset-0.3.4
	find-crate-0.6.3
	flate2-1.0.24
	fluent-0.16.0
	fluent-bundle-0.15.2
	fluent-langneg-0.13.0
	fluent-syntax-0.11.0
	flume-0.10.14
	fnv-1.0.7
	form_urlencoded-1.0.1
	fs_extra-1.2.0
	futures-0.3.24
	futures-channel-0.3.24
	futures-core-0.3.24
	futures-executor-0.3.24
	futures-io-0.3.24
	futures-macro-0.3.24
	futures-sink-0.3.24
	futures-task-0.3.24
	futures-util-0.3.24
	gdk-pixbuf-0.15.11
	gdk-pixbuf-sys-0.15.10
	gdk4-0.4.8
	gdk4-sys-0.4.8
	generic-array-0.14.6
	getrandom-0.2.7
	gif-0.11.4
	gio-0.15.12
	gio-sys-0.15.10
	glib-0.15.12
	glib-macros-0.15.11
	glib-sys-0.15.10
	glob-0.3.0
	gobject-sys-0.15.10
	graphene-rs-0.15.1
	graphene-sys-0.15.10
	gsk4-0.4.8
	gsk4-sys-0.4.8
	gtk4-0.4.8
	gtk4-macros-0.4.8
	gtk4-sys-0.4.8
	half-1.8.2
	hamming-0.1.3
	hashbrown-0.12.3
	heck-0.4.0
	hermit-abi-0.1.19
	hmac-0.12.1
	humansize-1.1.1
	i18n-config-0.4.2
	i18n-embed-0.13.4
	i18n-embed-fl-0.6.4
	i18n-embed-impl-0.8.0
	iana-time-zone-0.1.47
	idna-0.2.3
	image-0.24.3
	image_hasher-1.0.0
	imagepipe-0.5.0
	indexmap-1.9.1
	infer-0.9.0
	inflate-0.4.5
	instant-0.1.12
	intl-memoizer-0.5.1
	intl_pluralrules-7.0.1
	itertools-0.10.3
	itoa-1.0.3
	jpeg-decoder-0.1.22
	jpeg-decoder-0.2.6
	js-sys-0.3.59
	lazy_static-1.4.0
	lebe-0.5.2
	libc-0.2.132
	libheif-rs-0.15.0
	libheif-sys-1.12.0
	linked-hash-map-0.5.6
	locale_config-0.3.0
	lock_api-0.4.8
	lofty-0.8.0
	lofty_attr-0.3.0
	log-0.4.17
	malloc_buf-0.0.6
	matches-0.1.9
	md5-0.7.0
	memchr-2.5.0
	memoffset-0.6.5
	mime-0.3.16
	mime_guess-2.0.4
	miniz_oxide-0.5.3
	multicache-0.6.1
	nanorand-0.7.0
	num-complex-0.3.1
	num-integer-0.1.45
	num-rational-0.4.1
	num-traits-0.2.15
	num_cpus-1.13.1
	num_threads-0.1.6
	objc-0.2.7
	objc-foundation-0.1.1
	objc_id-0.1.1
	ogg_pager-0.3.2
	once_cell-1.13.1
	opaque-debug-0.3.0
	open-3.0.2
	ordermap-0.4.2
	os_str_bytes-6.3.0
	pango-0.15.10
	pango-sys-0.15.10
	parking_lot-0.12.1
	parking_lot_core-0.9.3
	password-hash-0.3.2
	paste-1.0.8
	pathdiff-0.2.1
	pbkdf2-0.10.1
	pdf-0.7.2
	pdf_derive-0.1.22
	percent-encoding-2.1.0
	pest-2.3.0
	pin-project-1.0.12
	pin-project-internal-1.0.12
	pin-project-lite-0.2.9
	pin-utils-0.1.0
	pkg-config-0.3.25
	png-0.17.5
	ppv-lite86-0.2.16
	primal-check-0.3.2
	proc-macro-crate-1.2.1
	proc-macro-error-1.0.4
	proc-macro-error-attr-1.0.4
	proc-macro2-1.0.43
	quick-xml-0.22.0
	quote-1.0.21
	rand-0.8.5
	rand_chacha-0.3.1
	rand_core-0.6.3
	rawloader-0.37.1
	rayon-1.5.3
	rayon-core-1.9.3
	redox_syscall-0.2.16
	redox_users-0.4.3
	regex-1.6.0
	regex-syntax-0.6.27
	remove_dir_all-0.5.3
	rust-embed-6.4.0
	rust-embed-impl-6.2.0
	rust-embed-utils-7.2.0
	rustc-hash-1.1.0
	rustc_version-0.3.3
	rustc_version-0.4.0
	rustdct-0.5.1
	rustdct-0.6.0
	rustfft-4.1.0
	rustfft-5.1.1
	ryu-1.0.11
	same-file-1.0.6
	scoped_threadpool-0.1.9
	scopeguard-1.1.0
	self_cell-0.10.2
	semver-0.11.0
	semver-1.0.13
	semver-parser-0.10.2
	serde-1.0.144
	serde_derive-1.0.144
	serde_json-1.0.85
	serde_yaml-0.8.26
	sha1-0.10.2
	sha2-0.9.9
	sha2-0.10.3
	slab-0.4.7
	smallvec-1.9.0
	snafu-0.6.10
	snafu-derive-0.6.10
	spin-0.9.4
	strength_reduce-0.2.3
	stringprep-0.1.2
	strsim-0.10.0
	subtle-2.4.1
	symphonia-0.5.1
	symphonia-bundle-flac-0.5.1
	symphonia-bundle-mp3-0.5.1
	symphonia-codec-aac-0.5.1
	symphonia-codec-alac-0.5.1
	symphonia-codec-pcm-0.5.1
	symphonia-codec-vorbis-0.5.1
	symphonia-core-0.5.1
	symphonia-format-isomp4-0.5.1
	symphonia-format-mkv-0.5.1
	symphonia-format-ogg-0.5.1
	symphonia-format-wav-0.5.1
	symphonia-metadata-0.5.1
	symphonia-utils-xiph-0.5.1
	syn-1.0.99
	system-deps-6.0.2
	tempfile-3.3.0
	termcolor-1.1.3
	textwrap-0.15.0
	thiserror-1.0.32
	thiserror-impl-1.0.32
	threadpool-1.8.1
	tiff-0.7.3
	time-0.1.44
	time-0.3.14
	time-macros-0.2.4
	tinystr-0.3.4
	tinyvec-1.6.0
	tinyvec_macros-0.1.0
	toml-0.5.9
	transpose-0.2.1
	trash-2.1.5
	triple_accel-0.3.4
	type-map-0.4.0
	typenum-1.15.0
	ucd-trie-0.1.4
	unic-langid-0.9.0
	unic-langid-impl-0.9.0
	unicase-2.6.0
	unicode-bidi-0.3.8
	unicode-ident-1.0.3
	unicode-normalization-0.1.21
	url-2.2.2
	uuid-1.1.2
	version-compare-0.1.0
	version_check-0.9.4
	vid_dup_finder_lib-0.1.1
	walkdir-2.3.2
	wasi-0.10.0+wasi-snapshot-preview1
	wasi-0.11.0+wasi-snapshot-preview1
	wasm-bindgen-0.2.82
	wasm-bindgen-backend-0.2.82
	wasm-bindgen-macro-0.2.82
	wasm-bindgen-macro-support-0.2.82
	wasm-bindgen-shared-0.2.82
	weezl-0.1.7
	winapi-0.3.9
	winapi-i686-pc-windows-gnu-0.4.0
	winapi-util-0.1.5
	winapi-x86_64-pc-windows-gnu-0.4.0
	windows-0.37.0
	windows-sys-0.36.1
	windows_aarch64_msvc-0.36.1
	windows_aarch64_msvc-0.37.0
	windows_i686_gnu-0.36.1
	windows_i686_gnu-0.37.0
	windows_i686_msvc-0.36.1
	windows_i686_msvc-0.37.0
	windows_x86_64_gnu-0.36.1
	windows_x86_64_gnu-0.37.0
	windows_x86_64_msvc-0.36.1
	windows_x86_64_msvc-0.37.0
	xxhash-rust-0.8.5
	yaml-rust-0.4.5
	zip-0.6.2
"

inherit desktop xdg cargo

DESCRIPTION="App to find duplicates, empty folders and similar images"
HOMEPAGE="https://github.com/qarmin/czkawka"
SRC_URI="
	https://github.com/qarmin/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
	$(cargo_crate_uris)
"

RESTRICT="mirror test"
LICENSE="CC-BY-4.0 MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="X wayland lto"

DEPEND="
	X? ( gui-libs/gtk[X] )
	wayland? ( gui-libs/gtk[wayland] )
"
RDEPEND="${DEPEND}"

# TODO: X: --cfg 'gdk_backend="x11"' & wayland: --cfg 'gdk_backend="wayland"'

src_unpack() {
	cargo_src_unpack

	if use lto; then
		sed -i 's/#lto/lto/' ${S}/Cargo.toml
	fi
}

# src_prepare() {

# 	cargo_src_prepare
# }

src_install() {
	dobin ./target/release/czkawka_cli
	dobin ./target/release/czkawka_gui

	doicon ./data/icons/com.github.qarmin.czkawka.svg
	doicon ./data/icons/com.github.qarmin.czkawka-symbolic.svg

	domenu ./data/com.github.qarmin.czkawka.desktop
}