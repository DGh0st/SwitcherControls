#import "headers.h"

@implementation ControlCenterBrightnessSectionView
-(id)initWithFrame:(CGRect)frame {
	frame.origin.x += 4;
	self = [super initWithFrame:frame];
	if (self != nil) {
		_brightnessController = [[objc_getClass("CCUIBrightnessSectionController") alloc] init];
		[_brightnessController setDelegate:self];
		[_brightnessController setUsesCompactHeight:YES];
		_brightnessController.view.frame = CGRectMake(20, (frame.size.height - 29) / 2, frame.size.width - 40, 29);
		//_brightnessController.view.center = CGPointMake(frame.size.width / 2, frame.size.height / 2);

		[self addSubview:_brightnessController.view];
	}
	return self;
}

-(void)dealloc {
	[_brightnessController release];
	[super dealloc];
}

-(id)slider {
	return [_brightnessController valueForKey:@"_slider"];
}

-(void)addButton:(UIButton *)button target:(id)target action:(SEL)selector isMin:(BOOL)isMin {
	if (isMin) {
		UIImageView *_minValueImageView = [[self slider] valueForKey:@"_minValueImageView"];
		if (_minValueImageView != nil) {
			if (button != nil) {
				button.center = CGPointMake(_minValueImageView.frame.size.width / 2, _minValueImageView.frame.size.height / 2);
				[_minValueImageView addSubview:button];
			}

			UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:target action:selector];
			tapGesture.delegate = target;
			[_minValueImageView addGestureRecognizer:tapGesture];
			_minValueImageView.userInteractionEnabled = YES;
		}

		UIImageView *_minValueHighlightedImageView = [[self slider] valueForKey:@"_minValueHighlightedImageView"];
		if (_minValueHighlightedImageView != nil) {
			UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:target action:selector];
			tapGesture.delegate = target;
			[_minValueHighlightedImageView addGestureRecognizer:tapGesture];
			_minValueHighlightedImageView.userInteractionEnabled = YES;
		}
	} else {
		UIImageView *_maxValueImageView = [[self slider] valueForKey:@"_maxValueImageView"];
		if (_maxValueImageView != nil) {
			if (button != nil) {
				button.center = CGPointMake(_maxValueImageView.frame.size.width / 2, _maxValueImageView.frame.size.height / 2);
				[_maxValueImageView addSubview:button];
			}

			UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:target action:selector];
			tapGesture.delegate = target;
			[_maxValueImageView addGestureRecognizer:tapGesture];
			_maxValueImageView.userInteractionEnabled = YES;
		}

		UIImageView *_maxValueHighlightedImageView = [[self slider] valueForKey:@"_maxValueHighlightedImageView"];
		if (_maxValueHighlightedImageView != nil) {
			UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:target action:selector];
			tapGesture.delegate = target;
			[_maxValueHighlightedImageView addGestureRecognizer:tapGesture];
			_maxValueHighlightedImageView.userInteractionEnabled = YES;
		}
	}
}
@end

%hook CCUIControlCenterSlider
-(void)layoutSubviews {
	%orig();

	if ([self superview] != nil && ([[[self superview] class] isEqual:[ControlCenterBrightnessSectionView class]] || [[[[self superview] superview] class] isEqual:[ControlCenterBrightnessSectionView class]])) {
		CGRect frame = self.frame;
		frame.origin.x = 1;
		if (%c(CCXMultiSliderSectionController)) // horseshoe fix (any horseshoe class would work actually)
			frame.origin.y = -1;
		else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone && screenSize.height <= 568)
			frame.origin.y = -4;
		else
			frame.origin.y = -6;
		self.frame = frame;

		UIImageView *_minValueImageView = MSHookIvar<UIImageView *>(self, "_minValueImageView");
		if (_minValueImageView != nil) {
			if (![[[self superview] class] isEqual:[ControlCenterBrightnessSectionView class]]) {			
				CGRect frame = _minValueImageView.frame;
				frame.origin.x += [self superview].frame.origin.x + self.frame.origin.x - 7.5;
				frame.origin.y += [self superview].frame.origin.y + self.frame.origin.y;
				[_minValueImageView removeFromSuperview];
				[[[self superview] superview] addSubview:_minValueImageView];
				_minValueImageView.frame = frame;

				for (id view in [_minValueImageView subviews])
					if ([[view class] isEqual:[UIButton class]]) {
						((UIButton *)view).center = _minValueImageView.center;
						[(UIButton *)view removeFromSuperview];
						[[[self superview] superview] insertSubview:(UIButton *)view belowSubview:_minValueImageView];
					}
			}
			[_minValueImageView layoutSubviews];
		}

		UIImageView *_minValueHighlightedImageView = MSHookIvar<UIImageView *>(self, "_minValueHighlightedImageView");
		if (_minValueHighlightedImageView != nil) {
			if (![[[self superview] class] isEqual:[ControlCenterBrightnessSectionView class]]) {
				CGRect frame = _minValueHighlightedImageView.frame;
				frame.origin.x += [self superview].frame.origin.x + self.frame.origin.x - 7.5;
				frame.origin.y += [self superview].frame.origin.y + self.frame.origin.y;
				[_minValueHighlightedImageView removeFromSuperview];
				[[[self superview] superview] addSubview:_minValueHighlightedImageView];
				_minValueHighlightedImageView.frame = frame;
			}
			[_minValueHighlightedImageView layoutSubviews];
		}

		UIImageView *_maxValueImageView = MSHookIvar<UIImageView *>(self, "_maxValueImageView");
		if (_maxValueImageView != nil) {
			if (![[[self superview] class] isEqual:[ControlCenterBrightnessSectionView class]]) {
				CGRect frame = _maxValueImageView.frame;
				frame.origin.x += [self superview].frame.origin.x + self.frame.origin.x + 2.5;
				frame.origin.y += [self superview].frame.origin.y + self.frame.origin.y;
				[_maxValueImageView removeFromSuperview];
				[[[self superview] superview] addSubview:_maxValueImageView];
				_maxValueImageView.frame = frame;

				for (id view in [_maxValueImageView subviews])
					if ([[view class] isEqual:[UIButton class]]) {
						((UIButton *)view).center = _maxValueImageView.center;
						[(UIButton *)view removeFromSuperview];
						[[[self superview] superview] insertSubview:(UIButton *)view belowSubview:_minValueImageView];
					}
			}
			[_maxValueImageView layoutSubviews];
		}

		UIImageView *_maxValueHighlightedImageView = MSHookIvar<UIImageView *>(self, "_maxValueHighlightedImageView");
		if (_maxValueHighlightedImageView != nil) {
			if (![[[self superview] class] isEqual:[ControlCenterBrightnessSectionView class]]) {
				CGRect frame = _maxValueHighlightedImageView.frame;
				frame.origin.x += [self superview].frame.origin.x + self.frame.origin.x + 2.5;
				frame.origin.y += [self superview].frame.origin.y + self.frame.origin.y;
				[_maxValueHighlightedImageView removeFromSuperview];
				[[[self superview] superview] addSubview:_maxValueHighlightedImageView];
				_maxValueHighlightedImageView.frame = frame;
			}
			[_maxValueHighlightedImageView layoutSubviews];
		}
	}
}
%end