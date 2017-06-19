#include "SCCRootListController.h"

#define kSettingsPath @"/var/mobile/Library/Preferences/com.dgh0st.switchercontrols.plist"
#define kBundlePath @"/Library/PreferenceBundles/SwitcherControls.bundle"

@implementation SCCRootListController

- (id)initForContentSize:(CGSize)size {
	self = [super initForContentSize:size];

	if (self != nil) {
		UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[self bundle] pathForResource:@"icon" ofType:@"png"]]];
		iconView.contentMode = UIViewContentModeScaleAspectFit;
		iconView.frame = CGRectMake(0, 0, 29, 29);

		[self.navigationItem setTitleView:iconView];
		[iconView release];
	}

	return self;
}

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"Root" target:self] retain];
	}

	return _specifiers;
}

- (void)email {
	if ([MFMailComposeViewController canSendMail]) {
		MFMailComposeViewController *email = [[MFMailComposeViewController alloc] initWithNibName:nil bundle:nil];
		[email setSubject:@"SwitcherControls Support"];
		[email setToRecipients:[NSArray arrayWithObjects:@"deeppwnage@yahoo.com", nil]];
		[email addAttachmentData:[NSData dataWithContentsOfFile:kSettingsPath] mimeType:@"application/xml" fileName:@"Prefs.plist"];
		#pragma GCC diagnostic push
		#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
		system("/usr/bin/dpkg -l > /tmp/dpkgl.log");
		#pragma GCC diagnostic pop
		[email addAttachmentData:[NSData dataWithContentsOfFile:@"/tmp/dpkgl.log"] mimeType:@"text/plain" fileName:@"dpkgl.txt"];
		[self.navigationController presentViewController:email animated:YES completion:nil];
		[email setMailComposeDelegate:self];
		[email release];
	}
}

- (void)mailComposeController:(id)controller didFinishWithResult:(MFMailComposeResult)result error:(id)error {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)follow {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://mobile.twitter.com/D_Gh0st"]];
}

-(void)respring {
	UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"SwitcherControls" message:@"Are you sure you want to respring?" preferredStyle:UIAlertControllerStyleAlert];

	UIAlertAction *respringAction = [UIAlertAction actionWithTitle:@"Yes, Respring" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
		CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("com.dgh0st.switchercontrols/respring"), NULL, NULL, YES);
	}];

	UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
		[self dismissViewControllerAnimated:YES completion:nil];
	}];

	[alert addAction:respringAction];
	[alert addAction:cancelAction];

	[self presentViewController:alert animated:YES completion:nil];
}

-(void)viewDidLoad {
	[super viewDidLoad];

	UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.table.bounds.size.width, 100)];
	[headerView setBackgroundColor:[UIColor clearColor]];
	[headerView setContentMode:UIViewContentModeCenter];
	[headerView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];

	CGRect frame = CGRectMake(0, 16, self.table.bounds.size.width, 32);
	CGRect underFrame = CGRectMake(0, 56, self.table.bounds.size.width, 24);

	UILabel *label = [[UILabel alloc] initWithFrame:frame];
	[label setNumberOfLines:1];
	label.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:42];
	[label setText:@"SwitcherControls"];
	[label setBackgroundColor:[UIColor clearColor]];
	label.textColor = [UIColor blackColor];
	label.textAlignment = NSTextAlignmentCenter;
	label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	label.contentMode = UIViewContentModeScaleToFill;

	UILabel *underLabel = [[UILabel alloc] initWithFrame:underFrame];
	[underLabel setNumberOfLines:1];
	underLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
	[underLabel setText:@"Merge Control Center and Application Switcher"];
	[underLabel setBackgroundColor:[UIColor clearColor]];
	underLabel.textColor = [UIColor blackColor];
	underLabel.textAlignment = NSTextAlignmentCenter;
	underLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	underLabel.contentMode = UIViewContentModeScaleToFill;

	[headerView addSubview:label];
	[headerView addSubview:underLabel];

	self.table.tableHeaderView = headerView;

	[label release];
	[underLabel release];
	[headerView release];
}

