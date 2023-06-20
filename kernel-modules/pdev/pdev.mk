PDEV_VERSION:= 1.0.0
PDEV_SITE:= $(TOPDIR)/../kernel-modules/pdev/src
PDEV_SITE_METHOD:=local

$(eval $(kernel-module))
$(eval $(generic-package))
