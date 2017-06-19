#import "headers.h"

@implementation ControlCenterNightAndAirPlaySectionView
-(id)initWithFrame:(CGRect)frame {
	frame = CGRectMake(frame.origin.x + 20, frame.origin.y, frame.size.width - 40, frame.size.height);
	self = [super initWithFrame:frame];
	if (self != nil) {
		NSInteger numOfSections = [self numOfSections];
		NSInteger currSection = 0;
		NSInteger sectionWidth = frame.size.width / numOfSections;

		_nightShiftController = [[objc_getClass("CCUINightShiftSectionController") alloc] init];
		[_nightShiftController setDelegate:self];
		[_nightShiftController view].frame = CGRectMake(currSection * sectionWidth, 0, sectionWidth - 1, frame.size.height);

		CCUIControlCenterPushButton *nightShiftSection = [(CCUINightShiftContentView *)[_nightShiftController view] button];
		nightShiftSection.frame = [_nightShiftController view].frame;
		nightShiftSection.roundCorners = 5;
		[self addSubview:nightShiftSection];

		currSection++;

		if (%c(OGYNightSectionController)) {
			_ogygiaController = [[%c(OGYNightSectionController) alloc] init];
			[_ogygiaController setDelegate:self];
			_ogygiaController.view.frame = CGRectMake(currSection * sectionWidth, 0, 2 * sectionWidth, frame.size.height);

			CCUIControlCenterPushButton *darkModeSection = [_ogygiaController nightModeSection];
			darkModeSection.frame = CGRectMake(currSection * sectionWidth, 0, sectionWidth - 1, frame.size.height);
			darkModeSection.roundCorners = 0;
			((UIView *)[darkModeSection valueForKey:@"_backgroundFlatColorView"]).layer.cornerRadius = 0;

			[self addSubview:darkModeSection];

			currSection++;
		}

		if (%c(LQDNightSectionController)) {
			_noctisController = [[%c(LQDNightSectionController) alloc] init];
			[_noctisController setDelegate:self];
			_noctisController.view.frame = CGRectMake(0, 0, 2 * sectionWidth, frame.size.height);

			CCUIControlCenterPushButton *darkModeSection = [_noctisController nightModeSection];
			darkModeSection.frame = CGRectMake(currSection * sectionWidth, 0, sectionWidth - 1, frame.size.height);
			darkModeSection.roundCorners = 0;
			((UIView *)[darkModeSection valueForKey:@"_backgroundFlatColorView"]).layer.cornerRadius = 0;

			[self addSubview:darkModeSection];

			currSection++;
		}
	
		_airPlayController = [[objc_getClass("CCUIAirStuffSectionController") alloc] init];
		[_airPlayController setDelegate:self];
		_airPlayController.view.frame = CGRectMake(currSection * sectionWidth, 0, 2 * sectionWidth, frame.size.height);

		CCUIControlCenterPushButton *airButton = (CCUIControlCenterPushButton *)[_airPlayController valueForKey:@"_airPlaySection"];
		airButton.roundCorners = 0;
		((UIView *)[airButton valueForKey:@"_backgroundFlatColorView"]).layer.cornerRadius = 0;
		airButton.hidden = NO;

		CCUIControlCenterButton *airDropButton = (CCUIControlCenterButton *)[_airPlayController valueForKey:@"_airDropSection"];
		airDropButton.hidden = NO;
		[self addSubview:_airPlayController.view];

		currSection += 2;

		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
			UIAlertController *_airDropAlertController = (UIAlertController *)[_airPlayController valueForKey:@"_airDropAlertController"];
			[_airDropAlertController setPreferredStyle:UIAlertControllerStyleAlert];
		}
	}
	return self;
}

-(void)dealloc {
	if (_noctisController != nil) {
		[_noctisController release];
		_noctisController = nil;
	}

	if (_ogygiaController != nil) {
		[_ogygiaController release];
		_ogygiaController = nil;
	}

	[_nightShiftController release];
	[_airPlayController release];
	[super dealloc];
}

-(void)layoutSubviews {
	[super layoutSubviews];

	NSInteger sectionWidth = self.frame.size.width / [self numOfSections];
	CCUIControlCenterPushButton *nightShiftSection = [(CCUINightShiftContentView *)[_nightShiftController view] button];
	nightShiftSection.frame = CGRectMake(0, 0, sectionWidth - 1, self.frame.size.height);

	CCUIControlCenterPushButton *airButton = (CCUIControlCenterPushButton *)[_airPlayController valueForKey:@"_airPlaySection"];
	airButton.hidden = NO;

	CCUIControlCenterButton *airDropButton = (CCUIControlCenterButton *)[_airPlayController valueForKey:@"_airDropSection"];
	airDropButton.hidden = NO;
}

-(NSInteger)numOfSections {
	NSInteger numOfSections = 3;
	if (%c(OGYNightSectionController))
		numOfSections++;
	if (%c(LQDNightSectionController))
		numOfSections++;
	return numOfSections;
}
@end


%hook CCUIControlCenterButton
-(void)layoutSubviews {
	%orig();
	
	if ([self superview] != nil && ([[[self superview] class] isEqual:[ControlCenterNightAndAirPlaySectionView class]] || ([[self superview] superview] != nil && [[[[self superview] superview] class] isEqual:[ControlCenterNightAndAirPlaySectionView class]]))) {
		if (UIInterfaceOrientationIsPortrait([[%c(SpringBoard) sharedApplication] activeInterfaceOrientation])) {
			if ([SCPreferences sharedInstance].isPortraitNightAndAirLabelsHidden) {
				UIView *parent = [self superview];
				if ([[parent class] isEqual:[ControlCenterNightAndAirPlaySectionView class]] || [[[parent superview] class] isEqual:[ControlCenterNightAndAirPlaySectionView class]]) {
					[(UILabel *)[self valueForKey:@"_label"] setHidden:YES];
					[(UILabel *)[self valueForKey:@"_alteredStateLabel"] setHidden:YES];
					((UIImageView *)[self valueForKey:@"_glyphImageView"]).center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
					((UIImageView *)[self valueForKey:@"_alteredStateGlyphImageView"]).center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
				}
			}
		} else {
			if ([SCPreferences sharedInstance].isLandscapeNightAndAirLabelsHidden) {
				UIView *parent = [self superview];
				if ([[parent class] isEqual:[ControlCenterNightAndAirPlaySectionView class]] || [[[parent superview] class] isEqual:[ControlCenterNightAndAirPlaySectionView class]]) {
					[(UILabel *)[self valueForKey:@"_label"] setHidden:YES];
					[(UILabel *)[self valueForKey:@"_alteredStateLabel"] setHidden:YES];
					((UIImageView *)[self valueForKey:@"_glyphImageView"]).center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
					((UIImageView *)[self valueForKey:@"_alteredStateGlyphImageView"]).center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
				}
			}
		}
	}
}
%end