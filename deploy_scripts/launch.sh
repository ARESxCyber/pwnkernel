#!/bin/bash

timeout --foreground 180 /usr/bin/qemu-system-x86_64 \
	-m 64M \
	-kernel $PWD/bzImage \
	-initrd $PWD/initramfs.cpio.gz \
	-nographic \
	-monitor none \
	-append "console=ttyS0 nokaslr panic=1" \
	-no-reboot
