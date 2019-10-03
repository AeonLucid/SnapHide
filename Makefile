# INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

SUBPROJECTS += Tweak

include $(THEOS_MAKE_PATH)/aggregate.mk
