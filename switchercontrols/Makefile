export ARCHS = armv7 arm64
export TARGET = iphone:clang:8.1:latest

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = SwitcherControls
SwitcherControls_FILES = SCCRootListController.xm
SwitcherControls_INSTALL_PATH = /Library/PreferenceBundles
SwitcherControls_FRAMEWORKS = UIKit MessageUI
SwitcherControls_PRIVATE_FRAMEWORKS = Preferences
SwitcherControls_LIBRARIES = applist

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/SwitcherControls.plist$(ECHO_END)
