#import <objc/runtime.h>

static CGSize screenSize = [[UIScreen mainScreen] bounds].size;

typedef enum {
	kTop,
	kBottomSticky,
	kBottom
} SectionPosition;

@interface SCPreferences : NSObject {
	NSMutableDictionary *prefs;
}
@property (nonatomic, assign, readonly) BOOL isTweakEnabled;
@property (nonatomic, assign, readonly) BOOL isReplaceCCEnabled;
@property (nonatomic, assign, readonly) NSInteger blurStyle;
@property (nonatomic, assign, readonly) CGFloat animationSpeed;
@property (nonatomic, assign, readonly) CGFloat backgroundGrayness;
@property (nonatomic, assign, readonly) NSInteger defaultPage;
@property (nonatomic, assign, readonly) BOOL isRemoveMediaAndDevicesPagesEnabled;
@property (nonatomic, assign, readonly) BOOL isRemoveDevicesPagesEnabled;
@property (nonatomic, assign, readonly) BOOL isMediaPageOnPlayingEnabled;
@property (nonatomic, assign, readonly) CGFloat portraitScale;
@property (nonatomic, assign, readonly) CGFloat landscapeScale;
@property (nonatomic, assign, readonly) CGFloat portraitTopHeight;
@property (nonatomic, assign, readonly) CGFloat landscapeTopHeight;
@property (nonatomic, assign, readonly) CGFloat portraitBottomHeight;
@property (nonatomic, assign, readonly) CGFloat landscapeBottomHeight;
@property (nonatomic, assign, readonly) BOOL isPortraitNightAndAirLabelsHidden;
@property (nonatomic, assign, readonly) BOOL isLandscapeNightAndAirLabelsHidden;
@property (nonatomic, assign, readonly) CGFloat backgroundAlpha;
@property (nonatomic, assign, readonly) NSArray *topSection;
@property (nonatomic, assign, readonly) NSArray *bottomStickySection;
@property (nonatomic, assign, readonly) NSArray *bottomSection;
@property (nonatomic, assign, readonly) BOOL isInteractiveCCEnabled;
@property (nonatomic, assign, readonly) BOOL isScaleIconLabelsEnabled;
@property (nonatomic, assign, readonly) CGFloat multiSliderBackgroundAlpha;
@property (nonatomic, assign, readonly) BOOL isCompactSlidersEnabled;
@property (nonatomic, assign, readonly) CGFloat portraitOffset;
@property (nonatomic, assign, readonly) CGFloat landscapeOffset;
@property (nonatomic, assign) BOOL requiresRelayout;
+(SCPreferences *)sharedInstance;
-(void)updatePreferences;
-(void)updateLayoutChangePreferences;
-(void)updateSectionPreferences;
-(Class)classForSection:(NSString *)section;
-(Class)sectionClass:(SectionPosition)position withIndex:(NSInteger)index;
-(BOOL)isAppDisabled:(NSString *)appId;
@end

@interface ControlCenterBottomScrollView : UIScrollView
-(void)resetupScrollWidth:(BOOL)playing;
-(void)scrollToPage:(NSInteger)page animated:(BOOL)animated;
-(NSInteger)currentVisiblePage;
-(NSInteger)mediaPage;
-(NSInteger)defaultPage;
@end

@interface SBControlCenterController
@property (assign,getter=isUILocked,nonatomic) BOOL UILocked;
@property (assign,getter=isPresented,nonatomic) BOOL presented;
-(void)_showControlCenterGestureCancelled;
-(CGFloat)_controlCenterHeightForTouchLocation:(CGPoint)arg1 initialTouchLocation:(CGPoint)arg2;
@end

@interface SBDisplayItem : NSObject
@property (nonatomic,copy,readonly) NSString * displayIdentifier;
@end

@interface SBDeckSwitcherItemContainer : UIView
@property (assign,nonatomic) double titleOpacity;
@end

@interface SBAppSwitcherScrollView : UIScrollView
@end

