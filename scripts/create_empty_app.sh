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

mkdir user-apps/$1
mkdir user-apps/$1/src
touch user-apps/$1/Config.in
touch user-apps/$1/$1.mk

echo "config BR2_PACKAGE_${1^^}" >> user-apps/$1/Config.in
echo "    bool \"$1\"" >> user-apps/$1/Config.in
echo "    default y" >> user-apps/$1/Config.in
echo "    help" >> user-apps/$1/Config.in
echo "     Enter short description here" >> user-apps/$1/Config.in

echo "${1^^}_VERSION:= 1.0.0" >> user-apps/$1/$1.mk
echo "${1^^}_SITE:= \$(TOPDIR)/../user-apps/${1}/src" >> user-apps/$1/$1.mk
echo "${1^^}_SITE_METHOD:=local" >> user-apps/$1/$1.mk
echo "${1^^}_INSTALL_TARGET:=YES" >> user-apps/$1/$1.mk
echo "" >> user-apps/$1/$1.mk
echo "define ${1^^}_BUILD_CMDS" >> user-apps/$1/$1.mk
echo "    \$(MAKE) CC=\"\$(TARGET_CC)\" LD=\"\$(TARGET_LD)\" CFLAGS=\"\$(TARGET_CFLAGS)\" -C \$(@D) all" >> user-apps/$1/$1.mk
echo "endef" >> user-apps/$1/$1.mk
echo "" >> user-apps/$1/$1.mk
echo "define ${1^^}_INSTALL_TARGET_CMDS" >> user-apps/$1/$1.mk
echo "    \$(INSTALL) -D -m 0755 \$(@D)/${1} \$(TARGET_DIR)/bin" >> user-apps/$1/$1.mk
echo "endef" >> user-apps/$1/$1.mk
echo "" >> user-apps/$1/$1.mk
echo "define ${1^^}_PERMISSIONS" >> user-apps/$1/$1.mk
echo "    /bin/${1} f 4755 0 0 - - - - - " >> user-apps/$1/$1.mk
echo "endef" >> user-apps/$1/$1.mk
echo "" >> user-apps/$1/$1.mk
echo "\$(eval \$(generic-package))" >> user-apps/$1/$1.mk

rm ${BUILDROOT_DIR}/.config
echo "Type n in 1 sec"
./scripts/build.sh &> /dev/null