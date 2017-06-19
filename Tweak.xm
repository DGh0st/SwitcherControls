#import "headers.h"

static BOOL shouldDisplayTweakCC = YES;
static BOOL shouldHideTweakCC = NO;
static BOOL interactiveTweakCC = NO;
CGPoint startPanPoint = CGPointZero;
SBDeckSwitcherViewController *deckSwitcher = nil;

UIView *bottomBackgroundViewPortrait = nil;
UIView *topBackgroundViewPortrait = nil;
ControlCenterBottomScrollView *bottomScrollViewPortrait = nil;

UIView *bottomBackgroundViewLandscape = nil;
UIView *topBackgroundViewLandscape = nil;
ControlCenterBottomScrollView *bottomScrollViewLandscape = nil;

UIView *bottomBackgroundView = nil;
UIView *topBackgroundView = nil;
ControlCenterBottomScrollView *bottomScrollView = nil;

void setupViewsForSize(CGSize size) {
	if (size.width > size.height) {
		bottomBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, size.height - [SCPreferences sharedInstance].landscapeBottomHeight, size.width, 252)];
		topBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, [SCPreferences sharedInstance].landscapeTopHeight)];
	} else {
		bottomBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, size.height - [SCPreferences sharedInstance].portraitBottomHeight, size.width, 252)];
		topBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, [SCPreferences sharedInstance].portraitTopHeight)];
	}
	
	CGRect bottomGrabberViewFrame = CGRectMake(bottomBackgroundView.frame.size.width / 2 - 15, 7.5, 30, 5);
	CGRect topSectionViewFrame = CGRectMake(0, 0, topBackgroundView.frame.size.width, 64);
	CGRect bottomSectionViewFrame = CGRectMake(0, 25, bottomBackgroundView.frame.size.width, 64);
	CGRect bottomScrollViewFrame = CGRectMake(0, 99, bottomBackgroundView.frame.size.width, 152);
	
	if ([[SCPreferences sharedInstance].bottomSection count] == 3) {
		bottomScrollViewFrame.size.height = 226;
		CGRect frame = bottomBackgroundView.frame;
		frame.size.height += 74;
		bottomBackgroundView.frame = frame;
	}

	[bottomBackgroundView setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.1]];
	[topBackgroundView setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.1]];

	UIBlurEffect *backgroundEffect = [UIBlurEffect effectWithStyle:[SCPreferences sharedInstance].blurStyle];
	UIVisualEffectView *bottomEffectView = [[UIVisualEffectView alloc] initWithFrame:CGRectMake(0, 0, bottomBackgroundView.frame.size.width, bottomBackgroundView.frame.size.height)];
	UIVisualEffectView *topEffectView = [[UIVisualEffectView alloc] initWithFrame:CGRectMake(0, 0, topBackgroundView.frame.size.width, topBackgroundView.frame.size.height)];

	[bottomEffectView setEffect:backgroundEffect];
	[topEffectView setEffect:backgroundEffect];

	[bottomBackgroundView addSubview:bottomEffectView];
	[topBackgroundView addSubview:topEffectView];

	UIView *bottomGrabberView = [[UIView alloc] initWithFrame:bottomGrabberViewFrame];
	if ([SCPreferences sharedInstance].blurStyle == UIBlurEffectStyleDark)
		[bottomGrabberView setBackgroundColor:[UIColor whiteColor]];
	else
		[bottomGrabberView setBackgroundColor:[UIColor blackColor]];
	bottomGrabberView.layer.cornerRadius = 2.5;
	[bottomBackgroundView addSubview:bottomGrabberView];

	Class topClass = [[SCPreferences sharedInstance] sectionClass:kTop withIndex:0];
	if (![topClass isEqual:[ControlCenterFailureSectionClass class]]) {
		ControlCenterSectionView *topSection = [[topClass alloc] initWithFrame:topSectionViewFrame];
		topSection.center = CGPointMake(topBackgroundView.frame.size.width / 2, topBackgroundView.frame.size.height / 2);
		[topBackgroundView addSubview:topSection];
		[topSection release];
	} else {
		[topBackgroundView setHidden:YES];
	}

	Class bottomStickyClass = [[SCPreferences sharedInstance] sectionClass:kBottomSticky withIndex:0];
	if (![bottomStickyClass isEqual:[ControlCenterFailureSectionClass class]]) {
		ControlCenterSectionView *bottomStickySection = [[bottomStickyClass alloc] initWithFrame:bottomSectionViewFrame];
		[bottomBackgroundView addSubview:bottomStickySection];
		[bottomStickySection release];
	} else {
		CGRect frame = bottomBackgroundView.frame;
		frame.size.height -= bottomSectionViewFrame.size.height + 10;
		bottomBackgroundView.frame = frame;

		bottomScrollViewFrame.origin.y = bottomSectionViewFrame.origin.y;
	}

	bottomScrollView = [[ControlCenterBottomScrollView alloc] initWithFrame:bottomScrollViewFrame];
	[bottomBackgroundView addSubview:bottomScrollView];

	[bottomEffectView release];
	[topEffectView release];
	[bottomGrabberView release];
}

