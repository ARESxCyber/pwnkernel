# Kernel pwn helper scripts

For most kernel challenges you'll be given these:
- `bzImage`: compressed kernel image
- `initrd.cpio.gz`: compressed root filesystem
- `launch.sh`: script for starting QEMU

## Kernel Image

Usually can just run `extract_vmlinux_wrapper.sh` to get the `vmlinux` ELF.
Then you can do `gdb vmlinux` and do `target remote :1234` to attach to the
QEMU debugger port.

Unfortunately this method means you don't have any debugging symbols. Workarounds:
1. The dirty solution: `cat /proc/kallsyms | grep <symbol>`
2. The clean solution: Build the kernel with debugging symbols. Takes a long
   time but can be worth it. See `/build_kernel.sh`

If you want to compile kernel code, see `/src/Makefile`. Note that this
requires a debug build of the kernel.

## Root filesystem

You'll almost always want to extract `initrd.cpio.gz`, as that's where the
challenge files (e.g. vulnerable kernel driver) will be stored.

Run `extract_initramfs.sh`, which gives you an `fs` folder.

You can now add stuff to this `fs` folder, and they will be loaded when the
kernel boots.

Usually you'll want to edit the `init` script as well. An example `init_dev` is
provided.

## QEMU launch script

See `launch_dev.sh`. Basically it does two things:
1. Compress the `fs` folder back into a `.cpio.gz`
2. Boot the kernel and rootfs in QEMU

Once launched, you can connect `gdb` as described in the [Kernel
Image](#kernel-image) section.
