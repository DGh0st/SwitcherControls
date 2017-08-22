#import "headers.h"

#define identifier @"com.dgh0st.switchercontrols"
#define kSettingsPath @"/var/mobile/Library/Preferences/com.dgh0st.switchercontrols.plist"

@implementation SCPreferences
+(id)sharedInstance {
	static SCPreferences *sharedObject = nil;
	static dispatch_once_t token = 0;
	dispatch_once(&token, ^{
		sharedObject = [self new];
	});
	return sharedObject;
}

-(id)init {
	self = [super init];
	if (self != nil) {
		prefs = nil;
		_topSection = [NSArray arrayWithObjects:@"Quick Launch Shortcuts", nil];
		_bottomStickySection = [NSArray arrayWithObjects:@"Settings Toggles", nil];
		_bottomSection = [NSArray arrayWithObjects:@"Brightness Slider", @"NightShift And AirPlay/Drop", nil];

		[self updatePreferences];
		[self updateSectionPreferences];
		[self updateLayoutChangePreferences];
	}
	return self;
}

-(void)dealloc {
	if (prefs != nil) {
		[prefs release];
		prefs = nil;
	}

	[super dealloc];
}

-(void)updatePreferences {
	if (prefs != nil) {
		[prefs release];
		prefs = nil;
	}

	CFPreferencesAppSynchronize(CFSTR("com.dgh0st.switchercontrols"));

	if ([NSHomeDirectory() isEqualToString:@"/var/mobile"]) {
		CFArrayRef keyList = CFPreferencesCopyKeyList((CFStringRef)identifier, kCFPreferencesCurrentUser, kCFPreferencesAnyHost);
		if (keyList) {
			prefs = (NSMutableDictionary *)CFPreferencesCopyMultiple(keyList, (CFStringRef)identifier, kCFPreferencesCurrentUser, kCFPreferencesAnyHost);
			if (!prefs) {
				prefs = [NSMutableDictionary new];
			}
			CFRelease(keyList);
		}
	} else {
		prefs = [NSMutableDictionary dictionaryWithContentsOfFile:kSettingsPath];
	}

	_isTweakEnabled = [prefs objectForKey:@"isEnabled"] ? [[prefs objectForKey:@"isEnabled"] boolValue] : YES;
	_isReplaceCCEnabled = [prefs objectForKey:@"isReplaceCCEnabled"] ? [[prefs objectForKey:@"isReplaceCCEnabled"] boolValue] : NO;
	_animationSpeed = [prefs objectForKey:@"animationSpeed"] ? [[prefs objectForKey:@"animationSpeed"] floatValue] : 0.25;
	_defaultPage = [prefs objectForKey:@"defaultPage"] ? [[prefs objectForKey:@"defaultPage"] intValue] : -1;
	_isMediaPageOnPlayingEnabled = [prefs objectForKey:@"isMediaPageOnPlayingEnabled"] ? [[prefs objectForKey:@"isMediaPageOnPlayingEnabled"] boolValue] : YES;
	_portraitScale = [prefs objectForKey:@"portraitScale"] ? [[prefs objectForKey:@"portraitScale"] floatValue] : 0.83;
	_landscapeScale = [prefs objectForKey:@"landscapeScale"] ? [[prefs objectForKey:@"landscapeScale"] floatValue] : 0.60;
	_isInteractiveCCEnabled = [prefs objectForKey:@"isInteractiveCCEnabled"] ? [[prefs objectForKey:@"isInteractiveCCEnabled"] boolValue] : NO;
	_isScaleIconLabelsEnabled = [prefs objectForKey:@"isScaleIconLabelsEnabled"] ? [[prefs objectForKey:@"isScaleIconLabelsEnabled"] boolValue] : YES;

	if (_isRemoveMediaAndDevicesPagesEnabled && (_defaultPage == 1 || _defaultPage == 2))
		_defaultPage = -1;
	else if (_isRemoveDevicesPagesEnabled && _defaultPage == 2)
		_defaultPage = -1;
}

