# pwnkernel

Based on [pwnkernel](https://github.com/pwncollege/pwnkernel) with a few minor
changes.

> The instructions below are for *creating* a kernel pwn challenge. For
> instructions on *solving* a kernel pwn challenge, see
> [helper_scripts](helper_scripts/).

## Kernel

Run `./build_kernel.sh` to compile the Linux kernel with debugging symbols.
This takes quite a long time.

### Building kernel modules

- Create `src/foo.c`
- Add an entry in `src/Makefile`
- Run `make`
- Copy `foo.ko` to `fs/`
- Run `launch.sh`
- By default, `foo.ko` will automatically be loaded. You can also do it
  manually with `insmod foo.ko`.

## Root filesystem

I used rootfs generated from [Buildroot](https://buildroot.org/) because it
creates a system with `uClibc` so that players don't have to send enormous
static binaries.

If you want to generate an `fs/` from scratch, follow these directions.
Otherwise a working `fs/` is already provided.

- Go with default settings, but change it to `x86_64`
- After it's built, get rootfs from `output/images/rootfs.tar`.
- You'll have to do `chmod ug-s bin/busybox` for some reason
- Remember to edit `/etc/passwd` and `init`

## Cross-compilation

You can do `gcc -o solve -static solve.c`, and you should be able to run
`./solve` in the emulator. However, static linking results in very large
executables which take too long to send over a networked session.

Instead we can cross-compile dynamically-linked binaries that run on the
emulator. Basically follow the directions in the
[Buildroot manual](https://buildroot.org/downloads/manual/manual.html#_using_the_generated_toolchain_outside_buildroot).

You can run `make sdk` to get a tar of `gcc` and other goodies. For
convenience, this should be distributed to players.
