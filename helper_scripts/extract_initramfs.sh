#!/usr/bin/env sh
gzip -k -d initramfs.cpio.gz
mkdir fs
cd fs
cpio -idv < ../initramfs.cpio
cd ..
rm initramfs.cpio
