#! /usr/bin/bash
export LPOS_KERNEL_VERSION=v6.8

git clone https://github.com/torvalds/linux
cd linux
git checkout $LPOS_KERNEL_VERSION

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

make defconfig

export LPOS_KRNLCFG_HYPERVISOR_GUEST=y
export LPOS_KRNLCFG_EFI_STUB=y
bash ../kconfig.sh

cat .config

echo "Start building with $(nproc) cores!"
make -j$(nproc) bzImage

ls arch/x86/boot/
