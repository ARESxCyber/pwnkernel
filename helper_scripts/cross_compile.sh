# Cross-compile a file to work on the OS running in the emulator.
# Usage:
# ```
# source cross_compile.sh
# gcc -o solve solve.c
# ```

# Remember to run `x86_64-buildroot-linux-uclibc_sdk-buildroot/relocate-sdk.sh`
# before running this

alias gcc=./x86_64-buildroot-linux-uclibc_sdk-buildroot/bin/x86_64-linux-gcc
