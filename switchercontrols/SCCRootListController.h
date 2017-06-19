#import <Preferences/Preferences.h>
#import <Preferences/PSSliderTableCell.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface PSRootController (SwitcherControlsPrefs)
+(void)setPreferenceValue:(id)arg1 specifier:(id)arg2;
@end

@interface SCCSliderCell : PSSliderTableCell <UIAlertViewDelegate, UITextFieldDelegate> {
	CGFloat minValue;
	CGFloat maxValue;
}
-(void)presentAlert;
@end

@interface SCCRootListController : PSListController <MFMailComposeViewControllerDelegate>
@end

@interface SCCAdvancedListController : PSListController
@end

@interface SCCSectionsListController : PSViewController <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *topSection;
@property (nonatomic, strong) NSMutableArray *bottomStickySection;
@property (nonatomic, strong) NSMutableArray *bottomSections;
@property (nonatomic, strong) NSMutableArray *hiddenSections;
@property (nonatomic, strong) NSMutableArray *allSections;
@property (nonatomic, strong) NSDictionary *prefs;
@end