@end

@implementation SCCAdvancedListController

- (id)initForContentSize:(CGSize)size {
	self = [super initForContentSize:size];

	if (self != nil) {
		UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[self bundle] pathForResource:@"advanced" ofType:@"png"]]];
		iconView.contentMode = UIViewContentModeScaleAspectFit;
		iconView.frame = CGRectMake(0, 0, 29, 29);

		[self.navigationItem setTitleView:iconView];
		[iconView release];
	}

	return self;
}

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"Advanced" target:self] retain];
	}

	return _specifiers;
}

@end

@implementation SCCSectionsListController

- (id)init {
	self = [super init];

	if (self != nil) {
		NSBundle *bundle = [[NSBundle alloc] initWithPath:kBundlePath];
		UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[bundle pathForResource:@"sectionOrder" ofType:@"png"]]];
		iconView.contentMode = UIViewContentModeScaleAspectFit;
		iconView.frame = CGRectMake(0, 0, 29, 29);

		[self.navigationItem setTitleView:iconView];

		[iconView release];
		[bundle release];
	}

	return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 4;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	switch (section) {
		case 0:
			return @"Top Section (One - 1 section allowed)";
		case 1:
			return @"Bottom Sticky Section (Two - 1 section allowed)";
		case 2:
			return @"Bottom Sections (Three - 3 section allowed)";
		case 3:
			return @"Hidden Sections";
		default:
			return @"";
	}
}