void deallocStuffIfNeeded() {
	if (bottomBackgroundViewPortrait != nil) {
		[bottomBackgroundViewPortrait release];
		bottomBackgroundViewPortrait = nil;
	}

	if (bottomBackgroundViewLandscape != nil) {
		[bottomBackgroundViewLandscape release];
		bottomBackgroundViewLandscape = nil;
	}

	if (topBackgroundViewPortrait != nil) {
		[topBackgroundViewPortrait release];
		topBackgroundViewPortrait = nil;
	}

	if (topBackgroundViewLandscape != nil) {
		[topBackgroundViewLandscape release];
		topBackgroundViewLandscape = nil;
	}

	if (bottomScrollViewPortrait != nil) {
		[bottomScrollViewPortrait release];
		bottomScrollViewPortrait = nil;
	}

	if (bottomScrollViewLandscape != nil) {
		[bottomScrollViewLandscape release];
		bottomScrollViewLandscape = nil;
	}
}

void hideIfNeeded() {
	if (bottomBackgroundView != nil && [bottomBackgroundView superview])
		[bottomBackgroundView removeFromSuperview];
	if (topBackgroundView != nil && [topBackgroundView superview])
		[topBackgroundView removeFromSuperview];
}

void relayoutViewsIfNeeded() {
	if (bottomBackgroundViewPortrait == nil || bottomBackgroundViewLandscape == nil || topBackgroundViewPortrait == nil || topBackgroundViewLandscape == nil || bottomScrollViewPortrait == nil || bottomScrollViewLandscape == nil)
		[SCPreferences sharedInstance].requiresRelayout = YES;

	if (![SCPreferences sharedInstance].requiresRelayout)
		return;
	[SCPreferences sharedInstance].requiresRelayout = NO;

	deallocStuffIfNeeded();

	setupViewsForSize(screenSize);
	bottomBackgroundViewPortrait = bottomBackgroundView;
	topBackgroundViewPortrait = topBackgroundView;
	bottomScrollViewPortrait = bottomScrollView;

	setupViewsForSize(CGSizeMake(screenSize.height, screenSize.width));
	bottomBackgroundViewLandscape = bottomBackgroundView;
	topBackgroundViewLandscape = topBackgroundView;
	bottomScrollViewLandscape = bottomScrollView;
}

/*%hook SpringBoard
-(void)applicationDidFinishLaunching:(id)arg1 {
	%orig(arg1);

	relayoutViewsIfNeeded();
}
%end*/

%hook SBDeckSwitcherItemContainer
+(CGFloat)spacingBetweenSnapshotAndIcon {
	CGFloat result = %orig();
	if (![SCPreferences sharedInstance].isScaleIconLabelsEnabled)
		return result;
	if (UIInterfaceOrientationIsPortrait([[%c(SpringBoard) sharedApplication] activeInterfaceOrientation]))
		return result * [SCPreferences sharedInstance].portraitScale;
	return result * [SCPreferences sharedInstance].landscapeScale;
}

