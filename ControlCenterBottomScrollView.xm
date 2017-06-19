#import "headers.h"

@implementation ControlCenterBottomScrollView
-(id)initWithFrame:(CGRect)frame {
	frame = CGRectMake(frame.origin.x + 20, frame.origin.y, frame.size.width - 40, frame.size.height);
	self = [super initWithFrame:frame];
	if (self) {
		CGRect topViewFrame = CGRectMake(0, 0, frame.size.width, 64);
		CGRect middleViewFrame = CGRectMake(0, 74, frame.size.width, 64);
		CGRect bottomViewFrame = CGRectMake(0, 148, frame.size.width, 64);
		CGRect firstPageViewFrame = CGRectMake(0, 0, frame.size.width, frame.size.height);
		CGRect secondPageViewFrame = CGRectMake(frame.size.width, 0, frame.size.width, frame.size.height);
		CGRect thirdPageViewFrame = CGRectMake(frame.size.width * 2, 0, frame.size.width, frame.size.height);

		UIView *view = [[UIView alloc] initWithFrame:firstPageViewFrame];

		Class topClass = [[SCPreferences sharedInstance] sectionClass:kBottom withIndex:0];
		Class middleClass = [[SCPreferences sharedInstance] sectionClass:kBottom withIndex:1];
		Class bottomClass = [[SCPreferences sharedInstance] sectionClass:kBottom withIndex:2];

		if (topClass == [ControlCenterFailureSectionClass class] && middleClass == [ControlCenterFailureSectionClass class] && bottomClass == [ControlCenterFailureSectionClass class]) {
			thirdPageViewFrame.origin.x = secondPageViewFrame.origin.x;
			secondPageViewFrame.origin.x = firstPageViewFrame.origin.x;
			firstPageViewFrame = CGRectZero;
			view.frame = CGRectZero;
		} else if (middleClass == [ControlCenterFailureSectionClass class] && bottomClass == [ControlCenterFailureSectionClass class]) {
			ControlCenterSectionView *topSection = [[topClass alloc] initWithFrame:topViewFrame];
			//topSection.center = CGPointMake(firstPageViewFrame.size.width / 2, firstPageViewFrame.size.height / 2);
			[view addSubview:topSection];

			[topSection release];
		} else {
			ControlCenterSectionView *topSection = [[topClass alloc] initWithFrame:topViewFrame];
			[view addSubview:topSection];

			ControlCenterSectionView *middleSection = [[middleClass alloc] initWithFrame:middleViewFrame];
			[view addSubview:middleSection];

			if (bottomClass != [ControlCenterFailureSectionClass class]) {
				ControlCenterSectionView *bottomSection = [[bottomClass alloc] initWithFrame:bottomViewFrame];
				[view addSubview:bottomSection];

				[bottomSection release];
			}
			
			[topSection release];
			[middleSection release];
		}

		ControlCenterMediaSectionView *mediaSection = [[ControlCenterMediaSectionView alloc] initWithFrame:secondPageViewFrame];
		[mediaSection setupRoutingPageWithFrame:thirdPageViewFrame];

		[self addSubview:view];
		[self addSubview:mediaSection];

		self.contentSize = CGSizeMake(firstPageViewFrame.size.width + secondPageViewFrame.size.width + thirdPageViewFrame.size.width, frame.size.height);
		self.pagingEnabled = YES;
		[self setShowsHorizontalScrollIndicator:NO];
		
		[view release];
		[mediaSection release];
	}
	return self;
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