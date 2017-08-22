#import "headers.h"

@implementation ControlCenterAirPlaySectionView
-(id)initWithFrame:(CGRect)frame {
	frame = CGRectMake(frame.origin.x + 20, frame.origin.y, frame.size.width - 40, frame.size.height);
	self = [super initWithFrame:frame];
	if (self != nil) {
		_airPlayController = [[objc_getClass("CCUIAirStuffSectionController") alloc] init];
		[_airPlayController setDelegate:self];
		_airPlayController.view.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
		[self addSubview:[_airPlayController view]];

		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
			UIAlertController *_airDropAlertController = (UIAlertController *)[_airPlayController valueForKey:@"_airDropAlertController"];
			[_airDropAlertController setPreferredStyle:UIAlertControllerStyleAlert];
		}
	}
	return self;
}

-(void)dealloc {
	[_airPlayController release];
	[super dealloc];
}
@end


%hook CCUIControlCenterButton
-(void)layoutSubviews {
	%orig();
	
	if ([self superview] != nil && ([[[self superview] class] isEqual:[ControlCenterAirPlaySectionView class]] || ([[self superview] superview] != nil && [[[[self superview] superview] class] isEqual:[ControlCenterAirPlaySectionView class]]))) {
		if (UIInterfaceOrientationIsPortrait([[%c(SpringBoard) sharedApplication] activeInterfaceOrientation])) {
			if ([SCPreferences sharedInstance].isPortraitNightAndAirLabelsHidden) {
				UIView *parent = [self superview];
				if ([[parent class] isEqual:[ControlCenterAirPlaySectionView class]] || [[[parent superview] class] isEqual:[ControlCenterAirPlaySectionView class]]) {
					[(UILabel *)[self valueForKey:@"_label"] setHidden:YES];
					[(UILabel *)[self valueForKey:@"_alteredStateLabel"] setHidden:YES];
					((UIImageView *)[self valueForKey:@"_glyphImageView"]).center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
					((UIImageView *)[self valueForKey:@"_alteredStateGlyphImageView"]).center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
				}
			}
		} else {
			if ([SCPreferences sharedInstance].isLandscapeNightAndAirLabelsHidden) {
				UIView *parent = [self superview];
				if ([[parent class] isEqual:[ControlCenterAirPlaySectionView class]] || [[[parent superview] class] isEqual:[ControlCenterAirPlaySectionView class]]) {
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