#include "headers.h"

@implementation ControlCenterBrightnessVolumeSectionView
-(id)initWithFrame:(CGRect)frame {
	if ([SCPreferences sharedInstance].isCompactSlidersEnabled)
		frame.size.height = 32;
	self = [super initWithFrame:frame];
	if (self != nil) {
		if (%c(CCXMultiSliderSectionController)) { // horseshoe fix (any horseshoe class would work actually)
			_brightnessView = [[ControlCenterBrightnessSectionView alloc] initWithFrame:CGRectMake(0, 1, frame.size.width, frame.size.height)];
			_volumeView = [[ControlCenterVolumeSectionView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width - 1, frame.size.height)];
		} else {
			_brightnessView = [[ControlCenterBrightnessSectionView alloc] initWithFrame:CGRectMake(0, 4, frame.size.width, frame.size.height)];
			_volumeView = [[ControlCenterVolumeSectionView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width - 1, frame.size.height)];
		}
		_volumeView.hidden = YES;

		[_brightnessView layoutSubviews];
		[_volumeView layoutSubviews];

		[self addSubview:_brightnessView];
		[self addSubview:_volumeView];

		UIButton *brightnessLeftButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		brightnessLeftButton.frame = CGRectMake(0, 0, 30, 30);
		brightnessLeftButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
		[brightnessLeftButton setTitle:@"" forState:UIControlStateNormal];
		[brightnessLeftButton addTarget:self action:@selector(changeSlider) forControlEvents:UIControlEventTouchUpInside];
		[brightnessLeftButton.layer setCornerRadius:15];
		[brightnessLeftButton.layer setBackgroundColor:[UIColor colorWithWhite:0.2 alpha:[SCPreferences sharedInstance].multiSliderBackgroundAlpha].CGColor];
		[_brightnessView addButton:brightnessLeftButton target:self action:@selector(changeSlider) isMin:YES];

		UIButton *volumeLeftButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		volumeLeftButton.frame = CGRectMake(0, 0, 30, 30);
		volumeLeftButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
		[volumeLeftButton setTitle:@"" forState:UIControlStateNormal];
		[volumeLeftButton addTarget:self action:@selector(changeSlider) forControlEvents:UIControlEventTouchUpInside];
		[volumeLeftButton.layer setCornerRadius:15];
		[volumeLeftButton.layer setBackgroundColor:[UIColor colorWithWhite:0.2 alpha:[SCPreferences sharedInstance].multiSliderBackgroundAlpha].CGColor];
		[_volumeView addButton:volumeLeftButton target:self action:@selector(changeSlider) isMin:YES];

		UIButton *brightnessRightButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		brightnessRightButton.frame = CGRectMake(0, 0, 30, 30);
		brightnessRightButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
		[brightnessRightButton setTitle:@"" forState:UIControlStateNormal];
		[brightnessRightButton addTarget:self action:@selector(changeSlider) forControlEvents:UIControlEventTouchUpInside];
		[brightnessRightButton.layer setCornerRadius:15];
		[brightnessRightButton.layer setBackgroundColor:[UIColor colorWithWhite:0.2 alpha:[SCPreferences sharedInstance].multiSliderBackgroundAlpha].CGColor];
		[_brightnessView addButton:brightnessRightButton target:self action:@selector(changeSlider) isMin:NO];

		UIButton *volumeRightButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		volumeRightButton.frame = CGRectMake(0, 0, 30, 30);
		volumeRightButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
		[volumeRightButton setTitle:@"" forState:UIControlStateNormal];
		[volumeRightButton addTarget:self action:@selector(changeSlider) forControlEvents:UIControlEventTouchUpInside];
		[volumeRightButton.layer setCornerRadius:15];
		[volumeRightButton.layer setBackgroundColor:[UIColor colorWithWhite:0.2 alpha:[SCPreferences sharedInstance].multiSliderBackgroundAlpha].CGColor];
		[_volumeView addButton:volumeRightButton target:self action:@selector(changeSlider) isMin:NO];

		isBrightnessVisible = YES;
	}
	return self;
}

-(void)dealloc {
	[_brightnessView release];
	[_volumeView release];
	[super dealloc];
}

-(void)changeSlider {
	if (isBrightnessVisible) {
		_brightnessView.hidden = YES;
		_volumeView.hidden = NO;
	} else {
		_volumeView.hidden = YES;
		_brightnessView.hidden = NO;
	}
	isBrightnessVisible = !isBrightnessVisible;
}
@end