- (NSMutableArray *)arrayForSection:(NSInteger)section {
	switch (section) {
		case 0:
			return self.topSection;
		case 1:
			return self.bottomStickySection;
		case 2:
			return self.bottomSections;
		case 3:
			return self.hiddenSections;
		default:
			return nil;
	}
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSMutableArray *sectionArray = [self arrayForSection:section];
	return sectionArray == nil ? 0 : [sectionArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SwitcherControlsCell" forIndexPath:indexPath];
	NSMutableArray *section = [self arrayForSection:indexPath.section];

	if (section == nil || [section count] <= indexPath.row)
		return nil;

	if (cell == nil)
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SwitcherControlsCell"];

	cell.textLabel.text = [section objectAtIndex:indexPath.row];

	return cell;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
	if (self.tableView == nil)
		return;

	if (sourceIndexPath == nil || destinationIndexPath == nil) {
		[self.tableView reloadData];
		return;
	}

	NSMutableArray *fromArray = [self arrayForSection:sourceIndexPath.section];
	NSMutableArray *toArray = [self arrayForSection:destinationIndexPath.section];

	if (fromArray == nil || toArray == nil) {
		[self updateArrays];
		[self.tableView reloadData];
		return;
	}

	if (sourceIndexPath.row >= [fromArray count]) {
		[self.tableView reloadData];
		return;
	}

	NSString *objectToMove = [fromArray objectAtIndex:sourceIndexPath.row];
	[fromArray removeObjectAtIndex:sourceIndexPath.row];
	[toArray insertObject:objectToMove atIndex:destinationIndexPath.row];


	NSInteger i = [self.hiddenSections count];
	if (toArray == self.topSection || toArray == self.bottomStickySection)
		i = 1;
	else if (toArray == self.bottomSections)
		i = 3;
	for (; i < [toArray count]; i++) {
		NSString *objectToHide = [toArray objectAtIndex:i];
		[self.hiddenSections insertObject:objectToHide atIndex:0];
		[toArray removeObjectAtIndex:i];
	}

	[self writeSectionsToFile];
	[self.tableView reloadData];
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (void)removeDuplicates {
	NSMutableArray *sections = [NSMutableArray array];
	[sections addObjectsFromArray:self.topSection];
	
	if (self.bottomStickySection != nil && [self.bottomStickySection count] > 0) {
		NSMutableArray *bottomStickyObjects = [NSMutableArray array];
		for (id object in self.bottomStickySection) {
			if (![sections containsObject:object]) {
				[sections addObject:object];
				[bottomStickyObjects addObject:object];
			}
		}
		self.bottomStickySection = bottomStickyObjects;
	}

	if (self.bottomSections != nil && [self.bottomSections count] > 0) {
		NSMutableArray *bottomObjects = [NSMutableArray array];
		for (id object in self.bottomSections) {
			if (![sections containsObject:object]) {
				[sections addObject:object];
				[bottomObjects addObject:object];
			}
		}
		self.bottomSections = bottomObjects;
	}

	if (self.hiddenSections != nil && [self.hiddenSections count] > 0) {
		NSMutableArray *hiddenObjects = [NSMutableArray array];
		for (id object in self.hiddenSections) {
			if (![sections containsObject:object]) {
				[sections addObject:object];
				[hiddenObjects addObject:object];
			}
		}
		self.hiddenSections = hiddenObjects;
	}

	for (id object in self.allSections)
		if (![sections containsObject:object])
			[self.hiddenSections addObject:object];
}

- (void)writeSectionsToFile {
	[self removeDuplicates];

	// create dummy specifiers so that the value are set for the tweak
	PSSpecifier *topSectionSpecifier = [PSSpecifier preferenceSpecifierNamed:@"" target:self set:@selector(setPreferenceValue:specifier:) get:@selector(readPreferenceValue:) detail:nil cell:PSLinkListCell edit:nil];
	[topSectionSpecifier setProperty:@"TopSection" forKey:@"key"];
	[topSectionSpecifier setProperty:@"com.dgh0st.switchercontrols" forKey:@"defaults"];
	[self setPreferenceValue:self.topSection specifier:topSectionSpecifier];

	PSSpecifier *bottomStickySpecifier = [PSSpecifier preferenceSpecifierNamed:@"" target:self set:@selector(setPreferenceValue:specifier:) get:@selector(readPreferenceValue:) detail:nil cell:PSLinkListCell edit:nil];
	[bottomStickySpecifier setProperty:@"BottomStickySection" forKey:@"key"];
	[bottomStickySpecifier setProperty:@"com.dgh0st.switchercontrols" forKey:@"defaults"];
	[self setPreferenceValue:self.bottomStickySection specifier:bottomStickySpecifier];

	PSSpecifier *bottomSpecifier = [PSSpecifier preferenceSpecifierNamed:@"" target:self set:@selector(setPreferenceValue:specifier:) get:@selector(readPreferenceValue:) detail:nil cell:PSLinkListCell edit:nil];
	[bottomSpecifier setProperty:@"BottomSections" forKey:@"key"];
	[bottomSpecifier setProperty:@"com.dgh0st.switchercontrols" forKey:@"defaults"];
	[self setPreferenceValue:self.bottomSections specifier:bottomSpecifier];

	PSSpecifier *hiddenSpecifier = [PSSpecifier preferenceSpecifierNamed:@"" target:self set:@selector(setPreferenceValue:specifier:) get:@selector(readPreferenceValue:) detail:nil cell:PSLinkListCell edit:nil];
	[hiddenSpecifier setProperty:@"HiddenSections" forKey:@"key"];
	[hiddenSpecifier setProperty:@"com.dgh0st.switchercontrols" forKey:@"defaults"];
	[self setPreferenceValue:self.hiddenSections specifier:hiddenSpecifier];

	CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("com.dgh0st.switchercontrols/settingschanged"), NULL, NULL, YES);
}

- (void)updateArrays {
	if (self.prefs != nil) {
		self.topSection = (NSMutableArray *)[self.prefs objectForKey:@"TopSection"];
		self.bottomStickySection = (NSMutableArray *)[self.prefs objectForKey:@"BottomStickySection"];
		self.bottomSections = (NSMutableArray *)[self.prefs objectForKey:@"BottomSections"];
		self.hiddenSections = (NSMutableArray *)[self.prefs objectForKey:@"HiddenSections"];
		self.allSections = [NSMutableArray arrayWithObjects:@"Quick Launch Shortcuts", @"Settings Toggles", @"Brightness Slider", @"NightShift And AirPlay/Drop", @"Volume Slider", @"Multi Slider", nil];

		if ((self.topSection == nil && self.bottomStickySection == nil && self.bottomSections == nil && self.hiddenSections == nil)) {
			self.topSection = [NSMutableArray arrayWithObjects:@"Quick Launch Shortcuts", nil];
			self.bottomStickySection = [NSMutableArray arrayWithObjects:@"Settings Toggles", nil];
			self.bottomSections = [NSMutableArray arrayWithObjects:@"Brightness Slider", @"NightShift And AirPlay/Drop", nil];
			self.hiddenSections = [NSMutableArray arrayWithObjects:@"Volume Slider", @"Multi Slider", nil];
			[self writeSectionsToFile];
		}

		[self removeDuplicates];
		[self.tableView reloadData];
	}
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];

	[self writeSectionsToFile];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];

	[self updateArrays];
}

