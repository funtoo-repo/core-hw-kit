# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit eutils flag-o-matic systemd toolchain-funcs

DESCRIPTION="System performance tools for Linux"
HOMEPAGE="http://pagesperso-orange.fr/sebastien.godard/"
SRC_URI="https://github.com/sysstat/sysstat/tarball/dac10e13c70d1102aa3beea10135a3ed60520c36 -> sysstat-12.7.7-dac10e1.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"
IUSE="debug nls lm_sensors selinux static"

CDEPEND="
	nls? ( virtual/libintl )
	lm_sensors? ( sys-apps/lm_sensors:= )
"
DEPEND="
	${CDEPEND}
	nls? ( sys-devel/gettext )
"
RDEPEND="
	${CDEPEND}
	selinux? ( sec-policy/selinux-sysstat )
"

post_src_unpack() {
        if [ ! -d "${S}" ]; then
                mv sysstat-sysstat* "${S}" || die
        fi
}

src_prepare() {
	if use nls; then
		strip-linguas -i nls/
		local lingua pofile
		for pofile in nls/*.po; do
			lingua=${pofile/nls\/}
			lingua=${lingua/.po}
			if ! has ${lingua} ${LINGUAS}; then
				rm "nls/${lingua}.po" || die
			fi
		done
	fi

	default
}

src_configure() {
	tc-export AR
	use static && append-ldflags -static

	sa_lib_dir=/usr/lib/sa \
		conf_dir=/etc \
		econf \
			$(use_enable debug debuginfo) \
			$(use_enable lm_sensors sensors) \
			$(use_enable nls) \
			--disable-compress-manpg \
			--enable-copy-only \
			--enable-documentation \
			--enable-install-cron \
			--with-systemdsystemunitdir=$(systemd_get_systemunitdir)
}

src_install() {
	keepdir /var/log/sa

	emake \
		CHOWN=true \
		DESTDIR="${D}" \
		DOC_DIR=/usr/share/doc/${PF} \
		MANGRPARG='' \
		install

	dodoc -r contrib/

	newinitd "${FILESDIR}"/${PN}.init.d ${PN}
	systemd_dounit ${PN}.service

	rm -f "${D}"usr/share/doc/${PF}/COPYING
}