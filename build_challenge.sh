#!/usr/bin/env bash

set -eu

if [ "$1" == "" ] || [ "$2" == "" ]; then
	echo "Usage: $0 <flag> <kernel_module>"
	exit 1
fi

if [ ! -f "src/$2.c" ]; then
	echo "src/$2.c does not exist"
	exit 1
fi

pushd src
make
popd

rm -rf challenge
mkdir -p challenge/dist challenge/deploy
mkdir fs_backup

mv fs/init fs/*.ko fs_backup/
cp deploy/init fs/
cp "src/$2.ko" fs/
cp "src/$2.c" challenge/dist/

pushd fs
find . -print0 | cpio --null -ov --format=newc | gzip -9 > ../challenge/dist/initramfs.cpio.gz
popd

mv fs/flag fs_backup/
echo "$1" > fs/flag

pushd fs
find . -print0 | cpio --null -ov --format=newc | gzip -9 > ../challenge/deploy/initramfs.cpio.gz
popd

cp linux-5.4/arch/x86/boot/bzImage challenge/deploy/
cp deploy/launch.sh challenge/deploy/

yes | cp -ri fs_backup/* fs/
rm -rf fs_backup
