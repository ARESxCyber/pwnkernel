#!/bin/bash -e

export KERNEL_VERSION=5.4
export BUSYBOX_VERSION=1.32.0

# dependencies
echo "[+] Checking / installing dependencies..."
sudo apt-get -q update
sudo apt-get -q install -y bison flex libelf-dev cpio build-essential libssl-dev qemu-system-x86

# linux kernel

echo "[+] Downloading kernel..."
wget -q -c https://mirrors.edge.kernel.org/pub/linux/kernel/v5.x/linux-$KERNEL_VERSION.tar.gz
[ -e linux-$KERNEL_VERSION ] || tar xzf linux-$KERNEL_VERSION.tar.gz

echo "[+] Building kernel..."
make -C linux-$KERNEL_VERSION defconfig
echo "CONFIG_NET_9P=y" >> linux-$KERNEL_VERSION/.config
echo "CONFIG_NET_9P_DEBUG=n" >> linux-$KERNEL_VERSION/.config
echo "CONFIG_9P_FS=y" >> linux-$KERNEL_VERSION/.config
echo "CONFIG_9P_FS_POSIX_ACL=y" >> linux-$KERNEL_VERSION/.config
echo "CONFIG_9P_FS_SECURITY=y" >> linux-$KERNEL_VERSION/.config
echo "CONFIG_NET_9P_VIRTIO=y" >> linux-$KERNEL_VERSION/.config
echo "CONFIG_VIRTIO_PCI=y" >> linux-$KERNEL_VERSION/.config
echo "CONFIG_VIRTIO_BLK=y" >> linux-$KERNEL_VERSION/.config
echo "CONFIG_VIRTIO_BLK_SCSI=y" >> linux-$KERNEL_VERSION/.config
echo "CONFIG_VIRTIO_NET=y" >> linux-$KERNEL_VERSION/.config
echo "CONFIG_VIRTIO_CONSOLE=y" >> linux-$KERNEL_VERSION/.config
echo "CONFIG_HW_RANDOM_VIRTIO=y" >> linux-$KERNEL_VERSION/.config
echo "CONFIG_DRM_VIRTIO_GPU=y" >> linux-$KERNEL_VERSION/.config
echo "CONFIG_VIRTIO_PCI_LEGACY=y" >> linux-$KERNEL_VERSION/.config
echo "CONFIG_VIRTIO_BALLOON=y" >> linux-$KERNEL_VERSION/.config
echo "CONFIG_VIRTIO_INPUT=y" >> linux-$KERNEL_VERSION/.config
echo "CONFIG_CRYPTO_DEV_VIRTIO=y" >> linux-$KERNEL_VERSION/.config
echo "CONFIG_BALLOON_COMPACTION=y" >> linux-$KERNEL_VERSION/.config
echo "CONFIG_PCI=y" >> linux-$KERNEL_VERSION/.config
echo "CONFIG_PCI_HOST_GENERIC=y" >> linux-$KERNEL_VERSION/.config
echo "CONFIG_GDB_SCRIPTS=y" >> linux-$KERNEL_VERSION/.config
echo "CONFIG_DEBUG_INFO=y" >> linux-$KERNEL_VERSION/.config
echo "CONFIG_DEBUG_INFO_REDUCED=n" >> linux-$KERNEL_VERSION/.config
echo "CONFIG_DEBUG_INFO_SPLIT=n" >> linux-$KERNEL_VERSION/.config
echo "CONFIG_DEBUG_FS=y" >> linux-$KERNEL_VERSION/.config
echo "CONFIG_DEBUG_INFO_DWARF4=y" >> linux-$KERNEL_VERSION/.config
echo "CONFIG_DEBUG_INFO_BTF=y" >> linux-$KERNEL_VERSION/.config
echo "CONFIG_FRAME_POINTER=y" >> linux-$KERNEL_VERSION/.config
make -C linux-$KERNEL_VERSION -j16 bzImage