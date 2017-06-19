#import "headers.h"

@implementation ControlCenterQuickLaunchSectionView
-(id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self != nil) {
		_quickLaunchController = [[objc_getClass("CCUIQuickLaunchSectionController") alloc] init];
		[_quickLaunchController setDelegate:self];
		_quickLaunchController.view.frame = CGRectMake(20, 2, frame.size.width - 40, 60);
		_quickLaunchController.view.center = CGPointMake(frame.size.width / 2, frame.size.height / 2);

		[self addSubview:_quickLaunchController.view];
	}
	return self;
}

-(void)dealloc {
	[_quickLaunchController release];
	[super dealloc];
}
@end