-(CGAffineTransform)_transformForIconTitleViewContainer {
	CGAffineTransform result = %orig();
	UIView *container = MSHookIvar<UIView *>(self, "_iconAndLabelContainer");
	if (container == nil || ![SCPreferences sharedInstance].isScaleIconLabelsEnabled)
		return result;
	if (UIInterfaceOrientationIsPortrait([[%c(SpringBoard) sharedApplication] activeInterfaceOrientation]))
		return CGAffineTransformScale(result, [SCPreferences sharedInstance].portraitScale, [SCPreferences sharedInstance].portraitScale);
	return CGAffineTransformScale(result, [SCPreferences sharedInstance].landscapeScale, [SCPreferences sharedInstance].landscapeScale);
}
%end

%hook SBReduceMotionDeckSwitcherViewController
-(CGFloat)_leadingOffsetForIndex:(NSUInteger)arg1 displayItemsCount:(NSUInteger)arg2 transitionParameters:(UIEdgeInsets)arg3 scrollProgress:(CGFloat)arg4 ignoringKillingAdjustments:(BOOL)arg5 {
	CGFloat result = %orig(arg1, arg2, arg3, arg4, arg5);
	if (UIInterfaceOrientationIsPortrait([[%c(SpringBoard) sharedApplication] activeInterfaceOrientation]))
		return result * [SCPreferences sharedInstance].portraitScale;
	return result * [SCPreferences sharedInstance].landscapeScale;
}
%end

%hook SBDeckSwitcherViewController
UIPanGestureRecognizer *pan = nil;

-(void)viewDidLoad {
	deckSwitcher = self;
	%orig();

	relayoutViewsIfNeeded();

	if (UIInterfaceOrientationIsPortrait([[%c(SpringBoard) sharedApplication] activeInterfaceOrientation])) {
		bottomBackgroundView = bottomBackgroundViewPortrait;
		topBackgroundView = topBackgroundViewPortrait;
		bottomScrollView = bottomScrollViewPortrait;
	} else {
		bottomBackgroundView = bottomBackgroundViewLandscape;
		topBackgroundView = topBackgroundViewLandscape;
		bottomScrollView = bottomScrollViewLandscape;
	}
}

-(void)viewDidDisappaer:(BOOL)arg1 {
	%orig(arg1);

	if (shouldHideTweakCC)
		[self animateDisappearance];
}

-(void)_sendViewPresentingToPageViewsForTransitionRequest:(id)arg1 {
	%orig(arg1);

	if (shouldDisplayTweakCC)
		dispatch_async(dispatch_get_main_queue(), ^{
			[self animateAppearance];
		});
}

-(void)animateDismissalToDisplayItem:(id)arg1 forTransitionRequest:(id)arg2 withCompletion:(id)arg3 {
	%orig(arg1, arg2, arg3);

	if (shouldHideTweakCC)
		[self animateDisappearance];
}

/*-(CGFloat)_scaleForTransformForIndex:(NSUInteger)arg1 progressPresented:(CGFloat)arg2 scrollProgress:(CGFloat)arg3 {
	CGFloat result = %orig(arg1, arg2, arg3);
	if (arg2 == 0.0 || !shouldDisplayTweakCC)
		return result;
	if (UIInterfaceOrientationIsPortrait([[%c(SpringBoard) sharedApplication] activeInterfaceOrientation]))
		return result * [SCPreferences sharedInstance].portraitScale;
	return result * [SCPreferences sharedInstance].landscapeScale;
}*/

