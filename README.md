Based on [pwnkernel](https://github.com/pwncollege/pwnkernel) with a few minor
changes.

---

> The instructions below are for *creating* a pwnkernel challenge. For
> instructions on *solving* a pwnkernel challenge see `helper_scripts`.

## Kernel

Run `./build_kernel.sh` to compile the Linux kernel with debugging symbols.
This takes quite a long time.

### Building kernel modules

- Create `src/foo.c`
- Add an entry in `src/Makefile`
- Run `make`
- Copy `foo.ko` to `fs/`
- Run `launch.sh`
- Run `insmod foo.ko`. To automatically load `foo.ko`, add that line to `fs/init`

## Root filesystem

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

Goal: compile binaries that run on the emulator. Basically follow the
directions in the
[Buildroot manual](https://buildroot.org/downloads/manual/manual.html#_using_the_generated_toolchain_outside_buildroot).

You can run `make sdk` to get a tar of `gcc` and other goodies. For
convenience, this should be distributed to players.
