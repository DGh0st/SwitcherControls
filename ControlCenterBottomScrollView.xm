#import "headers.h"

@implementation ControlCenterBottomScrollView
-(id)initWithFrame:(CGRect)frame {
	frame = CGRectMake(frame.origin.x + 20, frame.origin.y, frame.size.width - 40, frame.size.height);
	self = [super initWithFrame:frame];
	if (self) {
		CGRect firstPageViewFrame = CGRectMake(0, 0, frame.size.width, frame.size.height);
		CGRect secondPageViewFrame = CGRectMake(frame.size.width, 0, frame.size.width, frame.size.height);
		CGRect thirdPageViewFrame = CGRectMake(frame.size.width * 2, 0, frame.size.width, frame.size.height);

		UIView *view = [[UIView alloc] initWithFrame:firstPageViewFrame];

		NSInteger totalSections = 0;
		CGFloat currentOriginY = 0;
		if ([SCPreferences sharedInstance].bottomSection != nil) {
			for (NSInteger i = 0; i < [[SCPreferences sharedInstance].bottomSection count]; i++) {
				Class currentClass = [[SCPreferences sharedInstance] sectionClass:kBottom withIndex:i];
				if (currentClass != [ControlCenterFailureSectionClass class]) {
					totalSections++;
					CGRect currentFrame = CGRectMake(0, currentOriginY, frame.size.width, 64);
					ControlCenterSectionView *currentSection = [[currentClass alloc] initWithFrame:currentFrame];

					CGFloat additionalHeight = currentSection.frame.size.height - currentFrame.size.height;
					frame.size.height += additionalHeight;
					currentOriginY += (74 + additionalHeight);

					[view addSubview:currentSection];
					[currentSection release];
				}
			}
		}

		if (totalSections == 0) {
			thirdPageViewFrame.origin.x = secondPageViewFrame.origin.x;
			secondPageViewFrame.origin.x = firstPageViewFrame.origin.x;
			firstPageViewFrame = CGRectZero;
			view.frame = CGRectZero;
		}

		if (frame.size.height < 152)
			frame.size.height = 152;

		firstPageViewFrame.size.height = frame.size.height;
		secondPageViewFrame.size.height = frame.size.height;
		thirdPageViewFrame.size.height = frame.size.height;
		view.frame = firstPageViewFrame;

		ControlCenterMediaSectionView *mediaSection = [[ControlCenterMediaSectionView alloc] initWithFrame:secondPageViewFrame];
		[mediaSection setupRoutingPageWithFrame:thirdPageViewFrame];

		[self addSubview:view];
		[self addSubview:mediaSection];

		self.frame = frame;
		[self resetupScrollWidth:NO];
		self.pagingEnabled = YES;
		[self setShowsHorizontalScrollIndicator:NO];
		
		[view release];
		[mediaSection release];
	}
	return self;
}

-(void)resetupScrollWidth:(BOOL)playing {
	CGFloat scrollWidth = 0;
	if (playing)
		scrollWidth = self.frame.size.width * 3;
	else if ([SCPreferences sharedInstance].isRemoveMediaAndDevicesPagesEnabled)
		scrollWidth = self.frame.size.width;
	else
		scrollWidth = self.frame.size.width * 3;
	self.contentSize = CGSizeMake(scrollWidth, self.frame.size.height);
}

-(void)scrollToPage:(NSInteger)page animated:(BOOL)animated {
	CGRect frame = self.frame;
	frame.origin.x = frame.size.width * page;
	frame.origin.y = 0;
	[self scrollRectToVisible:frame animated:animated];
}

-(NSInteger)currentVisiblePage {
	return (self.contentOffset.x + self.bounds.size.width / 2) / self.bounds.size.width;
}

-(NSInteger)mediaPage {
	if (self.contentSize.width == self.frame.size.width * 2)
		return 0;
	return 1;
}

-(NSInteger)defaultPage {
	if (self.contentSize.width == self.frame.size.width * 2)
		return [SCPreferences sharedInstance].defaultPage - 1;
	return [SCPreferences sharedInstance].defaultPage;
}

-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
	UIView *result = [super hitTest:point withEvent:event];
	if ([result isKindOfClass:[%c(UISlider) class]]) {
		self.scrollEnabled = NO;
	} else {
		self.scrollEnabled = YES;
	}
	return result;
}
@end