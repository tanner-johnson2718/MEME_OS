# Check that env_init is sourced
if [ -z "$ENV_INIT" ]
then
    echo ""
    echo "Please source env_init.sh"
    echo ""
    exit
fi

if [ $# != 1 ]; then
    echo "error usage ./create_empty_app.sh <app>"
fi

if [ $PWD != $BASE_DIR ] ;
then
    echo "Please run from ${BASE_DIR}"
    exit
fi

DIR=kernel-modules/$1

mkdir $DIR
mkdir $DIR/src
touch $DIR/Config.in
touch $DIR/$1.mk

echo "config BR2_PACKAGE_${1^^}" >> $DIR/Config.in
echo "    bool \"$1\"" >> $DIR/Config.in
echo "    depends on BR2_LINUX_KERNEL" >> $DIR/Config.in 
echo "    default y" >> $DIR/Config.in
echo "    help" >> $DIR/Config.in
echo "     Enter short description here" >> $DIR/Config.in

echo "${1^^}_VERSION:= 1.0.0" >> $DIR/$1.mk
echo "${1^^}_SITE:= \$(TOPDIR)/../$DIR/src" >> $DIR/$1.mk
echo "${1^^}_SITE_METHOD:=local" >> $DIR/$1.mk
echo "" >> $DIR/$1.mk
echo "\$(eval \$(kernel-module))" >> $DIR/$1.mk
echo "\$(eval \$(generic-package))" >> $DIR/$1.mk