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

PATH = kernel-modules/$1

mkdir ${PATH}
mkdir ${PATH}/src
touch ${PATH}/Config.in
touch ${PATH}/$1.mk

echo "config BR2_PACKAGE_${1^^}" >> ${PATH}/Config.in
echo "    bool \"$1\"" >> ${PATH}/Config.in
echo "    depends on BR2_LINUX_KERNEL"
echo "    default y" >> ${PATH}/Config.in
echo "    help" >> ${PATH}/Config.in
echo "     Enter short description here" >> ${PATH}/Config.in

echo "${1^^}_VERSION:= 1.0.0" >> ${PATH}/$1.mk
echo "${1^^}_SITE:= \$(TOPDIR)/../${PATH}/src" >> ${PATH}/$1.mk
echo "${1^^}_SITE_METHOD:=local" >> ${PATH}/$1.mk
echo "" >> ${PATH}/$1.mk
echo "\$(eval \$(kernel-module))" >> ${PATH}/$1.mk
echo "\$(eval \$(generic-package))" >> ${PATH}/$1.mk