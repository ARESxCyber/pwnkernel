#!/bin/bash

# Same as `launch.sh` except a few things to make exploit dev easier

# Compress `fs` folder into `.cpio.gz`
pushd fs
find . -print0 | cpio --null -ov --format=newc | gzip -9 > ../initramfs_dev.cpio.gz
popd

# Mount external $HOME to be accessible from within the emulator
/usr/bin/qemu-system-x86_64 \
	-m 64M \
	-kernel $PWD/bzImage \
	-initrd $PWD/initramfs_dev.cpio.gz \
	-fsdev local,security_model=passthrough,id=fsdev0,path=$HOME \
	-device virtio-9p-pci,id=fs0,fsdev=fsdev0,mount_tag=hostshare \
	-nographic \
	-monitor none \
	-append "console=ttyS0 nokaslr" \
	-no-reboot \
	-s  # Expose debugger port
