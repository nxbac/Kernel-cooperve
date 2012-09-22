#!/bin/bash

export PATH=$PATH:$PWD/host/usr/bin
export CROSS_COMPILE=arm-linux-
export CC=arm-linux-gcc
export CXX=arm-linux-g++
export ARCH=arm

cd common

make mrproper && make bcm21553_cooperve_defconfig && make xconfig

if [ -f ../clean ]; then
	rm ../clean
	cd ..
	rm -Rf kernel-repack-MD5/*.lzma kernel-repack-MD5/*.gz kernel-repack-MD5/boot.img-kernel
	rm -Rf kernel-repack-MD5/CWM_kernel/boot.img
	rm -Rf kernel-repack-MD5/CWM_kernel/system/lib/modules/*
	rm *.zip *.tar
	exit
fi

echo "Ready to compile? Hit <Enter> to Continue or <Ctrl>+<C> to Cancel!";
sleep 1 && read
echo $(date +%Y%m%d%H%M) > .version
make CONFIG_DEBUG_SECTION_MISMATCH=y -j`grep processor /proc/cpuinfo | wc -l`
