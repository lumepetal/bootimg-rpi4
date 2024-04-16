#! /usr/bin/bash
git clone --depth=1  https://github.com/raspberrypi/linux.git
cd linux

KERNEL=kernel8
make bcm2711_defconfig

echo "Start building!"
make -j$(nproc) zImage modules dtbs

ls arch/arm/boot