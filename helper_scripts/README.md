# Kernel pwn helper scripts

For most kernel challenges you'll be given these:
- `bzImage`: compressed kernel image
- `initrd.cpio.gz`: compressed root filesystem
- `launch.sh`: script for starting QEMU

## Kernel Image

Usually can just run `extract_vmlinux_wrapper.sh` to get the `vmlinux` ELF.
You'll use this `vmlinux` to debug in `gdb`.

Unfortunately simply extracting `vmlinux` means you don't have any debugging
symbols. Workarounds:
1. The dirty solution: `cat /proc/kallsyms | grep <symbol>`
2. The clean solution: Build the kernel with debugging symbols. Takes a long
   time but can be worth it. See `/build_kernel.sh`

If you want to compile kernel code, see `/src/Makefile`. Note that this
requires a debug build of the kernel.

## Root filesystem

You'll almost always want to extract `initrd.cpio.gz`, as that's where the
challenge files (e.g. vulnerable kernel driver) will be stored.

Run `extract_initramfs.sh`, which gives you an `fs` folder.

You can now add stuff to this `fs` folder and they'll be loaded when the kernel
boots.

For local testing, you'll want to edit the `fs/init` script so that:
- You start with a root shell
- `$HOME` is mounted in `/home/ctf`, which allows you to access external files
  from within the emulator

An example `/fs/init` is provided that does those two things.

## QEMU launch script

See `/launch.sh`. Basically it does two things:
1. Compress the `fs` folder back into a `.cpio.gz`
2. Boot the kernel and rootfs in QEMU

Once launched, you can connect `gdb` as described in the
[Kernel Image](#kernel-image) section.

Then you can do `gdb vmlinux` and do `target remote :1234` to attach to the
QEMU debugger port

**Note**: For some reason, the `ni` command is broken. You'll need to use `si`
and `finish` to step out of function calls.

## Cross-compilation

Once you have the kernel running in QEMU, you'll want to start developing an
exploit. Since there's no C compiler provided in the emulator, you'll need to
compile your exploit externally.

### Static linking

You can do `gcc -o solve -static solve.c`, and you should be able to run
`./solve` in the emulator. However, static linking results in very large
executables which take too long to send over a networked session.

### Dynamic linking

To keep the binary size small, we can cross-compile dynamically-linked binaries
that run on the emulator.

An SDK is provided in `x86_64-buildroot-linux-uclibc_sdk-buildroot.tar.gz`.
Extract it and run `relocate-sdk.sh`. Then you can use `cross_compile.sh` to
compile your C files.
