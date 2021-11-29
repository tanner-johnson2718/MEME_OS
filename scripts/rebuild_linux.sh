# Check that env_init is sourced
if [ -z "$ENV_INIT" ]
then
    echo ""
    echo "Please source env_init.sh"
    echo ""
    exit
fi

# delete linux-custom sub directory and output image
rm -f $KERNEL_IMG
rm -rf $BUILDROOT_DIR/output/build/linux-custom

# Tar up the linux source and place it in the dl folder for buildroot to find it
tar -czf linux-4.19.218.tar.gz -C linux-4.19.218 .
mkdir $BUILDROOT_DIR/dl
mv linux-4.19.218.tar.gz ${BUILDROOT_DIR}/dl/linux-4.19.218.tar.gz

# Finally move into the buildroot dir and call make
cd $BUILDROOT_DIR
make