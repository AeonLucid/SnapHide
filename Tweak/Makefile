# ARCHS = armv7 armv7s arm64 arm64e
ARCHS = arm64 arm64e
TARGET = iphone:clang:11.2:9.0
# GO_EASY_ON_ME = 1

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = 0SnapHide

0SnapHide_FILES = Tweak.xm
0SnapHide_FILES += Utils/memory.xm
0SnapHide_FILES += Utils/strings.xm
0SnapHide_FILES += Utils/process.xm
0SnapHide_FILES += Detections/dyld.xm
0SnapHide_FILES += Detections/symbols.xm
0SnapHide_FILES += Detections/classes.xm
0SnapHide_FILES += Detections/files.xm
0SnapHide_FILES += Detections/codesign.xm
0SnapHide_FILES += Detections/methods.xm
0SnapHide_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
