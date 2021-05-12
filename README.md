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

See the `Cross-compilation` section in `helper_scripts/README.md`.

The [Buildroot manual](https://buildroot.org/downloads/manual/manual.html#_using_the_generated_toolchain_outside_buildroot)
has some more information about this.

To build the SDK, run `make sdk` to get a tar of `gcc` and other goodies. For
convenience, this should be distributed to players.
