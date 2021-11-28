# Check that env_init is sourced
if [ -z "$ENV_INIT"]
then
    echo ""
    echo "Please source env_init.sh"
    echo ""
    exit
fi

gnome-terminal -- gdb $KERNEL_DEBUG_IMG -x $GDB_CMD 

qemu-system-x86_64 -s -S -no-kvm -kernel $KERNEL_IMG -hda $ROOTFS -append \
"root=/dev/sda rw console=ttyS0,115200 acpi=off nokaslr" -serial stdio \
-display none