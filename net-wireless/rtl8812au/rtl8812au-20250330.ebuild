# Distributed under the terms of the GNU General Public License v2
EAPI=7
inherit linux-mod

DESCRIPTION="Realtek 8812AU driver module for the Linux Kernel and Android"
HOMEPAGE="https://github.com/aircrack-ng/rtl8812au"
SRC_URI="https://github.com/aircrack-ng/rtl8812au/archive/c3fb89a2f7066f4bf4e4d9d85d84f9791f14c83e.tar.gz -> rtl8812au-20250330.tar.gz"

LICENSE="GPL-2"
KEYWORDS="-* amd64 x86 arm64 arm"

DEPEND="virtual/linux-sources"

MODULE_NAMES="88XXau(net/wireless)"
BUILD_TARGETS="all"

src_unpack() {
	unpack ${A}
	mv "${WORKDIR}"/rtl8812au-* "${S}"
}