-(CGFloat)_scaleForPresentedProgress:(CGFloat)arg1 {
	CGFloat result = %orig(arg1);
	if (arg1 == 0.0 || !shouldDisplayTweakCC)
		return result;
	if (UIInterfaceOrientationIsPortrait([[%c(SpringBoard) sharedApplication] activeInterfaceOrientation]))
		return result * [SCPreferences sharedInstance].portraitScale;
	return result * [SCPreferences sharedInstance].landscapeScale;
}

-(CGFloat)_desiredXOriginForQuantizedTopPage {
	CGFloat result = %orig();
	if (!shouldDisplayTweakCC)
		return result;
	if (UIInterfaceOrientationIsPortrait([[%c(SpringBoard) sharedApplication] activeInterfaceOrientation]))
		return result * [SCPreferences sharedInstance].portraitScale;
	return result * [SCPreferences sharedInstance].landscapeScale;
}

%new
-(void)animateAppearance {
	shouldHideTweakCC = YES;

	relayoutViewsIfNeeded();

	UIInterfaceOrientation currentOrientation = [[%c(SpringBoard) sharedApplication] activeInterfaceOrientation];
	if (UIInterfaceOrientationIsPortrait(currentOrientation)) {
		bottomBackgroundView = bottomBackgroundViewPortrait;
		topBackgroundView = topBackgroundViewPortrait;
		bottomScrollView = bottomScrollViewPortrait;
	} else {
		bottomBackgroundView = bottomBackgroundViewLandscape;
		topBackgroundView = topBackgroundViewLandscape;
		bottomScrollView = bottomScrollViewLandscape;
	}

	if ([SCPreferences sharedInstance].isMediaPageOnPlayingEnabled && [[%c(SBMediaController) sharedInstance] isPlaying]) {
		[bottomScrollViewPortrait scrollToPage:[bottomScrollView mediaPage] animated:NO];
		[bottomScrollViewLandscape scrollToPage:[bottomScrollView mediaPage] animated:NO];
	} else if ([bottomScrollView defaultPage] >= 0) {
		[bottomScrollViewPortrait scrollToPage:[bottomScrollView defaultPage] animated:NO];
		[bottomScrollViewLandscape scrollToPage:[bottomScrollView defaultPage] animated:NO];
	}

	pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panBottomView:)];
	[pan setMinimumNumberOfTouches:1];
	[pan setMaximumNumberOfTouches:1];
	[bottomBackgroundView addGestureRecognizer:pan];

	/*if (topBackgroundView.hidden) {
		SBAppSwitcherScrollView *_scrollView = MSHookIvar<SBAppSwitcherScrollView *>(self, "_scrollView");
		if (UIInterfaceOrientationIsPortrait(currentOrientation))
			[UIView animateWithDuration:0.1 animations:^{
				//_scrollView.transform = CGAffineTransformMakeScale([SCPreferences sharedInstance].portraitScale, [SCPreferences sharedInstance].portraitScale);
				_scrollView.transform = CGAffineTransformMakeTranslation(0, -screenSize.height * (0.95 - [SCPreferences sharedInstance].portraitScale));
			} completion:nil];
		else
			[UIView animateWithDuration:0.1 animations:^{
				//_scrollView.transform = CGAffineTransformMakeScale([SCPreferences sharedInstance].landscapeScale, [SCPreferences sharedInstance].landscapeScale);
				_scrollView.transform = CGAffineTransformMakeTranslation(0, -screenSize.width * (0.95 - [SCPreferences sharedInstance].landscapeScale));
			} completion:nil];
	}*/

	[self.view addSubview:bottomBackgroundView];
	[self.view addSubview:topBackgroundView];
	[self.view bringSubviewToFront:bottomBackgroundView];
	[self.view bringSubviewToFront:topBackgroundView];

	bottomBackgroundView.transform = CGAffineTransformMakeTranslation(0.0, topBackgroundView.frame.size.height);
	topBackgroundView.transform = CGAffineTransformMakeTranslation(0.0, -topBackgroundView.frame.size.height);
	[UIView animateWithDuration:[SCPreferences sharedInstance].animationSpeed animations:^{
		bottomBackgroundView.transform = CGAffineTransformMakeTranslation(0.0, 0.0);
		topBackgroundView.transform = CGAffineTransformMakeTranslation(0.0, 0.0);
	} completion:^(BOOL finished) {
		if (finished)
			bottomScrollView.scrollEnabled = YES;
	}];
}

