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
    exit
fi

if [ $PWD != $BASE_DIR ] ;
then
    echo "Please run from ${BASE_DIR}"
    exit
fi

DIR=./user-apps/$1

mkdir $DIR
mkdir $DIR/src
touch $DIR/Config.in
touch $DIR/$1.mk

echo "config BR2_PACKAGE_${1^^}" >> $DIR/Config.in
echo "    bool \"$1\"" >> $DIR/Config.in
echo "    default y" >> $DIR/Config.in
echo "    help" >> $DIR/Config.in
echo "     Enter short description here" >> $DIR/Config.in

echo "${1^^}_VERSION:= 1.0.0" >> $DIR/$1.mk
echo "${1^^}_SITE:= \$(TOPDIR)/../user-apps/${1}/src" >> $DIR/$1.mk
echo "${1^^}_SITE_METHOD:=local" >> $DIR/$1.mk
echo "${1^^}_INSTALL_TARGET:=YES" >> $DIR/$1.mk
echo "" >> $DIR/$1.mk
echo "define ${1^^}_BUILD_CMDS" >> $DIR/$1.mk
echo "    \$(MAKE) CC=\"\$(TARGET_CC)\" LD=\"\$(TARGET_LD)\" CFLAGS=\"\$(TARGET_CFLAGS)\" -C \$(@D) all" >> $DIR/$1.mk
echo "endef" >> $DIR/$1.mk
echo "" >> $DIR/$1.mk
echo "define ${1^^}_INSTALL_TARGET_CMDS" >> $DIR/$1.mk
echo "    \$(INSTALL) -D -m 0755 \$(@D)/${1} \$(TARGET_DIR)/bin" >> $DIR/$1.mk
echo "endef" >> $DIR/$1.mk
echo "" >> $DIR/$1.mk
echo "define ${1^^}_PERMISSIONS" >> $DIR/$1.mk
echo "    /bin/${1} f 4755 0 0 - - - - - " >> $DIR/$1.mk
echo "endef" >> $DIR/$1.mk
echo "" >> $DIR/$1.mk
echo "\$(eval \$(generic-package))" >> $DIR/$1.mk