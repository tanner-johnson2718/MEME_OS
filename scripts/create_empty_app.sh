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

PATH = user-apps/$1

mkdir ${PATH}
mkdir ${PATH}/src
touch ${PATH}/Config.in
touch ${PATH}/$1.mk

echo "config BR2_PACKAGE_${1^^}" >> ${PATH}/Config.in
echo "    bool \"$1\"" >> ${PATH}/Config.in
echo "    default y" >> ${PATH}/Config.in
echo "    help" >> ${PATH}/Config.in
echo "     Enter short description here" >> ${PATH}/Config.in

echo "${1^^}_VERSION:= 1.0.0" >> ${PATH}/$1.mk
echo "${1^^}_SITE:= \$(TOPDIR)/../user-apps/${1}/src" >> ${PATH}/$1.mk
echo "${1^^}_SITE_METHOD:=local" >> ${PATH}/$1.mk
echo "${1^^}_INSTALL_TARGET:=YES" >> ${PATH}/$1.mk
echo "" >> ${PATH}/$1.mk
echo "define ${1^^}_BUILD_CMDS" >> ${PATH}/$1.mk
echo "    \$(MAKE) CC=\"\$(TARGET_CC)\" LD=\"\$(TARGET_LD)\" CFLAGS=\"\$(TARGET_CFLAGS)\" -C \$(@D) all" >> ${PATH}/$1.mk
echo "endef" >> ${PATH}/$1.mk
echo "" >> ${PATH}/$1.mk
echo "define ${1^^}_INSTALL_TARGET_CMDS" >> ${PATH}/$1.mk
echo "    \$(INSTALL) -D -m 0755 \$(@D)/${1} \$(TARGET_DIR)/bin" >> ${PATH}/$1.mk
echo "endef" >> ${PATH}/$1.mk
echo "" >> ${PATH}/$1.mk
echo "define ${1^^}_PERMISSIONS" >> ${PATH}/$1.mk
echo "    /bin/${1} f 4755 0 0 - - - - - " >> ${PATH}/$1.mk
echo "endef" >> ${PATH}/$1.mk
echo "" >> ${PATH}/$1.mk
echo "\$(eval \$(generic-package))" >> ${PATH}/$1.mk

rm ${BUILDROOT_DIR}/.config
echo "Type n in 1 sec"
./scripts/build.sh &> /dev/null