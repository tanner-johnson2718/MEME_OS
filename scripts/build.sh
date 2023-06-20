###############################################################################
# Build completely from scratch.
# - copy over the buildroot .config and Config.in
# - For each dir in user app:
#    - Copy user app meta data i.e. Config.in and package.mk
#    - Update packages Config.in
#    - Finally update .config to add package to build
# - Do same thing for k-mods
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

if [ $PWD != $BASE_DIR ] ;
then
    echo "Please run from ${BASE_DIR}"
    exit
fi

# copy over saved buildroot .config adn package tree to ensure that as we mod
# it, we start from the same starting point. 
cp $BUILDROOT_CONFIG_CLEAN_COPY     $BUILDROOT_CONFIG_DEST
cp $BUILDROOT_PKG_TREE_CLEAN_COPY   $BUILDROOT_PKG_TREE_DEST

# add new menu to packages config
echo "menu \"Out of Tree Packages\"" >> $BUILDROOT_PKG_TREE_DEST

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
    echo "    source package/${d}/Config.in" >> ../$BUILDROOT_PKG_TREE_DEST

    # Update .config
    echo "BR2_PACKAGE_${d^^}=y" >> ../$BUILDROOT_CONFIG_DEST
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
    echo "    source package/${d}/Config.in" >> ../$BUILDROOT_PKG_TREE_DEST

    # Update .config
    echo "BR2_PACKAGE_${d^^}=y" >> ../$BUILDROOT_CONFIG_DEST
done
cd ..

echo "endmenu" >> $BUILDROOT_PKG_TREE_DEST

echo "Done"

echo "Build System Expanded"
read -p 'Build? (y/n): ' build

# Finally move into the buildroot dir and call make
if [ "$build" = "y" ]; then
    cd $BUILDROOT_DIR
    make
    cd $BASE_DIR
fi