%new
-(void)animateDisappearance {
	shouldHideTweakCC = NO;
	shouldDisplayTweakCC = YES;

	if (pan != nil) {
		[bottomBackgroundView removeGestureRecognizer:pan];
		[pan release];
		pan = nil;
	}

	/*SBAppSwitcherScrollView *_scrollView = MSHookIvar<SBAppSwitcherScrollView *>(self, "_scrollView");
	[UIView animateWithDuration:0.1 animations:^{
		//_scrollView.transform = CGAffineTransformMakeScale(1.0, 1.0);
		_scrollView.transform = CGAffineTransformMakeTranslation(0, 0);
	} completion:nil];*/

	[UIView animateWithDuration:[SCPreferences sharedInstance].animationSpeed animations:^{
		bottomBackgroundView.transform = CGAffineTransformMakeTranslation(0.0, topBackgroundView.frame.size.height);
		topBackgroundView.transform = CGAffineTransformMakeTranslation(0.0, -topBackgroundView.frame.size.height);
	} completion:^(BOOL finished){
		if (finished) {
			hideIfNeeded();

			[bottomScrollViewPortrait scrollToPage:[bottomScrollView currentVisiblePage] animated:NO];
			[bottomScrollViewLandscape scrollToPage:[bottomScrollView currentVisiblePage] animated:NO];
		}
	}];
}

%new
-(void)panBottomView:(UIPanGestureRecognizer *)arg1 {
	CGPoint translatedPoint = [arg1 translationInView:bottomScrollView.superview];

	CGFloat visibleHeight = 98;
	if (UIInterfaceOrientationIsPortrait([[%c(SpringBoard) sharedApplication] activeInterfaceOrientation]))
		visibleHeight = [SCPreferences sharedInstance].portraitBottomHeight;
	else
		visibleHeight = [SCPreferences sharedInstance].landscapeBottomHeight;

	if (arg1.state == UIGestureRecognizerStateBegan) {
		startPanPoint = translatedPoint;
	} else if (arg1.state == UIGestureRecognizerStateChanged) {
		bottomBackgroundView.transform = CGAffineTransformTranslate(bottomBackgroundView.transform, 0, -(startPanPoint.y - translatedPoint.y));

		if (bottomBackgroundView.transform.ty > 0)
			bottomBackgroundView.transform = CGAffineTransformMakeTranslation(0, 0);
		else if (bottomBackgroundView.transform.ty < -(bottomBackgroundView.frame.size.height - visibleHeight))
			bottomBackgroundView.transform = CGAffineTransformMakeTranslation(0, -(bottomBackgroundView.frame.size.height - visibleHeight));
		startPanPoint = translatedPoint;
	} else if (arg1.state == UIGestureRecognizerStateEnded || arg1.state == UIGestureRecognizerStateCancelled || arg1.state == UIGestureRecognizerStateFailed) {
		bottomBackgroundView.transform = CGAffineTransformTranslate(bottomBackgroundView.transform, 0, -(startPanPoint.y - translatedPoint.y));

		if (bottomBackgroundView.transform.ty > -(bottomBackgroundView.frame.size.height - visibleHeight) / 2)
			[UIView animateWithDuration:0.2 animations:^{
				bottomBackgroundView.transform = CGAffineTransformMakeTranslation(0, 0);
			} completion:nil];
		else
			[UIView animateWithDuration:0.2 animations:^{
				bottomBackgroundView.transform = CGAffineTransformMakeTranslation(0, -(bottomBackgroundView.frame.size.height - visibleHeight));
			} completion:nil];
	}
}

