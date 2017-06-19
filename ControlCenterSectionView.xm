#import "headers.h"

@implementation ControlCenterSectionView
-(NSInteger)layoutStyle {
	return 0;
}

-(void)noteSectionEnabledStateDidChange:(id)arg1 {
	[self setNeedsLayout];
}

-(void)sectionWantsControlCenterDismissal:(id)arg1 {
	[(SBMainSwitcherViewController *)[objc_getClass("SBMainSwitcherViewController") sharedInstance] dismissSwitcherNoninteractively];
}

-(id)controlCenterSystemAgent {
	return [[objc_getClass("SBControlCenterController") sharedInstance] valueForKey:@"_systemAgent"];
}

-(void)beginSuppressingPunchOutMaskCachingForReason:(id)arg1 {

}

-(void)endSuppressingPunchOutMaskCachingForReason:(id)arg1 {

}

-(void)section:(id)arg1 publishStatusUpdate:(CCUIControlCenterStatusUpdate *)arg2 {
	
}
@end