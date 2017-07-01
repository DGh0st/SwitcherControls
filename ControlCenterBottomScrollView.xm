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
		} else {
			if (![topClass isEqual:[ControlCenterFailureSectionClass class]]) {
				ControlCenterSectionView *topSection = [[topClass alloc] initWithFrame:topViewFrame];

				CGFloat additionalHeight = (topSection.frame.size.height - topViewFrame.size.height);
				frame.size.height += additionalHeight;
				middleViewFrame.origin.y += additionalHeight;

				[view addSubview:topSection];

				[topSection release];
			} else {
				bottomViewFrame = middleViewFrame;
				middleViewFrame = topViewFrame;
			}

			if (![middleClass isEqual:[ControlCenterFailureSectionClass class]]) {
				ControlCenterSectionView *middleSection = [[middleClass alloc] initWithFrame:middleViewFrame];

				CGFloat additionalHeight = (middleSection.frame.size.height - middleViewFrame.size.height);
				frame.size.height += additionalHeight;
				bottomViewFrame.origin.y += additionalHeight;

				[view addSubview:middleSection];

				[middleSection release];
			} else {
				bottomViewFrame = middleViewFrame;
			}

			if (![bottomClass isEqual:[ControlCenterFailureSectionClass class]]) {
				ControlCenterSectionView *bottomSection = [[bottomClass alloc] initWithFrame:bottomViewFrame];

				CGFloat additionalHeight = (bottomSection.frame.size.height - bottomViewFrame.size.height);
				frame.size.height += additionalHeight;

				[view addSubview:bottomSection];

				[bottomSection release];
			}
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