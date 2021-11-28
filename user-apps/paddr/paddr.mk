PADDR_VERSION:= 1.0.0
PADDR_SITE:= $(TOPDIR)/../user-apps/paddr/src
PADDR_SITE_METHOD:=local
PADDR_INSTALL_TARGET:=YES

define PADDR_BUILD_CMDS
	$(MAKE) CC="$(TARGET_CC)" LD="$(TARGET_LD)" CFLAGS="$(TARGET_CFLAGS)" -C $(@D) all
endef

define PADDR_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/paddr $(TARGET_DIR)/bin
endef

define PADDR_PERMISSIONS
    /bin/paddr f 4755 0 0 - - - - - 
endef

$(eval $(generic-package))