@interface SBDeckSwitcherViewController : UIViewController
@property (nonatomic,copy) NSArray * displayItems;
@property (setter=_setReturnToDisplayItem:,nonatomic,copy) SBDisplayItem * _returnToDisplayItem;
-(SBDeckSwitcherItemContainer *)_itemContainerForDisplayItem:(SBDisplayItem *)arg1;
-(void)startInteractiveTransition:(BOOL)arg1 presenting:(BOOL)arg2 withRequest:(id)arg3;
-(void)animateAppearance;
-(void)animateDisappearance;
-(void)panBottomView:(id)arg1;
-(void)interactiveAppearance:(CGFloat)arg1 didEnd:(BOOL)arg2;
@end

@interface SBMainSwitcherViewController
+(id)sharedInstance;
-(BOOL)activateSwitcherNoninteractively;
-(BOOL)dismissSwitcherNoninteractively;
@end

@interface CCUIControlCenterStatusUpdate : NSObject
@property (nonatomic,copy) NSArray *statusStrings;
@end

@protocol CCUIControlCenterSectionViewControllerDelegate <NSObject>
@required
-(NSInteger)layoutStyle;
-(void)noteSectionEnabledStateDidChange:(id)arg1;
-(void)section:(id)arg1 publishStatusUpdate:(id)arg2;
-(void)sectionWantsControlCenterDismissal:(id)arg1;
-(id)controlCenterSystemAgent;
-(void)beginSuppressingPunchOutMaskCachingForReason:(id)arg1;
-(void)endSuppressingPunchOutMaskCachingForReason:(id)arg1;
@end

@protocol CCUIControlCenterButtonDelegate <NSObject>
@optional
-(void)button:(id)arg1 didChangeState:(NSInteger)arg2;
@required
-(void)buttonTapped:(id)arg1;
-(BOOL)isInternal;
-(id)controlCenterSystemAgent;
@end

@interface ControlCenterSectionView : UIView <CCUIControlCenterSectionViewControllerDelegate>
@end

@interface CCUIControlCenterSectionView : UIView
@property (assign,nonatomic) NSInteger layoutStyle;
@end

@interface CCUIControlCenterSectionViewController : UIViewController
-(void)setDelegate:(id<CCUIControlCenterSectionViewControllerDelegate>)arg1;
@end

@interface CCUIButtonSectionController : CCUIControlCenterSectionViewController
@end

@interface CCUISettingsSectionController : CCUIButtonSectionController
@end

@interface ControlCenterSettingsSectionView : ControlCenterSectionView {
	CCUISettingsSectionController *_settingsController;
}
@end

@interface CCUIQuickLaunchSectionController : CCUIButtonSectionController
@end

@interface ControlCenterQuickLaunchSectionView : ControlCenterSectionView {
	CCUIQuickLaunchSectionController *_quickLaunchController;
}
@end

@interface CCUIBrightnessContentView : CCUIControlCenterSectionView
@end

@interface CCUIBrightnessSectionController : CCUIControlCenterSectionViewController
-(void)setUsesCompactHeight:(BOOL)arg1;
@end

@interface ControlCenterBrightnessSectionView : ControlCenterSectionView {
	CCUIBrightnessSectionController *_brightnessController;
}
-(id)slider;
-(void)addButton:(UIButton *)button target:(id)target action:(SEL)selector isMin:(BOOL)isMin;
@end

@interface SBFButton : UIButton
@end

@interface CCUIControlCenterButton : SBFButton
@end

@interface CCUIControlCenterPushButton : CCUIControlCenterButton
@property (assign,nonatomic) NSUInteger roundCorners;
@property (assign,nonatomic) NSInteger numberOfLines;
-(void)_updateGlyphAndTextForStateChange;
@end

@interface CCUINightShiftContentView : UIView
-(CCUIControlCenterPushButton *)button;
@end

@interface CCUINightShiftSectionController : CCUIControlCenterSectionViewController <CCUIControlCenterButtonDelegate>
-(CCUINightShiftContentView *)view;
@end