-(void)updateLayoutChangePreferences {
	if (prefs != nil) {
		[prefs release];
		prefs = nil;
	}

	CFPreferencesAppSynchronize(CFSTR("com.dgh0st.switchercontrols"));

	if ([NSHomeDirectory() isEqualToString:@"/var/mobile"]) {
		CFArrayRef keyList = CFPreferencesCopyKeyList((CFStringRef)identifier, kCFPreferencesCurrentUser, kCFPreferencesAnyHost);
		if (keyList) {
			prefs = (NSMutableDictionary *)CFPreferencesCopyMultiple(keyList, (CFStringRef)identifier, kCFPreferencesCurrentUser, kCFPreferencesAnyHost);
			if (!prefs) {
				prefs = [NSMutableDictionary new];
			}
			CFRelease(keyList);
		}
	} else {
		prefs = [NSMutableDictionary dictionaryWithContentsOfFile:kSettingsPath];
	}

	_requiresRelayout = YES;
	_blurStyle = [prefs objectForKey:@"blurStyle"] ? [[prefs objectForKey:@"blurStyle"] intValue] : 2020;
	_backgroundGrayness = [prefs objectForKey:@"backgroundGrayness"] ? [[prefs objectForKey:@"backgroundGrayness"] floatValue] : 0.0;
	_isRemoveMediaAndDevicesPagesEnabled = [prefs objectForKey:@"isRemoveMediaAndDevicesPagesEnabled"] ? [[prefs objectForKey:@"isRemoveMediaAndDevicesPagesEnabled"] boolValue] : NO;
	_isRemoveDevicesPagesEnabled = [prefs objectForKey:@"isRemoveDevicesPagesEnabled"] ? [[prefs objectForKey:@"isRemoveDevicesPagesEnabled"] boolValue] : NO;
	_isPortraitNightAndAirLabelsHidden = [prefs objectForKey:@"isPortraitNightAndAirLabelsHidden"] ? [[prefs objectForKey:@"isPortraitNightAndAirLabelsHidden"] boolValue] : NO;
	_isLandscapeNightAndAirLabelsHidden = [prefs objectForKey:@"isLandscapeNightAndAirLabelsHidden"] ? [[prefs objectForKey:@"isLandscapeNightAndAirLabelsHidden"] boolValue] : NO;
	_portraitTopHeight = [prefs objectForKey:@"portraitTopHeight"] ? [[prefs objectForKey:@"portraitTopHeight"] floatValue] : 98;
	_landscapeTopHeight = [prefs objectForKey:@"landscapeTopHeight"] ? [[prefs objectForKey:@"landscapeTopHeight"] floatValue] : 78;
	_portraitBottomHeight = [prefs objectForKey:@"portraitBottomHeight"] ? [[prefs objectForKey:@"portraitBottomHeight"] floatValue] : 98;
	_landscapeBottomHeight = [prefs objectForKey:@"landscapeBottomHeight"] ? [[prefs objectForKey:@"landscapeBottomHeight"] floatValue] : 98;
	_multiSliderBackgroundAlpha = [prefs objectForKey:@"multiSliderBackgroundAlpha"] ? [[prefs objectForKey:@"multiSliderBackgroundAlpha"] floatValue] : 0.06;
	_isCompactSlidersEnabled = [prefs objectForKey:@"isCompactSlidersEnabled"] ? [[prefs objectForKey:@"isCompactSlidersEnabled"] boolValue] : NO;
	_portraitOffset = ([prefs objectForKey:@"portraitOffset"] ? [[prefs objectForKey:@"portraitOffset"] floatValue] : 0.5) - 0.5;
	_landscapeOffset  = ([prefs objectForKey:@"landscapeOffset"] ? [[prefs objectForKey:@"landscapeOffset"] floatValue] : 0.5) - 0.5;

	if (_isRemoveMediaAndDevicesPagesEnabled && (_defaultPage == 1 || _defaultPage == 2))
		_defaultPage = -1;
	else if (_isRemoveDevicesPagesEnabled && _defaultPage == 2)
		_defaultPage = -1;
}

