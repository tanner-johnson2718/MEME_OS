# Check that env_init is sourced
if [ -z "$ENV_INIT"]
then
    echo ""
    echo "Please source env_init.sh"
    echo ""
    exit
fi

# expected to be run from project root, check this

# Unpack build root system
tar -xf archives/buildroot-2021.02.7.tar.gz

# for each dir in the user-apps dir
# Copy user app meta data to the package folder of the build root system
mkdir $BUILDROOT_DIR/packages/hello


# Update the buildroot menuconfig

# Update the build root .config