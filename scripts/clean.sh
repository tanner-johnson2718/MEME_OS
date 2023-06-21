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

read -p 'Complete Buildroot Clean? (y/n): ' clean
if [ "$clean" = "y" ]; then
    cd $BUILDROOT_DIR
    make clean
    rm -rf $BUILDROOT_CONFIG_DEST
    rm -rf $BUILDROOT_PKG_TREE_DEST
    cd user-apps
    for d in * ; do
        rm -rf "../${BUILDROOT_DIR}/package/${d}"
    done
    cd ../kernel-modules
    for d in * ; do
        rm -rf "../${BUILDROOT_DIR}/package/${d}"
    done
    cd ..
fi