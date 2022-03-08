# Check that env_init is sourced
if [ -z "$ENV_INIT" ]
then
    echo ""
    echo "Please source env_init.sh"
    echo ""
    exit
fi

if [ $# != 1 ]; then
    echo "error usage ./rebuild_app <app>"
fi

# delete indicated apps source and rootfs
rm -r ${BUILDROOT_DIR}/output/build/$1-*
rm -r ${ROOTFS}

# rebuild
cd ${BUILDROOT_DIR}
make $1
make
cd ..