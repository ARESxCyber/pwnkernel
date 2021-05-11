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

void* shellcode;
typedef void func(void);

static long device_ioctl(
    struct file* filp,
    unsigned int ioctl_num,
    unsigned long ioctl_param
) {
    printk(KERN_ALERT "Got ioctl argument %#x!\n", ioctl_num);
    if (ioctl_num < 128) {
        copy_from_user(shellcode, (void*)ioctl_param, ioctl_num);
        ((func*)shellcode)();
    }

    return 0;
}

static struct file_operations fops = {
    .read = device_read,
    .write = device_write,
    .unlocked_ioctl = device_ioctl,
    .open = device_open,
    .release = device_release
};

struct proc_dir_entry* proc_entry = NULL;

int init_module() {
    shellcode = __vmalloc(128, GFP_KERNEL, PAGE_KERNEL_EXEC);
    proc_entry = proc_create("kshellcode", 0666, NULL, &fops);
    printk(KERN_ALERT "Talk to me at /proc/kshellcode\n");
    return 0;
}

void cleanup_module() {
    if (proc_entry)
        proc_remove(proc_entry);
}