-(void)updateSectionPreferences {
	if (prefs != nil) {
		[prefs release];
		prefs = nil;
	}

	CFPreferencesAppSynchronize(CFSTR("com.dgh0st.switchercontrols"));

	if ([NSHomeDirectory() isEqualToString:@"/var/mobile"]) {
		CFArrayRef keyList = CFPreferencesCopyKeyList((CFStringRef)identifier, kCFPreferencesCurrentUser, kCFPreferencesAnyHost);
		if (keyList) {
			prefs = (NSMutableDictionary *)CFPreferencesCopyMultiple(keyList, (CFStringRef)identifier, kCFPreferencesCurrentUser, kCFPreferencesAnyHost);
			if (!prefs) {
				prefs = [NSMutableDictionary new];
			}
			CFRelease(keyList);
		}
	} else {
		prefs = [NSMutableDictionary dictionaryWithContentsOfFile:kSettingsPath];
	}

	NSArray *topSection = [prefs objectForKey:@"TopSection"] ?: nil;
	NSArray *bottomStickySection = [prefs objectForKey:@"BottomStickySection"] ?: nil;
	NSArray *bottomSection = [prefs objectForKey:@"BottomSections"] ?: nil;

	_requiresRelayout = YES;
	if (topSection == nil && bottomStickySection == nil && bottomSection == nil) {
		_topSection = [NSArray arrayWithObjects:@"Quick Launch Shortcuts", nil];
		_bottomStickySection = [NSArray arrayWithObjects:@"Settings Toggles", nil];
		_bottomSection = [NSArray arrayWithObjects:@"Brightness Slider", @"NightShift And AirPlay/Drop", nil];
	} else {
		_topSection = topSection ?: [NSArray array];
		_bottomStickySection = bottomStickySection ?: [NSArray array];
		_bottomSection = bottomSection ?: [NSArray array];
	}
}

-(BOOL)isAppDisabled:(NSString *)appId {
	BOOL result = NO;
	NSString *prefix = @"Disabled-";
	NSArray *allKeys = (NSArray *)CFPreferencesCopyKeyList(CFSTR("com.dgh0st.switchercontrols"), kCFPreferencesCurrentUser, kCFPreferencesCurrentHost);
	for (NSString *key in allKeys) {
		if ([key hasPrefix:prefix] && CFPreferencesGetAppIntegerValue((CFStringRef)key, CFSTR("com.dgh0st.switchercontrols"), NULL)) {
			NSString *tempId = [key substringFromIndex:[prefix length]];
			if ([tempId isEqual:appId]) {
				NSNumber *value = (__bridge NSNumber *)CFPreferencesCopyAppValue((CFStringRef)key, (CFStringRef)identifier);
				result = value ? [value boolValue] : NO;
				[value release];
				break;
			}
		}
	}
	[allKeys release];
	return result;
}

-(Class)classForSection:(NSString *)section {
	if ([section isEqualToString:@"Quick Launch Shortcuts"])
		return [ControlCenterQuickLaunchSectionView class];
	else if ([section isEqualToString:@"Settings Toggles"])
		return [ControlCenterSettingsSectionView class];
	else if ([section isEqualToString:@"Brightness Slider"])
		return [ControlCenterBrightnessSectionView class];
	else if ([section isEqualToString:@"Volume Slider"])
		return [ControlCenterVolumeSectionView class];
	else if ([section isEqualToString:@"NightShift And AirPlay/Drop"])
		return [ControlCenterNightAndAirPlaySectionView class];
	else if ([section isEqualToString:@"Multi Slider"])
		return [ControlCenterBrightnessVolumeSectionView class];
	else if ([section isEqualToString:@"NightShift"])
		return [ControlCenterNightSectionView class];
	else if ([section isEqualToString:@"AirPlay/Drop"])
		return [ControlCenterAirPlaySectionView class];
	else
		return [ControlCenterFailureSectionClass class];
}

-(Class)sectionClass:(SectionPosition)position withIndex:(NSInteger)index {
	if (position == kTop) {
		if (_topSection != nil && [_topSection count] == 0)
			return [ControlCenterFailureSectionClass class];
		return [self classForSection:[_topSection objectAtIndex:0]];
	} else if (position == kBottomSticky) {
		if (_bottomStickySection != nil && [_bottomStickySection count] == 0)
			return [ControlCenterFailureSectionClass class];
		return [self classForSection:[_bottomStickySection objectAtIndex:0]];
	} else if (position == kBottom) {
		if (_bottomSection != nil && ([_bottomSection count] <= index || [_bottomSection count] == 0))
			return [ControlCenterFailureSectionClass class];
		return [self classForSection:[_bottomSection objectAtIndex:index]];
	}
	return [ControlCenterFailureSectionClass class];
}
@end

@implementation ControlCenterFailureSectionClass
@end