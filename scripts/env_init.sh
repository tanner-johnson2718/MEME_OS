# Must be sourced, check that!
script_name=$( basename ${0#-} ) #- needed if sourced no path
this_script=$( basename ${BASH_SOURCE} )
if [[ ${script_name} = ${this_script} ]] ; then
    echo ""
    echo "Please source me!!"
    echo ""
    exit 
fi 

# Directory Variables
export BUILDROOT_DIR="buildroot-2021.02.7"
export BUILDROOT_TARBALL="archives/buildroot-2021.02.7.tar.gz"
export KERNEL_IMG="${BUILDROOT_DIR}/output/images/bzImage"
export ROOTFS="${BUILDROOT_DIR}/output/images/rootfs.ext2"
export KERNEL_DEBUG_IMG="${BUILDROOT_DIR}/output/build/linux-5.10.77/vmlinux"
export GDB_CMD="scripts/gdb_cmds.txt"

export ENV_INIT="true"