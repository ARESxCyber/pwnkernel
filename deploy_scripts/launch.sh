#!/bin/bash

timeout --foreground 180 /usr/bin/qemu-system-x86_64 \
	-m 64M \
	-kernel /home/ctf/app/bzImage \
	-initrd /home/ctf/app/initramfs.cpio.gz \
	-nographic \
	-monitor none \
	-append "console=ttyS0 nokaslr oops=panic panic=1" \
	-no-reboot
