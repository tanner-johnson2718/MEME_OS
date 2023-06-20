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

# delete linux-custom sub directory and output image
rm -f $KERNEL_IMG
rm -rf $BUILDROOT_DIR/output/build/linux-*

# Finally move into the buildroot dir and call make
cd $BUILDROOT_DIR
make