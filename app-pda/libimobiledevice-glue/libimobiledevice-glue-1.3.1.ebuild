# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="USB multiplex daemon for use with Apple iPhone/iPod Touch devices"
HOMEPAGE="https://www.libimobiledevice.org/"
SRC_URI="https://github.com/libimobiledevice/libimobiledevice-glue/releases/download/1.3.1/libimobiledevice-glue-1.3.1.tar.bz2 -> libimobiledevice-glue-1.3.1.tar.bz2"
LICENSE="GPL-2+ LGPL-2.1+"

SLOT="0/0.1.0"
KEYWORDS="*"
IUSE="static-libs"

RDEPEND="
	>=app-pda/libplist-2.3.0:=
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
"

post_src_unpack() {
	if [ ! -d "${S}" ]; then
		mv libimobiledevice-libimobiledevice-glue* "${S}" || die
	fi
}

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable static-libs static) \
		$(usex kernel_linux '' --without-inotify)
}

src_install() {
	default
	find "${D}" -name '*.la' -type f -delete || die
	cp "${ED}"/usr/lib64/pkgconfig/${PN}-*.pc "${ED}"/usr/lib64/pkgconfig/${PN}.pc
}