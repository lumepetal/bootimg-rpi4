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
cat .config

echo "Start building!"
make -j$(nproc) Image.gz modules dtbs

ls arch/arm/boot