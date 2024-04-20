#! /usr/bin/bash
export LPOS_KERNEL_BRANCH=linux-6.8.y

git clone https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git -b $LPOS_KERNEL_BRANCH --depth 1
cd linux-stable

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
