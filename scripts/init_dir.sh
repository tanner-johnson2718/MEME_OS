# Check that env_init is sourced
if [ -z "$ENV_INIT" ]
then
    echo ""
    echo "Please source env_init.sh"
    echo ""
    exit
fi

# expected to be run from project root, check this

# Unpack build root system
mkdir $BUILDROOT_DIR
tar -xf $BUILDROOT_TARBALL -C $BUILDROOT_DIR --strip-components=1

# for each dir in the user-apps dir
cd user-apps
for d in * ; do

    echo "Importing Package ${d}"

    # Copy user app meta data to the package folder of the build root system
    mkdir "../${BUILDROOT_DIR}/package/${d}"
    if [ -f "${d}/Config.in" ]; then
        cp "${d}/Config.in"  "../${BUILDROOT_DIR}/package/${d}/Config.in"
    else
        echo "${d}/Config.in"
    fi

    if [ -f "${d}/${d}.mk" ]; then
        cp "${d}/${d}.mk"  "../${BUILDROOT_DIR}/package/${d}/${d}.mk"
    else
        echo "Cannot find ${d}/${d}.mk"
    fi

    # Update the build root .config
    echo "BR2_PACKAGE_${d^^}=y" >> $BUILDROOT_DIR/.defconfig
    echo ""
done
cd ..