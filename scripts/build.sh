###############################################################################
# Build completely from scratch.
# - unpack build root tar
# - copy over the buildroot .config
# - For each dir in user app:
#    - Copy user app meta data i.e. Config.in and package.mk
#    - Update packages Config.in
#    - Finally update .config to add package to build
# - Tar up out of tree linux and copy to DL folder
# - Finally call make in buildroot dir
###############################################################################

# Check that env_init is sourced
if [ -z "$ENV_INIT" ]
then
    echo ""
    echo "Please source env_init.sh"
    echo ""
    exit
fi

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
        echo "Cannot find ${d}/Config.in"
    fi

    if [ -f "${d}/${d}.mk" ]; then
        cp "${d}/${d}.mk"  "../${BUILDROOT_DIR}/package/${d}/${d}.mk"
    else
        echo "Cannot find ${d}/${d}.mk"
    fi

    # update packages config.in
    echo "    source package/${d}/Config.in" >> ../$BUILDROOT_DIR/package/Config.in

    # Update .config
    echo "BR2_PACKAGE_${d^^}=y" >> ../$BUILDROOT_DIR/.config
done
cd ..

# for each dir in the kernel-mod dir
cd kernel-modules
for d in * ; do

    echo "Importing Package (Kernel Mod) ${d} ..."

    # Copy user app meta data to the package folder of the build root system
    mkdir "../${BUILDROOT_DIR}/package/${d}"
    if [ -f "${d}/Config.in" ]; then
        cp "${d}/Config.in"  "../${BUILDROOT_DIR}/package/${d}/Config.in"
    else
        echo "Cannot find ${d}/Config.in"
    fi

    if [ -f "${d}/${d}.mk" ]; then
        cp "${d}/${d}.mk"  "../${BUILDROOT_DIR}/package/${d}/${d}.mk"
    else
        echo "Cannot find ${d}/${d}.mk"
    fi

    # update packages config.in
    echo "    source package/${d}/Config.in" >> ../$BUILDROOT_DIR/package/Config.in

    # Update .config
    echo "BR2_PACKAGE_${d^^}=y" >> ../$BUILDROOT_DIR/.config
done
cd ..

echo "endmenu" >> $BUILDROOT_DIR/package/Config.in

echo "Done"

echo "Build System Expanded"
read -p 'Build? (y/n): ' build

# Finally move into the buildroot dir and call make
if [ "$build" = "y" ]; then
    cd $BUILDROOT_DIR
    make
fi