@interface CCUIAirStuffSectionController : CCUIControlCenterSectionViewController {
	CCUIControlCenterPushButton *_airPlaySection;
	CCUIControlCenterPushButton* _airDropSection;
	UIAlertController* _airDropAlertController;
}
@end

@interface LQDNightSectionController : CCUIControlCenterSectionViewController
-(CCUIControlCenterPushButton *)nightModeSection;
-(CCUIControlCenterPushButton *)nightShiftSection;
@end

@interface OGYNightSectionController : CCUIControlCenterSectionViewController
-(CCUIControlCenterPushButton *)nightModeSection;
-(CCUIControlCenterPushButton *)nightShiftSection;
@end

@interface ControlCenterNightAndAirPlaySectionView : ControlCenterSectionView {
	CCUINightShiftSectionController *_nightShiftController;
	CCUIAirStuffSectionController *_airPlayController;
	LQDNightSectionController *_noctisController;
	OGYNightSectionController *_ogygiaController;
}
@end

@interface ControlCenterNightSectionView : ControlCenterSectionView {
	CCUINightShiftSectionController *_nightShiftController;
}
@end

@interface ControlCenterAirPlaySectionView : ControlCenterSectionView {
	CCUIAirStuffSectionController *_airPlayController;
}
@end

@interface SBUIController
+(id)sharedInstance;
-(BOOL)isAppSwitcherShowing;
@end

@interface SBApplication : NSObject
-(id)bundleIdentifier;
@end

@interface FBSystemApp : UIApplication
@end

@interface SpringBoard : FBSystemApp
+(id)sharedApplication;
-(UIInterfaceOrientation)activeInterfaceOrientation;
-(UIInterfaceOrientation)interfaceOrientationForCurrentDeviceOrientation;
-(id)_accessibilityFrontMostApplication;
@end

@interface MPULayoutInterpolator : NSObject
-(void)addValue:(CGFloat)arg1 forReferenceMetric:(CGFloat)arg2;
@end

@interface MPUEmptyNowPlayingView : UIButton
@end

@interface MPUNowPlayingMetadataView : UIView
@property (nonatomic,copy) NSAttributedString * attributedText;
@property (assign,nonatomic) BOOL marqueeEnabled;
@property (assign,nonatomic) NSUInteger numberOfLines;
-(UILabel *)label;
@end

@interface MPUControlCenterMetadataView : MPUNowPlayingMetadataView
@end

@interface MPUChronologicalProgressView : UIView
@property (assign,getter=isAlwaysLive,nonatomic) BOOL alwaysLive;
-(void)setTintColor:(id)arg1;
@end

@interface MPUControlCenterTimeView : MPUChronologicalProgressView
@end

@interface MPUTransportControlsView : UIView
@end

@interface MPUAVRouteHeaderView  : UIControl
@end

@interface MPUNowPlayingArtworkView : UIView
@end

@interface MPUMediaControlsVolumeView : UIView
@end

@interface MPAVRoutingViewController : UIViewController
@end

@interface MPUControlCenterMediaControlsView : UIView
@property (nonatomic,readonly) MPUNowPlayingArtworkView * artworkView;
-(void)setLayoutStyle:(NSUInteger)arg1;
-(void)setUseCompactStyle:(BOOL)arg1;
-(void)_reloadNowPlayingInfoLabels;
-(MPUControlCenterTimeView *)timeView;
-(MPUTransportControlsView *)transportControls;
-(MPUMediaControlsVolumeView *)volumeView;
-(MPUNowPlayingArtworkView *)artworkView;
-(MPUEmptyNowPlayingView *)emptyNowPlayingView;
-(void)setupLabelsIfNeeded;
@end

