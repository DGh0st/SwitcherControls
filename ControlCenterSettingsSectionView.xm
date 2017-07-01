#import "headers.h"

@implementation ControlCenterSettingsSectionView
-(id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self != nil) {
		_settingsController = [[objc_getClass("CCUISettingsSectionController") alloc] init];
		[_settingsController setDelegate:self];
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone && screenSize.height <= 568)
			_settingsController.view.frame = CGRectMake(8, 8, frame.size.width - 16, 48);
		else
			_settingsController.view.frame = CGRectMake(20, 8, frame.size.width - 40, 48);
		_settingsController.view.center = CGPointMake(frame.size.width / 2, frame.size.height / 2);

		[self addSubview:_settingsController.view];
	}
	return self;
}

-(void)dealloc {
	[_settingsController release];
	[super dealloc];
}
@end