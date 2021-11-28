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

    # Update the build root .config
    echo "BR2_PACKAGE_${d^^}=y" >> ../$BUILDROOT_DIR/.config
    echo ""

    # update packages config.in
    echo "    source package/${d}/Config.in" >> ../$BUILDROOT_DIR/package/Config.in
done
cd ..

echo "endmenu" >> $BUILDROOT_DIR/package/Config.in

echo "Done"