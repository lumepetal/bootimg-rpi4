#! /usr/bin/bash
git clone --depth=1  https://github.com/raspberrypi/linux.git
cd linux

export KERNEL=kernel8
export ARCH=arm64
export CROSS_COMPILE=aarch64-linux-gnu-
export LLVM=1
export CC=clang 
export LD=ld.lld 
export AR=llvm-ar 
export NM=llvm-nm 
export STRIP=llvm-strip
export OBJCOPY=llvm-objcopy
export OBJDUMP=llvm-objdump
export READELF=llvm-readelf
export HOSTCC=clang
export HOSTCXX=clang++
export HOSTAR=llvm-ar
export HOSTLD=ld.lld

make bcm2711_defconfig

export LPOS_KRNLCFG_HYPERVISOR_GUEST=n
export LPOS_KRNLCFG_EFI_STUB=y
export LPOS_KRNLCFG_HARDENING_FOR_X86=n
bash ../kconfig.sh

cat .config

echo "Start building with $(nproc) cores!"
make -j$(nproc)

ls arch/arm/boot