%new
-(void)interactiveAppearance:(CGFloat)arg1 didEnd:(BOOL)arg2 {
	CGFloat visibleHeight = 98;
	if (UIInterfaceOrientationIsPortrait([[%c(SpringBoard) sharedApplication] activeInterfaceOrientation]))
		visibleHeight = [SCPreferences sharedInstance].portraitBottomHeight;
	else
		visibleHeight = [SCPreferences sharedInstance].landscapeBottomHeight;

	arg1 -= visibleHeight;

	BOOL isViableHeight = YES;
	if (arg2) {
		if (-arg1 > -(bottomBackgroundView.frame.size.height - visibleHeight) / 2) {
			isViableHeight = NO;
			[UIView animateWithDuration:0.2 animations:^{
				bottomBackgroundView.transform = CGAffineTransformMakeTranslation(0, 0);
			} completion:nil];
		} else {
			isViableHeight = NO;
			[UIView animateWithDuration:0.2 animations:^{
				bottomBackgroundView.transform = CGAffineTransformMakeTranslation(0, -(bottomBackgroundView.frame.size.height - visibleHeight));
			} completion:nil];
		}

		interactiveTweakCC = NO;
	} else {
		if (-arg1 > 0) {
			isViableHeight = NO;
			bottomBackgroundView.transform = CGAffineTransformMakeTranslation(0, 0);
		}
		else if (-arg1 < -(bottomBackgroundView.frame.size.height - visibleHeight)) {
			isViableHeight = NO;
			bottomBackgroundView.transform = CGAffineTransformMakeTranslation(0, -(bottomBackgroundView.frame.size.height - visibleHeight));
		}
	}

	if (isViableHeight)
		bottomBackgroundView.transform = CGAffineTransformMakeTranslation(0.0, -arg1);
}
%end

%hook SBAppSwitcherScrollView
-(BOOL)pointInside:(CGPoint)arg1 withEvent:(UIEvent *)arg2 {
	if (arg1.y > self.frame.origin.y && arg1.y < self.frame.origin.y + self.frame.size.height)
		return YES;
	return %orig(arg1, arg2);
}
%end

BOOL isKazeInstalled = NO;
BOOL isKazeLeftEnabled = YES;
BOOL isKazeRightEnabled = YES;
CGFloat kazeWidth = screenSize.height >= 667 ? 100 : 80;

%hook SBControlCenterController
BOOL ignoreGesture = NO;
CGPoint initialTouchLocation = CGPointZero;

