BUILDROOT_DIR="./buildroot-2021.02.7"
KERNEL_IMG="${BUILDROOT_DIR}/output/images/bzImage"
ROOTFS="${BUILDROOT_DIR}/output/images/rootfs.ext2"
KERNEL_DEBUG_IMG="${BUILDROOT_DIR}/output/build/linux-5.10.77"
GDB_CMD="./gdb_cmds.txt"

gnome-terminal -- gdb $KERNEL_DEBUG_IMG -x $GDB_CMD 

qemu-system-x86_64 -s -S -no-kvm -kernel $KERNEL_IMG -hda $ROOTFS -append \
"root=/dev/sda rw console=ttyS0,115200 acpi=off nokaslr" -serial stdio \
-display none