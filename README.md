Based on [pwnkernel](https://github.com/pwncollege/pwnkernel) with a few minor
changes.

## kernel

Run `./build_kernel.sh` to compile `Linux 5.4` with debug symbols. This takes
quite a long time, but can be very helpful.

## initrd

### Buildroot

I used rootfs generated from [buildroot](https://buildroot.org/) because it
creates a system with `uClibc` so that players don't have to send enormous
static binaries.

#### Setup
- Go with default settings, but change it to `x86_64`
- After it's built, get rootfs from `output/images/rootfs.tar`.
- You'll have to do `chmod ug-s bin/busybox` for some reason
- Remember to edit `/etc/passwd` and `init`

### Cross-compilation

Goal: compile binaries that run on the emulator.

#### Option 1

Use the `SDK`.
Run `make sdk` and get the tar. For convenience this should be distributed to
players.

#### Option 2

Use the stuff in `output/host`:
```
export PATH=$HOME/Downloads/buildroot-2021.02.1/output/host/bin:$PATH
x86_64-linux-gcc -o solve solve.c
```

Basically follow the directions in
`8.14.1. Using the generated - toolchain outside Buildroot` of the buildroot manual.
