#!/bin/bash

# build root fs
pushd fs
find . -print0 | cpio --null -ov --format=newc | gzip -9 > ../initramfs.cpio.gz
popd

# launch
/usr/bin/qemu-system-x86_64 \
	-kernel linux-5.4/arch/x86/boot/bzImage \
	-initrd $PWD/initramfs.cpio.gz \
	-nographic \
	-monitor none \
	-s \
	-append "console=ttyS0 nokaslr oops=panic panic=1" \
	-no-reboot
