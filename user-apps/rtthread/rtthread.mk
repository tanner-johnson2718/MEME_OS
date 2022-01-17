RTTHREAD_VERSION:= 1.0.0
RTTHREAD_SITE:= $(TOPDIR)/../user-apps/rtthread/src
RTTHREAD_SITE_METHOD:=local
RTTHREAD_INSTALL_TARGET:=YES

define RTTHREAD_BUILD_CMDS
	$(MAKE) CC="$(TARGET_CC)" LD="$(TARGET_LD)" CFLAGS="$(TARGET_CFLAGS)" -C $(@D) all
endef

define RTTHREAD_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/rtthread $(TARGET_DIR)/bin
endef

define RT-THREAD_PERMISSIONS
    /bin/rtthread f 4755 0 0 - - - - - 
endef

$(eval $(generic-package))