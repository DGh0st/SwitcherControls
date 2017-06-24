#import "headers.h"
#import "NSArray+CompareAddition.h"

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
		_topSection = [NSArray arrayWithObjects:@"Quick Launch Shortcuts", nil];
		_bottomStickySection = [NSArray arrayWithObjects:@"Settings Toggles", nil];
		_bottomSection = [NSArray arrayWithObjects:@"Brightness Slider", @"NightShift And AirPlay/Drop", nil];
		_isBottomSectionBigger = NO;

		[self updatePreferences];
	}
	return self;
}

-(void)updatePreferences {
	CFPreferencesAppSynchronize(CFSTR("com.dgh0st.switchercontrols"));

	NSDictionary *prefs = nil;
	if ([NSHomeDirectory() isEqualToString:@"/var/mobile"]) {
		CFArrayRef keyList = CFPreferencesCopyKeyList((CFStringRef)identifier, kCFPreferencesCurrentUser, kCFPreferencesAnyHost);
		if (keyList) {
			prefs = (NSDictionary *)CFPreferencesCopyMultiple(keyList, (CFStringRef)identifier, kCFPreferencesCurrentUser, kCFPreferencesAnyHost);
			if (!prefs) {
				prefs = [NSDictionary new];
			}
			CFRelease(keyList);
		}
	} else {
		prefs = [NSDictionary dictionaryWithContentsOfFile:kSettingsPath];
	}

	/*if (prefs == nil) {
		_requiresRelayout = YES;
		_isTweakEnabled = YES;
		_isReplaceCCEnabled = NO;
		_blurStyle = UIBlurEffectStyleLight;
		_animationSpeed = 0.25;
		_defaultPage = -1;
		_isMediaPageOnPlayingEnabled = YES;
		_portraitScale = 0.83;
		_landscapeScale = 0.60;
		_portraitTopHeight = 98;
		_landscapeTopHeight = 78;
		_portraitBottomHeight = 98;
		_landscapeBottomHeight = 98;
		_isPortraitNightAndAirLabelsHidden = NO;
		_isLandscapeNightAndAirLabelsHidden = NO;
		_topSection = [NSArray arrayWithObjects:@"Quick Launch Shortcuts", nil];
		_bottomStickySection = [NSArray arrayWithObjects:@"Settings Toggles", nil];
		_bottomSection = [NSArray arrayWithObjects:@"Brightness Slider", @"NightShift And AirPlay/Drop", nil];
		_isBottomSectionBigger = NO;
		_isInteractiveCCEnabled = NO;
		_multiSliderBackgroundAlpha = 0.06;
		_isScaleIconLabelsEnabled = YES;
		return;
	}*/

	_requiresRelayout = _requiresRelayout ?: NO;

	_isTweakEnabled = [prefs objectForKey:@"isEnabled"] ? [[prefs objectForKey:@"isEnabled"] boolValue] : YES;
	_isReplaceCCEnabled = [prefs objectForKey:@"isReplaceCCEnabled"] ? [[prefs objectForKey:@"isReplaceCCEnabled"] boolValue] : NO;

	#define kNumEffects 3
	NSString *blurStyles[kNumEffects] = {@"ExtraLight", @"Light", @"Dark"};
	UIBlurEffectStyle blurEffects[kNumEffects] = {UIBlurEffectStyleExtraLight, UIBlurEffectStyleLight, UIBlurEffectStyleDark};

	NSString *blur = [prefs objectForKey:@"blurStyle"] ?: nil;
	UIBlurEffectStyle blurStyle = UIBlurEffectStyleLight;
	if (blur != nil) {
		for (NSInteger i = 0; i < kNumEffects; i++)
			if ([blur isEqualToString:blurStyles[i]])
				blurStyle = blurEffects[i];
	} else {
		blurStyle = UIBlurEffectStyleLight;
	}

	if (blurStyle != _blurStyle)
		_requiresRelayout = YES;

	_blurStyle = blurStyle;

	_animationSpeed = [prefs objectForKey:@"animationSpeed"] ? [[prefs objectForKey:@"animationSpeed"] floatValue] : 0.25;
	_defaultPage = [prefs objectForKey:@"defaultPage"] ? [[prefs objectForKey:@"defaultPage"] intValue] : -1;
	_isMediaPageOnPlayingEnabled = [prefs objectForKey:@"isMediaPageOnPlayingEnabled"] ? [[prefs objectForKey:@"isMediaPageOnPlayingEnabled"] boolValue] : YES;
	_portraitScale = [prefs objectForKey:@"portraitScale"] ? [[prefs objectForKey:@"portraitScale"] floatValue] : 0.83;
	_landscapeScale = [prefs objectForKey:@"landscapeScale"] ? [[prefs objectForKey:@"landscapeScale"] floatValue] : 0.60;
	
	CGFloat portraitTopHeight = [prefs objectForKey:@"portraitTopHeight"] ? [[prefs objectForKey:@"portraitTopHeight"] floatValue] : 98;
	CGFloat landscapeTopHeight = [prefs objectForKey:@"landscapeTopHeight"] ? [[prefs objectForKey:@"landscapeTopHeight"] floatValue] : 78;
	CGFloat portraitBottomHeight = [prefs objectForKey:@"portraitBottomHeight"] ? [[prefs objectForKey:@"portraitBottomHeight"] floatValue] : 98;
	CGFloat landscapeBottomHeight = [prefs objectForKey:@"landscapeBottomHeight"] ? [[prefs objectForKey:@"landscapeBottomHeight"] floatValue] : 98;
	
	if (portraitTopHeight != _portraitTopHeight || landscapeTopHeight != _landscapeTopHeight || portraitBottomHeight != _portraitBottomHeight || landscapeBottomHeight != _landscapeBottomHeight)
		_requiresRelayout = YES;

	_portraitTopHeight = portraitTopHeight;
	_landscapeTopHeight = landscapeTopHeight;
	_portraitBottomHeight = portraitBottomHeight;
	_landscapeBottomHeight = landscapeBottomHeight;

	BOOL isPortraitNightAndAirLabelsHidden = [prefs objectForKey:@"isPortraitNightAndAirLabelsHidden"] ? [[prefs objectForKey:@"isPortraitNightAndAirLabelsHidden"] boolValue] : NO;
	BOOL isLandscapeNightAndAirLabelsHidden = [prefs objectForKey:@"isLandscapeNightAndAirLabelsHidden"] ? [[prefs objectForKey:@"isLandscapeNightAndAirLabelsHidden"] boolValue] : NO;

	if (isPortraitNightAndAirLabelsHidden != _isPortraitNightAndAirLabelsHidden || isLandscapeNightAndAirLabelsHidden != _isLandscapeNightAndAirLabelsHidden)
		_requiresRelayout = YES;

	_isPortraitNightAndAirLabelsHidden = isPortraitNightAndAirLabelsHidden;
	_isLandscapeNightAndAirLabelsHidden = isLandscapeNightAndAirLabelsHidden;

	NSArray *topSection = [prefs objectForKey:@"TopSection"] ?: nil;
	NSArray *bottomStickySection = [prefs objectForKey:@"BottomStickySection"] ?: nil;
	NSArray *bottomSection = [prefs objectForKey:@"BottomSections"] ?: nil;

	if (topSection == nil || ![topSection isOrderEqual:_topSection] || bottomStickySection == nil || ![bottomStickySection isOrderEqual:_bottomStickySection] || bottomSection == nil || ![bottomSection isOrderEqual:_bottomSection])
		_requiresRelayout = YES;

	_topSection = (topSection == nil) ? [NSArray arrayWithObjects:@"Quick Launch Shortcuts", nil] : topSection;
	_bottomStickySection = (bottomStickySection == nil) ? [NSArray arrayWithObjects:@"Settings Toggles", nil] : bottomStickySection;
	_bottomSection = (bottomSection == nil) ? [NSArray arrayWithObjects:@"Brightness Slider", @"NightShift And AirPlay/Drop", nil] : bottomSection;

	_isBottomSectionBigger = (_bottomSection != nil && [_bottomSection count] == 3);

	_isInteractiveCCEnabled = [prefs objectForKey:@"isInteractiveCCEnabled"] ? [[prefs objectForKey:@"isInteractiveCCEnabled"] boolValue] : NO;

	CGFloat multiSliderBackgroundAlpha = [prefs objectForKey:@"multiSliderBackgroundAlpha"] ? [[prefs objectForKey:@"multiSliderBackgroundAlpha"] floatValue] : 0.06;

	if (multiSliderBackgroundAlpha != _multiSliderBackgroundAlpha)
		_requiresRelayout = YES;

	_multiSliderBackgroundAlpha = multiSliderBackgroundAlpha;

	_isScaleIconLabelsEnabled = [prefs objectForKey:@"isScaleIconLabelsEnabled"] ? [[prefs objectForKey:@"isScaleIconLabelsEnabled"] boolValue] : YES;
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
	else
		return [ControlCenterFailureSectionClass class];
}

-(Class)sectionClass:(SectionPosition)position withIndex:(NSInteger)index {
	[self updatePreferences];

	if (position == kTop) {
		if ([_topSection count] == 0)
			return [ControlCenterFailureSectionClass class];
		return [self classForSection:[_topSection objectAtIndex:0]];
	} else if (position == kBottomSticky) {
		if ([_bottomStickySection count] == 0)
			return [ControlCenterFailureSectionClass class];
		return [self classForSection:[_bottomStickySection objectAtIndex:0]];
	} else if (position == kBottom) {
		if ([_bottomSection count] <= index)
			return [ControlCenterFailureSectionClass class];
		return [self classForSection:[_bottomSection objectAtIndex:index]];
	}
	return [ControlCenterFailureSectionClass class];
}
@end

@implementation ControlCenterFailureSectionClass
@end