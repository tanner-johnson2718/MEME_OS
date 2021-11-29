# Check that env_init is sourced
if [ -z "$ENV_INIT" ]
then
    echo ""
    echo "Please source env_init.sh"
    echo ""
    exit
fi

# Unpack build root system
tar -xf $BUILDROOT_TARBALL

# copy over saved buildroot .config
cp scripts/buildroot.config $BUILDROOT_DIR/.config

# add new menu to packages config
echo "menu \"Out of Tree Packages\"" >> $BUILDROOT_DIR/package/Config.in

# for each dir in the user-apps dir
cd user-apps
for d in * ; do

    echo "Importing Package ${d} ..."

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

    # update packages config.in
    echo "    source package/${d}/Config.in" >> ../$BUILDROOT_DIR/package/Config.in
done
cd ..

echo "endmenu" >> $BUILDROOT_DIR/package/Config.in

echo "Done"

# Tar up the linux source and place it in the dl folder for buildroot to find it
tar -czvf linux-4.19.218.tar.gz -C linux-4.19.218 .
mkdir $BUILDROOT_DIR/dl
mv linux-4.19.218.tar.gz ${BUILDROOT_DIR}/dl/linux-4.19.218.tar.gz

# Finally move into the buildroot dir and call make
cd $BUILDROOT_DIR
make