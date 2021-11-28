PADDR-PARSER_VERSION:= 1.0.0
PADDR-PARSER_SITE:= $(TOPDIR)/../user-apps/hello/src
PADDR-PARSER_SITE_METHOD:=local
PADDR-PARSER_INSTALL_TARGET:=YES

define PADDR-PARSER_BUILD_CMDS
	$(MAKE) CC="$(TARGET_CC)" LD="$(TARGET_LD)" CFLAGS="$(TARGET_CFLAGS)" -C $(@D) all
endef

define PADDR-PARSER_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/hello $(TARGET_DIR)/bin
endef

define PADDR-PARSER_PERMISSIONS
    /bin/hello f 4755 0 0 - - - - - 
endef

$(eval $(generic-package))