- (void)viewDidLoad {
	[super viewDidLoad];

	self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
	[self.tableView setDelegate:self];
	[self.tableView setDataSource:self];
	[self.tableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
	[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"SwitcherControlsCell"];
	[self.tableView setEditing:YES];
	[self.tableView setAllowsSelection:NO];

	self.prefs = [NSMutableDictionary dictionaryWithContentsOfFile:kSettingsPath] ?: [NSMutableDictionary dictionary];

	NSBundle *bundle = [[NSBundle alloc] initWithPath:kBundlePath];
	UIImageView *headerView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[bundle pathForResource:@"order" ofType:@"png"]]];
	[headerView setBackgroundColor:[UIColor clearColor]];
	[headerView setContentMode:UIViewContentModeCenter];
	[headerView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
	headerView.frame = CGRectMake(0, 0, self.tableView.bounds.size.width, 200);

	self.tableView.tableHeaderView = headerView;
	self.view = self.tableView;

	[headerView release];
	[bundle release];
}

- (void)dealloc {
	[self.tableView release];
	[super dealloc];
}

@end

@implementation SCCSliderCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(id)identifier specifier:(PSSpecifier *)specifier {
	self = [super initWithStyle:style reuseIdentifier:identifier specifier:specifier];
	if (self != nil) {
		CGRect frame = [self frame];
		UIButton *alertButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		alertButton.frame = CGRectMake(frame.size.width - 50, 0, 50, frame.size.height);
		alertButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
		[alertButton setTitle:@"" forState:UIControlStateNormal];
		[alertButton addTarget:self action:@selector(presentAlert) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:alertButton];
	}
	return self;
}

- (void)presentAlert {
	minValue = [[self.specifier propertyForKey:@"min"] floatValue];
	maxValue = [[self.specifier propertyForKey:@"max"] floatValue];

	NSString *rangeString = [NSString stringWithFormat:@"Please enter a value between %.2f and %.2f", minValue, maxValue];
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:self.specifier.name message:rangeString delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Enter", nil];
	alert.alertViewStyle = UIAlertViewStylePlainTextInput;
	alert.tag = 342879;
	[alert show];

	[[alert textFieldAtIndex:0] setDelegate:self];
	[[alert textFieldAtIndex:0] resignFirstResponder];
	[[alert textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeDecimalPad];
	[[alert textFieldAtIndex:0] becomeFirstResponder];
	[alert release];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	if (alertView.tag == 342879 && buttonIndex == 1) {
		CGFloat value = [[alertView textFieldAtIndex:0].text floatValue];
		[[alertView textFieldAtIndex:0] resignFirstResponder];

		if (value <= [[self.specifier propertyForKey:@"max"] floatValue] && value >= [[self.specifier propertyForKey:@"min"] floatValue]) {
			[self setValue:[NSNumber numberWithFloat:value]];
			[PSRootController setPreferenceValue:[NSNumber numberWithFloat:value] specifier:self.specifier];
		} else {
			UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"The value entered is not valid. Try again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
			errorAlert.tag = 85230234;
			[errorAlert show];
			[errorAlert release];
		}
	} else if (alertView.tag == 85230234) {
		[self presentAlert];
	}
}
@end