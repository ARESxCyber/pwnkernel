# Extract vmlinux ELF from bzImage so that we can debug the kernel with GDB

# Note: If you want to have debug symbols, you can compile the kernel as shown
# here: https://github.com/pwncollege/pwnkernel/blob/main/build.sh
# Unfortunately it takes a long time to compile but is very helpful.

wget -O extract-vmlinux https://raw.githubusercontent.com/torvalds/linux/master/scripts/extract-vmlinux
chmod +x extract-vmlinux
./extract-vmlinux bzImage > vmlinux
