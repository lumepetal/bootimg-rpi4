#! /usr/bin/bash
git clone --depth=1  https://github.com/raspberrypi/linux.git
cd linux

export KERNEL=kernel8
make bcm2711_defconfig

echo "Start building!"
make -j$(nproc) Image.gz modules dtbs

ls arch/arm/boot