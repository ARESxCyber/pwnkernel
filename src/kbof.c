#include <linux/cred.h>
#include <linux/fs.h>
#include <linux/ioctl.h>
#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/proc_fs.h>
#include <linux/uaccess.h>

MODULE_LICENSE("GPL");

static int device_open(struct inode* inode, struct file* filp) {
    printk(KERN_ALERT "Device opened.\n");
    return 0;
}

static int device_release(struct inode* inode, struct file* filp) {
    printk(KERN_ALERT "Device closed.\n");
    return 0;
}

static ssize_t device_read(
    struct file* filp,
    char* buffer,
    size_t length,
    loff_t* offset
) {
    return -EINVAL;
}

static ssize_t device_write(
    struct file* filp,
    const char* buf,
    size_t len,
    loff_t* off)
{
    return -EINVAL;
}

static long device_ioctl(
    struct file* filp,
    unsigned int ioctl_num,
    unsigned long ioctl_param
) {
    char* buf[128];
    printk(KERN_ALERT "Got ioctl request: %#x\n", ioctl_num);
    if (raw_copy_from_user((void*)buf, (void*)ioctl_param, ioctl_num) == 0) {
        printk(KERN_ALERT "Copied %d bytes from userland\n", ioctl_num);
        return 0;
    } else {
        printk(KERN_ALERT "Something went wrong");
        return -EINVAL;
    }
}

static struct file_operations fops = {
    .read = device_read,
    .write = device_write,
    .unlocked_ioctl = device_ioctl,
    .open = device_open,
    .release = device_release
};

struct proc_dir_entry* proc_entry = NULL;

int init_module(void) {
    proc_entry = proc_create("kbof", 0666, NULL, &fops);
    printk(KERN_ALERT "Talk to me at /proc/kbof\n");
    return 0;
}

void cleanup_module(void) {
    if (proc_entry) {
        proc_remove(proc_entry);
    }
}
