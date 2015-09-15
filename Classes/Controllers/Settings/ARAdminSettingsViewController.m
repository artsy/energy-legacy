@import Artsy_UIFonts;
#import "ARAdminSettingsViewController.h"
#import "AROptions.h"
#import "ARTableViewCell.h"
#import "ARToggleSwitch.h"
#import "ARTheme.h"

NS_ENUM(NSInteger, ARAdminSettingsSection){
    ARAdminSettingSectionPublic,
};


@interface ARAdminSettingsViewController ()
@property (nonatomic, copy) NSArray *userOptions;
@property (nonatomic, copy) NSArray *labOptions;
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) NSUserDefaults *defaults;
@end


@implementation ARAdminSettingsViewController

- (instancetype)initWithContext:(NSManagedObjectContext *)context labOptions:(NSArray *)labOptions
{
    self = [super init];
    if (!self) return nil;

    _context = context;
    self.title = @"Admin Settings";

    Partner *partner = [Partner currentPartnerInContext:_context];
    NSMutableArray *userOptions = [NSMutableArray array];
    _labOptions = labOptions;

    [userOptions addObject:@{
        AROptionsKey : AROptionsUseWhiteFolio,
        AROptionsName : @"White Folio"
    }];

    if ([partner hasWorksWithPrice]) {
        [userOptions addObject:@{
            AROptionsKey : ARShowPrices,
            AROptionsName : @"Show Artwork Prices"
        }];
    }

    if ([partner hasPublishedWorks]) {
        [userOptions addObject:@{
            AROptionsKey : ARHideUnpublishedWorks,
            AROptionsName : @"Hide Unpublished Works"
        }];
    }

    if ([partner hasForSaleWorks]) {
        [userOptions addObject:@{
            AROptionsKey : ARShowAvailableOnly,
            AROptionsName : @"Show For Sale Works Only"
        }];
    }

    if ([partner hasConfidentialNotes]) {
        [userOptions addObject:@{
            AROptionsKey : ARShowConfidentialNotes,
            AROptionsName : @"Show Confidential Notes"
        }];
    }

    _userOptions = [NSArray arrayWithArray:userOptions];

    return self;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[ARTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"support"];
    cell.textLabel.text = [self titleForRow:indexPath.row inSection:indexPath.section];

    ARToggleSwitch *toggle = [ARToggleSwitch button];
    NSString *option = [self defaultForRow:indexPath.row inSection:indexPath.section];
    toggle.on = [self.defaults boolForKey:option];
    toggle.userInteractionEnabled = NO;

    cell.accessoryView = toggle;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *option = [self defaultForRow:indexPath.row inSection:indexPath.section];

    BOOL on = ![self.defaults boolForKey:option];
    [self.defaults setBool:on forKey:option];
    [self.defaults synchronize];

    ARToggleSwitch *toggle = (id)[tableView cellForRowAtIndexPath:indexPath].accessoryView;
    toggle.on = on;

    if ([option isEqualToString:AROptionsUseWhiteFolio]) {
        [ARTheme setupWithWhiteFolio:on];
    }

    [[NSNotificationCenter defaultCenter] postNotificationName:ARUserDidChangeGridFilteringSettingsNotification object:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (section == ARAdminSettingSectionPublic) ? self.userOptions.count : self.labOptions.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.labOptions.count ? 2 : 1;
}

- (CGFloat)tableView:(UITableView *)aTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ARTableViewCellSettingsHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) return 0;
    return 32;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return nil;
    }

    UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 32)];
    UILabel *label = [[ARSansSerifLabel alloc] initWithFrame:CGRectMake(10, 0, 320, 32)];
    label.text = @"Artsy Admin only settings";
    label.font = [UIFont sansSerifFontWithSize:14];
    [container addSubview:label];
    return container;
}

- (NSString *)titleForRow:(NSInteger)row inSection:(NSInteger)section
{
    NSArray *settings = (section == ARAdminSettingSectionPublic) ? self.userOptions : self.labOptions;
    return settings[row][AROptionsName];
}

- (NSString *)defaultForRow:(NSInteger)row inSection:(NSInteger)section
{
    NSArray *settings = (section == ARAdminSettingSectionPublic) ? self.userOptions : self.labOptions;
    return settings[row][AROptionsKey];
}

- (CGSize)preferredContentSize
{
    CGFloat contentHeight = 64;
    for (NSInteger i = 0; i < [self numberOfSectionsInTableView:self.tableView]; ++i) {
        contentHeight += [self tableView:self.tableView numberOfRowsInSection:i] * ARTableViewCellSettingsHeight;
        if (i == 1) {
            contentHeight += 32;
        }
    }

    return CGSizeMake(320, contentHeight);
}

- (NSUserDefaults *)defaults
{
    return _defaults ?: [NSUserDefaults standardUserDefaults];
}

@end
