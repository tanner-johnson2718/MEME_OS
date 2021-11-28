# Must be sourced, check that!
script_name=$( basename ${0#-} ) #- needed if sourced no path
this_script=$( basename ${BASH_SOURCE} )
if [[ ${script_name} = ${this_script} ]] ; then
    echo ""
    echo "Please source me!!"
    echo ""
    exit 
fi 

BUILDROOT_DIR="./buildroot-2021.02.7"
KERNEL_IMG="${BUILDROOT_DIR}/output/images/bzImage"
ROOTFS="${BUILDROOT_DIR}/output/images/rootfs.ext2"
KERNEL_DEBUG_IMG="${BUILDROOT_DIR}/output/build/linux-5.10.77"
GDB_CMD="./gdb_cmds.txt"

ENV_INIT="true"