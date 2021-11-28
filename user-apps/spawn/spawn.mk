SPAWN_VERSION:= 1.0.0
SPAWN_SITE:= $(TOPDIR)/../user-apps/spawn/src
SPAWN_SITE_METHOD:=local
SPAWN_INSTALL_TARGET:=YES

define SPAWN_BUILD_CMDS
	$(MAKE) CC="$(TARGET_CC)" LD="$(TARGET_LD)" CFLAGS="$(TARGET_CFLAGS)" -C $(@D) all
endef

define SPAWN_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/spawn $(TARGET_DIR)/bin
endef

define SPAWN_PERMISSIONS
    /bin/spawn f 4755 0 0 - - - - - 
endef

$(eval $(generic-package))