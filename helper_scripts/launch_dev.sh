#!/bin/bash

# Same as `launch.sh` except a few things to make exploit dev easier

# Compress `initramfs` folder into `.cpio.gz`
pushd fs
find . -print0 | cpio --null -ov --format=newc | gzip -9 > ../build_initramfs.cpio.gz
popd

# Mount external $HOME to be accessible from within the emulator
timeout --foreground 180 /usr/bin/qemu-system-x86_64 \
	-m 64M \
	-kernel $PWD/bzImage \
	-initrd $PWD/build_initramfs.cpio.gz \
	-fsdev local,security_model=passthrough,id=fsdev0,path=$HOME \
	-device virtio-9p-pci,id=fs0,fsdev=fsdev0,mount_tag=hostshare \
	-nographic \
	-monitor none \
	-append "console=ttyS0 nokaslr oops=panic panic=1" \
	-no-reboot \
	-s  # Expose debugger port