-(void)_handleShowControlCenterGesture:(UIPanGestureRecognizer *)arg1 {
	SBApplication *frontMostApplication = [[%c(SpringBoard) sharedApplication] _accessibilityFrontMostApplication];
	BOOL disabledInCurrentApp = frontMostApplication != nil && [[SCPreferences sharedInstance] isAppDisabled:[frontMostApplication bundleIdentifier]];
	CGPoint touchLocation = [arg1 locationInView:arg1.view];
	
	if (arg1.state == UIGestureRecognizerStateBegan) {
		ignoreGesture = [[%c(SBUIController) sharedInstance] isAppSwitcherShowing] || [[%c(SBIconController) sharedInstance] hasAnimatingFolder] || ((SBMainWorkspace *)[%c(SBMainWorkspace) sharedInstance]).currentTransaction != nil || [((SBMainWorkspace *)[%c(SBMainWorkspace) sharedInstance]).alertManager activeAlert] != nil;

		if (!self.isUILocked && !ignoreGesture) {
			if (isKazeInstalled) {
				BOOL isLandscape = UIInterfaceOrientationIsLandscape([[%c(SpringBoard) sharedApplication] activeInterfaceOrientation]);
				CGFloat touchX = isLandscape ? touchLocation.y : touchLocation.x;
				CGFloat screenWidth = (isLandscape ? screenSize.height : screenSize.width);
				if (touchX < kazeWidth && isKazeLeftEnabled) {
					shouldDisplayTweakCC = NO;
					goto Original;
				} else if (touchX > screenWidth - kazeWidth && isKazeRightEnabled) {
					shouldDisplayTweakCC = NO;
					goto Original;
				}
			}

			if ([SCPreferences sharedInstance].isReplaceCCEnabled && !disabledInCurrentApp) {
				shouldDisplayTweakCC = YES;
				interactiveTweakCC = [SCPreferences sharedInstance].isInteractiveCCEnabled;
				initialTouchLocation = touchLocation;
				[self _showControlCenterGestureCancelled];
				[[%c(SBMainSwitcherViewController) sharedInstance] activateSwitcherNoninteractively];
				if (interactiveTweakCC) {
					dispatch_async(dispatch_get_main_queue(), ^{
						[deckSwitcher interactiveAppearance:[self _controlCenterHeightForTouchLocation:touchLocation initialTouchLocation:initialTouchLocation] didEnd:NO];
					});
				}
				return;
			}
		}
	}

Original:
	BOOL shouldCallOrig = self.isUILocked || !shouldDisplayTweakCC || disabledInCurrentApp || (![SCPreferences sharedInstance].isReplaceCCEnabled && ![[%c(SBUIController) sharedInstance] isAppSwitcherShowing]);
	if (shouldCallOrig)
		%orig(arg1);

	if (arg1.state == UIGestureRecognizerStateEnded || arg1.state == UIGestureRecognizerStateCancelled || arg1.state == UIGestureRecognizerStateFailed) {
		if (interactiveTweakCC && shouldDisplayTweakCC && deckSwitcher != nil && !ignoreGesture && !disabledInCurrentApp)
			dispatch_async(dispatch_get_main_queue(), ^{
				[deckSwitcher interactiveAppearance:[self _controlCenterHeightForTouchLocation:touchLocation initialTouchLocation:initialTouchLocation] didEnd:YES];
			});

		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 100), dispatch_get_main_queue(), ^{
			shouldDisplayTweakCC = YES;
		});
	} else if (interactiveTweakCC && shouldDisplayTweakCC && deckSwitcher != nil && !ignoreGesture && !disabledInCurrentApp) {
		dispatch_async(dispatch_get_main_queue(), ^{
			[deckSwitcher interactiveAppearance:[self _controlCenterHeightForTouchLocation:touchLocation initialTouchLocation:initialTouchLocation] didEnd:NO];
		});
	}
}
%end

%hook SBSwitcherForcePressSystemGestureTransaction
-(void)systemGestureStateChanged:(UIGestureRecognizer *)arg1 {
	if (arg1.state == UIGestureRecognizerStateBegan || arg1.state == UIGestureRecognizerStateChanged) {
		shouldDisplayTweakCC = NO;
	} else if (arg1.state == UIGestureRecognizerStateEnded || arg1.state == UIGestureRecognizerStateCancelled || arg1.state == UIGestureRecognizerStateFailed) {
		CGPoint touchLocation = [arg1 locationInView:arg1.view];
		BOOL isLandscape = UIInterfaceOrientationIsLandscape([[%c(SpringBoard) sharedApplication] activeInterfaceOrientation]);
		CGFloat touchX = isLandscape ? touchLocation.y : touchLocation.x;
		CGFloat leftWidth = isLandscape ? screenSize.height / 10 : screenSize.width / 10;
		CGFloat rightWidth = isLandscape ? screenSize.height / 5 : screenSize.width / 5;
		CGFloat screenWidth = isLandscape ? screenSize.height : screenSize.width;
		BOOL _didPop = MSHookIvar<BOOL>(self, "_didPop");
		BOOL _didCommitToSwitcher = MSHookIvar<BOOL>(self, "_didCommitToSwitcher");
		BOOL non3DTouchDeviceActivate = touchX > leftWidth && touchX < screenWidth - rightWidth;
		if (((_didPop	&& _didCommitToSwitcher) || non3DTouchDeviceActivate) && deckSwitcher != nil) {
			shouldDisplayTweakCC = YES;
			dispatch_async(dispatch_get_main_queue(), ^{
				[deckSwitcher animateAppearance];
			});
			goto Original2;
		}

		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 100), dispatch_get_main_queue(), ^{
			shouldDisplayTweakCC = YES;
		});
	}

