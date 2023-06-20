SYSCALL_VERSION:= 1.0.0
SYSCALL_SITE:= $(TOPDIR)/../user-apps/syscall/src
SYSCALL_SITE_METHOD:=local
SYSCALL_INSTALL_TARGET:=YES

define SYSCALL_BUILD_CMDS
    $(MAKE) CC="$(TARGET_CC)" LD="$(TARGET_LD)" CFLAGS="$(TARGET_CFLAGS)" -C $(@D) all
endef

define SYSCALL_INSTALL_TARGET_CMDS
    $(INSTALL) -D -m 0755 $(@D)/syscall $(TARGET_DIR)/bin
endef

define SYSCALL_PERMISSIONS
    /bin/syscall f 4755 0 0 - - - - - 
endef

$(eval $(generic-package))
