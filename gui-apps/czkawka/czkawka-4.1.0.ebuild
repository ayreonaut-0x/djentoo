# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	adler-1.0.2
	adler32-1.2.0
	aes-0.7.5
	aho-corasick-0.7.18
	alsa-0.6.0
	alsa-sys-0.3.1
	ansi_term-0.12.1
	anyhow-1.0.57
	arrayref-0.3.6
	arrayvec-0.5.2
	arrayvec-0.7.2
	atk-0.15.1
	atk-sys-0.15.1
	atty-0.2.14
	autocfg-1.1.0
	base64-0.13.0
	base64-0.20.0-alpha.1
	base64ct-1.0.1
	bincode-1.3.3
	bindgen-0.59.2
	bit_field-0.10.1
	bitflags-1.3.2
	bk-tree-0.4.0
	blake3-0.3.8
	blake3-1.3.1
	block-0.1.6
	block-buffer-0.9.0
	block-buffer-0.10.2
	bumpalo-3.9.1
	bytemuck-1.9.1
	byteorder-1.4.3
	bytes-1.1.0
	bzip2-0.4.3
	bzip2-sys-0.1.11+1.0.8
	cairo-rs-0.15.10
	cairo-sys-rs-0.15.1
	cc-1.0.73
	cesu8-1.1.0
	cexpr-0.6.0
	cfb-0.6.1
	cfg-expr-0.10.2
	cfg-if-0.1.10
	cfg-if-1.0.0
	chrono-0.4.19
	cipher-0.3.0
	clang-sys-1.3.1
	clap-2.34.0
	claxon-0.4.3
	color_quant-1.1.0
	combine-4.6.3
	constant_time_eq-0.1.5
	core-foundation-sys-0.8.3
	coreaudio-rs-0.10.0
	coreaudio-sys-0.2.10
	cpal-0.13.5
	cpufeatures-0.2.2
	crc32fast-1.3.2
	crossbeam-channel-0.5.4
	crossbeam-deque-0.8.1
	crossbeam-epoch-0.9.8
	crossbeam-utils-0.8.8
	crypto-common-0.1.3
	crypto-mac-0.8.0
	darling-0.13.4
	darling_core-0.13.4
	darling_macro-0.13.4
	dashmap-5.2.0
	deflate-0.8.6
	deflate-1.0.0
	digest-0.9.0
	digest-0.10.3
	directories-next-2.0.0
	dirs-sys-next-0.1.2
	either-1.6.1
	enumn-0.1.3
	exr-1.4.2
	fastrand-1.7.0
	ffmpeg_cmdline_utils-0.1.1
	field-offset-0.3.4
	find-crate-0.6.3
	flate2-1.0.23
	fluent-0.16.0
	fluent-bundle-0.15.2
	fluent-langneg-0.13.0
	fluent-syntax-0.11.0
	flume-0.10.12
	fnv-1.0.7
	fs_extra-1.2.0
	futures-0.3.21
	futures-channel-0.3.21
	futures-core-0.3.21
	futures-executor-0.3.21
	futures-io-0.3.21
	futures-macro-0.3.21
	futures-sink-0.3.21
	futures-task-0.3.21
	futures-util-0.3.21
	gdk-0.15.4
	gdk-pixbuf-0.15.10
	gdk-pixbuf-sys-0.15.10
	gdk-sys-0.15.1
	generic-array-0.14.5
	getrandom-0.2.6
	gif-0.11.3
	gio-0.15.10
	gio-sys-0.15.10
	glib-0.15.10
	glib-macros-0.15.10
	glib-sys-0.15.10
	glob-0.3.0
	gobject-sys-0.15.10
	gtk-0.15.4
	gtk-sys-0.15.3
	gtk3-macros-0.15.4
	half-1.8.2
	hamming-0.1.3
	hashbrown-0.11.2
	heck-0.3.3
	heck-0.4.0
	hermit-abi-0.1.19
	hmac-0.12.1
	hound-3.4.0
	humansize-1.1.1
	i18n-config-0.4.2
	i18n-embed-0.13.4
	i18n-embed-fl-0.6.4
	i18n-embed-impl-0.8.0
	ident_case-1.0.1
	image-0.23.14
	image-0.24.1
	image_hasher-1.0.0
	imagepipe-0.4.0
	indexmap-1.8.1
	infer-0.7.0
	inflate-0.4.5
	instant-0.1.12
	intl-memoizer-0.5.1
	intl_pluralrules-7.0.1
	itoa-1.0.1
	jni-0.19.0
	jni-sys-0.3.0
	jobserver-0.1.24
	jpeg-decoder-0.1.22
	jpeg-decoder-0.2.4
	js-sys-0.3.57
	lazy_static-1.4.0
	lazycell-1.3.0
	lebe-0.5.1
	lewton-0.10.2
	libc-0.2.124
	libloading-0.7.3
	linked-hash-map-0.5.4
	locale_config-0.3.0
	lock_api-0.4.7
	lofty-0.6.1
	log-0.4.16
	mach-0.3.2
	malloc_buf-0.0.6
	memchr-2.4.1
	memoffset-0.6.5
	mime-0.3.16
	mime_guess-2.0.4
	minimal-lexical-0.2.1
	minimp3-0.5.1
	minimp3-sys-0.3.2
	miniz_oxide-0.3.7
	miniz_oxide-0.4.4
	miniz_oxide-0.5.1
	multicache-0.6.1
	nanorand-0.7.0
	ndk-0.6.0
	ndk-context-0.1.1
	ndk-glue-0.6.2
	ndk-macro-0.3.0
	ndk-sys-0.3.0
	nix-0.23.1
	nom-7.1.1
	num-complex-0.3.1
	num-derive-0.3.3
	num-integer-0.1.44
	num-iter-0.1.42
	num-rational-0.3.2
	num-rational-0.4.0
	num-traits-0.2.14
	num_cpus-1.13.1
	num_enum-0.5.7
	num_enum_derive-0.5.7
	num_threads-0.1.5
	objc-0.2.7
	objc-foundation-0.1.1
	objc_id-0.1.1
	oboe-0.4.5
	oboe-sys-0.4.5
	ogg-0.8.0
	ogg_pager-0.3.2
	once_cell-1.10.0
	opaque-debug-0.3.0
	open-2.1.1
	pango-0.15.10
	pango-sys-0.15.10
	parking_lot-0.11.2
	parking_lot-0.12.0
	parking_lot_core-0.8.5
	parking_lot_core-0.9.2
	password-hash-0.3.2
	paste-1.0.7
	pathdiff-0.2.1
	pbkdf2-0.10.1
	peeking_take_while-0.1.2
	pest-2.1.3
	pin-project-1.0.10
	pin-project-internal-1.0.10
	pin-project-lite-0.2.8
	pin-utils-0.1.0
	pkg-config-0.3.25
	png-0.16.8
	png-0.17.5
	ppv-lite86-0.2.16
	primal-check-0.3.1
	proc-macro-crate-1.1.3
	proc-macro-error-1.0.4
	proc-macro-error-attr-1.0.4
	proc-macro2-1.0.37
	quote-1.0.18
	rand-0.8.5
	rand_chacha-0.3.1
	rand_core-0.6.3
	rawloader-0.37.1
	rayon-1.5.2
	rayon-core-1.9.2
	redox_syscall-0.2.13
	redox_users-0.4.3
	regex-1.5.5
	regex-syntax-0.6.25
	remove_dir_all-0.5.3
	rodio-0.15.0
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
	ryu-1.0.9
	same-file-1.0.6
	scoped_threadpool-0.1.9
	scopeguard-1.1.0
	self_cell-0.10.2
	semver-0.11.0
	semver-1.0.7
	semver-parser-0.10.2
	serde-1.0.136
	serde_derive-1.0.136
	serde_json-1.0.79
	serde_yaml-0.8.23
	sha1-0.10.1
	sha2-0.9.9
	sha2-0.10.2
	shlex-1.1.0
	slab-0.4.6
	slice-deque-0.3.0
	smallvec-1.8.0
	spin-0.9.3
	stdweb-0.1.3
	strength_reduce-0.2.3
	strsim-0.8.0
	strsim-0.10.0
	structopt-0.3.26
	structopt-derive-0.4.18
	subtle-2.4.1
	syn-1.0.91
	system-deps-6.0.2
	tempfile-3.3.0
	textwrap-0.11.0
	thiserror-1.0.30
	thiserror-impl-1.0.30
	threadpool-1.8.1
	tiff-0.6.1
	tiff-0.7.2
	time-0.1.44
	time-0.3.9
	time-macros-0.2.4
	tinystr-0.3.4
	tinyvec-1.5.1
	tinyvec_macros-0.1.0
	toml-0.5.9
	transpose-0.2.1
	trash-1.3.0
	triple_accel-0.3.4
	type-map-0.4.0
	typenum-1.15.0
	ucd-trie-0.1.3
	unic-langid-0.9.0
	unic-langid-impl-0.9.0
	unicase-2.6.0
	unicode-segmentation-1.9.0
	unicode-width-0.1.9
	unicode-xid-0.2.2
	uuid-0.8.2
	vec_map-0.8.2
	version-compare-0.1.0
	version_check-0.9.4
	vid_dup_finder_lib-0.1.0
	walkdir-2.3.2
	wasi-0.10.0+wasi-snapshot-preview1
	wasm-bindgen-0.2.80
	wasm-bindgen-backend-0.2.80
	wasm-bindgen-macro-0.2.80
	wasm-bindgen-macro-support-0.2.80
	wasm-bindgen-shared-0.2.80
	web-sys-0.3.57
	weezl-0.1.6
	winapi-0.3.9
	winapi-i686-pc-windows-gnu-0.4.0
	winapi-util-0.1.5
	winapi-x86_64-pc-windows-gnu-0.4.0
	windows-sys-0.34.0
	windows_aarch64_msvc-0.34.0
	windows_i686_gnu-0.34.0
	windows_i686_msvc-0.34.0
	windows_x86_64_gnu-0.34.0
	windows_x86_64_msvc-0.34.0
	xxhash-rust-0.8.5
	yaml-rust-0.4.5
	zip-0.6.2
"


inherit desktop xdg cargo

DESCRIPTION="App to find duplicates, empty folders and similar images"
HOMEPAGE="https://github.com/qarmin/czkawka"
SRC_URI="
	$(cargo_crate_uris)
	https://github.com/qarmin/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
"

RESTRICT="mirror test"
LICENSE="CC-BY-4.0 MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="X wayland"

DEPEND="
	X? ( gui-libs/gtk[X] )
	wayland? ( gui-libs/gtk[wayland] )
"
RDEPEND="${DEPEND}"

# TODO: X: --cfg 'gdk_backend="x11"' & wayland: --cfg 'gdk_backend="wayland"'

src_unpack() {
	cargo_src_unpack
}

src_install() {
	dobin ./target/release/czkawka_cli
	dobin ./target/release/czkawka_gui

	doicon ./data/icons/com.github.qarmin.czkawka.svg
	doicon ./data/icons/com.github.qarmin.czkawka-symbolic.svg

	domenu ./data/com.github.qarmin.czkawka.desktop
}
