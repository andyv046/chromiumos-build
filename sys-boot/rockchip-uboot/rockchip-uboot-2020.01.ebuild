EAPI=5

VARIANT="rockpro64"
VERSION="2017.09-rockchip-ayufan-1065-g95f6152134"
SRC_URI="https://github.com/rockchip-linux/rkbin/archive/master.zip -> rkbin.zip \
	https://github.com/mrfixit2001/rockchip-u-boot/archive/next-dev.zip -> uboot.zip \
	https://github.com/rockchip-linux/gcc-linaro-6.3.1-2017.05-x86_64_aarch64-linux-gnu/archive/master.zip -> toolchain.zip"
RESTRICT+="mirror"
DESCRIPTION="Rockchip U-boot"

LICENSE="Google-TOS"
SLOT="0"
KEYWORDS="-* arm64 arm"

DEPEND=""
RDEPEND=""

S="${WORKDIR}"

src_unpack() {
	unpack ${A}
	mkdir -p prebuilts/gcc/linux-x86/aarch64
	mv gcc-linaro-6.3.1-2017.05-x86_64_aarch64-linux-gnu-master prebuilts/gcc/linux-x86/aarch64/gcc-linaro-6.3.1-2017.05-x86_64_aarch64-linux-gnu
	mv rkbin-master rkbin
	mv rockchip-u-boot-next-dev rockchip-u-boot
}

src_compile() {
	mkimage -O linux -T script -C none -a 0 -e 0 \
		-n "boot" -d "${FILESDIR}/boot.cmd" "boot.scr" || die
	cd rockchip-u-boot
	./make.sh pinebookpro-rk3399
	cp ${FILESDIR}/idbloader.img .
}

src_install() {
	insinto /boot
	doins boot.scr
	doins rockchip-u-boot/idbloader.img
	doins rockchip-u-boot/trust.img
	doins rockchip-u-boot/uboot.img
}
