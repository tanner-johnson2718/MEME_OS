# Check that env_init is sourced
if [ -z "$ENV_INIT" ]
then
    echo ""
    echo "Please source env_init.sh"
    echo ""
    exit
fi

if [ $PWD != $BASE_DIR ] ;
then
    echo "Please run from ${BASE_DIR}"
    exit
fi


gnome-terminal -- gdb $KERNEL_DEBUG_IMG -x $GDB_CMD 

qemu-system-x86_64 -s -S -kernel $KERNEL_IMG -hda $ROOTFS -append \
"root=/dev/sda rw console=ttyS0,115200 acpi=off nokaslr"  -smp 4