Original2:
	%orig(arg1);
}
%end

%hook SBMainSwitcherGestureCoordinator
-(void)handleSwitcherForcePressGesture:(UIPanGestureRecognizer *)arg1 {
	if (arg1.state == UIGestureRecognizerStateBegan || arg1.state == UIGestureRecognizerStateChanged) {
		shouldDisplayTweakCC = NO;
	}
	
	%orig(arg1);
}
%end

%hook KazeHomeScreenDeckViewController
-(void)viewWillAppear:(BOOL)arg1 {
	shouldDisplayTweakCC = NO;
	%orig(arg1);
}

-(void)viewDidDisappear:(BOOL)arg1 {
	%orig(arg1);
	shouldDisplayTweakCC = YES;
}
%end

/*%hook KazeQuickSwitcherIconListViewLayout
-(void)startScrolling:(NSInteger)arg1 {
	shouldDisplayTweakCC = NO;
	%orig(arg1);
}

-(void)stopScrolling {
	%orig();
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 100), dispatch_get_main_queue(), ^{
		shouldDisplayTweakCC = YES;
	});
}
%end*/

static void preferencesChanged() {	
	[[SCPreferences sharedInstance] updatePreferences];

	relayoutViewsIfNeeded();
}

static void respringNotification() {
	[[%c(FBSystemService) sharedInstance] exitAndRelaunch:YES];
}

%dtor {
	CFNotificationCenterRemoveObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, CFSTR("com.dgh0st.switchercontrols/settingschanged"), NULL);
	CFNotificationCenterRemoveObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, CFSTR("com.dgh0st.switchercontrols/respring"), NULL);

	deallocStuffIfNeeded();
}

%ctor {
	[[SCPreferences sharedInstance] updatePreferences];

	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)preferencesChanged, CFSTR("com.dgh0st.switchercontrols/settingschanged"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)respringNotification, CFSTR("com.dgh0st.switchercontrols/respring"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);

	if (![SCPreferences sharedInstance].isTweakEnabled)
		return;

	if ([NSFileManager.defaultManager fileExistsAtPath:@"/Library/MobileSubstrate/DynamicLibraries/Kaze.dylib"]) {
		isKazeInstalled = YES;

		NSString *kazePrefsPath = @"/var/mobile/Library/Preferences/me.qusic.kaze.plist";
		if ([NSFileManager.defaultManager fileExistsAtPath:kazePrefsPath]) {
			NSDictionary *kazePrefs = [NSDictionary dictionaryWithContentsOfFile:kazePrefsPath];

			if (kazePrefs != nil) { 
				BOOL isKazeInvertHotCornersEnabled = [kazePrefs objectForKey:@"InvertHotCorners"] ? [[kazePrefs objectForKey:@"InvertHotCorners"] boolValue] : NO;

				if (isKazeInvertHotCornersEnabled) {
					isKazeRightEnabled = [kazePrefs objectForKey:@"QuickSwitcherEnabled"] ? [[kazePrefs objectForKey:@"QuickSwitcherEnabled"] boolValue] : YES;
					isKazeLeftEnabled = [kazePrefs objectForKey:@"HotCornersEnabled"] ? [[kazePrefs objectForKey:@"HotCornersEnabled"] boolValue] : YES;
				} else {
					isKazeLeftEnabled = [kazePrefs objectForKey:@"QuickSwitcherEnabled"] ? [[kazePrefs objectForKey:@"QuickSwitcherEnabled"] boolValue] : YES;
					isKazeRightEnabled = [kazePrefs objectForKey:@"HotCornersEnabled"] ? [[kazePrefs objectForKey:@"HotCornersEnabled"] boolValue] : YES;
				}
			}
		}
	}

	%init();
}