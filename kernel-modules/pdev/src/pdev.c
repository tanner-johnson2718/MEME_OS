#include <linux/uaccess.h>
#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/random.h>
#include <linux/init.h>
#include <linux/fs.h>

MODULE_LICENSE("GPL");
MODULE_DESCRIPTION("quantum cat device");
MODULE_AUTHOR("dcat");
MODULE_VERSION("0.1");

static ssize_t dev_read(struct file *, char *, size_t, loff_t *);
static int     dev_open(struct inode *, struct file *);
static int     dev_release(struct inode *, struct file *);

/* callbacks for file operations */
static struct file_operations fops = {
    .read = dev_read,
    .open = dev_open,
    .release = dev_release
};

static int major;

/* state control */
static int busy; /* is the device already opened?   */
static int done; /* has the file already been read? */

static char dcat[] =
    "\033[38;5;238m ,                          ,,\"'\n"
    "  ▚,                      ,\"=|\n"
    "  '▒\"UL  .  -= ▔▔  =+=  J'\"░/,\n"
    "   \E}     ▔               ▙' _\n"
    "   ]                       ▞\n"
    "    '░   < \033[38;5;226mX\033[38;5;238m >"
    "     < \033[38;5;226mX\033[38;5;238m >  E\n"
    "  ───-                    G-───\n"
    "  __─-''        `/       ''-─__\n"
    "    ,-'\" ,▗     ▁▁      K\"'-.\n"
    "            =_   \033[38;5;203mU\033[38;5;238m _ # '\"\n"
    "              ' ' \"\033[0m\n";

static ssize_t
dev_read(struct file *fp, char *buf, size_t n, loff_t *of) {
    ssize_t len = sizeof(dcat)/sizeof(dcat[0]); /* get length of dcat */
    char rand;

    get_random_bytes(&rand, sizeof(rand));
    if (rand > 0) {
        dcat[0xce] = '>';
        dcat[0xee] = '>';
        dcat[0x190] = ' ';
    } else {
        dcat[0xce] = 'X';
        dcat[0xee] = 'X';
        dcat[0x190] = 'U';
    }


    if (done)
        return 0;


    /*
     * copy_to_user() and put_user() should be used
     * when moving memory from kernel- to userspace.
     */
    if (copy_to_user(buf, dcat, len))
        printk(KERN_ALERT "copy_on_user");

    done = 1;
    return len;
}

static int dev_open(struct inode *ino, struct file *fp) {
    /* if device is in use, reply with busy error */
    if (busy)
        return -EBUSY;

    busy = 1; /* toggle device as busy */
    try_module_get(THIS_MODULE); /* tell the system that we're live */
    return 0;
}

static int dev_release(struct inode *ino, struct file *fp) {
    done = busy = 0;
    module_put(THIS_MODULE); /* we're finished */
    return 0;
}

static void kexit(void) {
    unregister_chrdev(major, "dcat");
    return;
}

static int kinit(void) {
    /* register as a character device */
    major = register_chrdev(0, "dcat", &fops);

    done = busy = 0;

    if (major < 0)
        printk(KERN_ALERT "register_chrdev %d", major);

    return 0;
}

module_init(kinit);
module_exit(kexit);