@protocol CCUIControlCenterPageContentViewControllerDelegate <NSObject>
@required
-(NSInteger)layoutStyle;
-(void)contentViewControllerWantsDismissal:(id)arg1;
-(id)controlCenterSystemAgent;
-(void)visibilityPreferenceChangedForContentViewController:(id)arg1;
-(void)beginSuppressingPunchOutMaskCachingForReason:(id)arg1;
-(void)endSuppressingPunchOutMaskCachingForReason:(id)arg1;
@end

@interface MPUControlCenterMediaControlsViewController : UIViewController
-(id)initWithNibName:(id)arg1 bundle:(id)arg2;
-(void)_initControlCenterMediaControlsViewController;
-(MPUControlCenterMediaControlsView *)_mediaControlsView;
-(void)setDelegate:(id<CCUIControlCenterSectionViewControllerDelegate>)arg1;
@end

@interface ControlCenterMediaSectionView : ControlCenterSectionView {
	MPUControlCenterMediaControlsViewController *mediaViewController;
	CGRect routingPageFrame;
}
-(void)setupRoutingPageWithFrame:(CGRect)frame;
@end

@interface SBScreenEdgePanGestureRecognizer : UIScreenEdgePanGestureRecognizer
@end

@interface FBSystemService
+(id)sharedInstance;
-(void)exitAndRelaunch:(BOOL)arg1;
@end

@interface SBMediaController
+(id)sharedInstance;
-(BOOL)isPlaying;
@end

@interface UIAlertController (SwitcherControls)
-(void)setPreferredStyle:(UIAlertActionStyle)arg1;
@end

@interface CCUIControlCenterSlider : UISlider
@end

@interface MPUMarqueeView : UIView
@end

@interface ControlCenterVolumeSectionView : ControlCenterSectionView {
	MPUMediaControlsVolumeView *volumeView;
}
-(id)slider;
-(void)addButton:(UIButton *)button target:(id)target action:(SEL)selector isMin:(BOOL)isMin;
@end

@interface ControlCenterFailureSectionClass : NSObject
@end

@interface SBIconController : UIViewController
+(id)sharedInstance;
-(BOOL)hasAnimatingFolder;
@end

@interface SBSearchGesture : NSObject
@property (getter=isActivated,nonatomic,readonly) BOOL activated; 
+(id)sharedInstance;
@end

@interface SBWorkspace : NSObject
@end

@interface SBAlertManager : NSObject
-(id)activeAlert;
@end

@interface SBWorkspaceTransaction
@end

@interface SBMainWorkspace : SBWorkspace
@property (nonatomic,retain) SBWorkspaceTransaction * currentTransaction;
@property(readonly, nonatomic) SBAlertManager *alertManager;
+(id)sharedInstance;
@end

@interface UIKeyboard : UIView
+(BOOL)isOnScreen;
@end

@interface UIPanGestureRecognizer (SwitcherControls)
-(void)_setCanPanHorizontally:(BOOL)arg1;
@end

@interface UIGestureRecognizer (SwitcherControls)
@end

@interface ControlCenterBrightnessVolumeSectionView : ControlCenterSectionView {
	ControlCenterBrightnessSectionView *_brightnessView;
	ControlCenterVolumeSectionView *_volumeView;
	BOOL isBrightnessVisible;
}
@end

@interface _UIBackdropView : UIView
-(id)initWithFrame:(CGRect)arg1 autosizesToFitSuperview:(BOOL)arg2 settings:(id)arg3;
@end

@interface _UIBackdropViewSettings : NSObject
+(id)settingsForStyle:(NSInteger)arg1;
@property (nonatomic,retain) UIColor * colorTint;
@end

@interface __NSCFString : NSMutableString
@end

@interface SBIconView : UIView
@end

@interface CS3DSwitcherPageScrollView : UIScrollView
// iconView property of type UIView * which contains an SBIconView as subview
// pageView property of type CS3DSwitcherPageView * which contains UIView * of snapshot
@end

@interface CS3DSwitcherViewController : UIViewController
-(CGRect)frameForViewAtIndex:(NSInteger)arg1;
@end

@interface CS3DSwitcherPageView : UIView
@end