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
    cd cd $BASE_DIR
fi