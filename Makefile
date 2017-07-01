export ARCHS = armv7 arm64
export TARGET = iphone:clang:latest:latest

PACKAGE_VERSION = 1.0-1

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = SwitcherControls
SwitcherControls_FILES = $(wildcard *.xm)
SwitcherControls_FRAMEWORKS = UIKit CoreGraphics QuartzCore

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += switchercontrols
include $(THEOS_MAKE_PATH)/aggregate.mk
