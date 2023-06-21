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


 qemu-system-x86_64 -s -S -M pc -kernel $KERNEL_IMG \
                    -drive file=$ROOTFS,if=virtio,format=raw \
                    -append "rootwait root=/dev/vda console=tty1 console=ttyS0" \
                    -serial stdio -net nic,model=virtio \
                    -net user \
                    -smp 2 \
                    -append nokaslr \