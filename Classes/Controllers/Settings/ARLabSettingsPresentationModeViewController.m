#import "ARLabSettingsPresentationModeViewController.h"
#import "ARTableViewCell.h"
#import "AROptions.h"
#import "ARToggleSwitch.h"
#import <Artsy+UIFonts/UIFont+ArtsyFonts.h>
#import "NSString+NiceAttributedStrings.h"
#import "Partner+InventoryHelpers.h"
#import "UIViewController+SettingsNavigationItemHelpers.h"


@interface ARLabSettingsPresentationModeViewController ()
@property (nonatomic, copy) NSArray *presentationModeOptions;
@property (weak, nonatomic) IBOutlet UILabel *explanatoryTextLabel;

@end


@implementation ARLabSettingsPresentationModeViewController

@synthesize section;

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (!self) return nil;

    self.section = ARLabSettingsSectionEditPresentationMode;

    self.title = @"Edit Presentation Mode".uppercaseString;

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setupNavigationBar];

    self.explanatoryTextLabel.attributedText = [self.explanatoryTextLabel.text attributedStringWithLineSpacing:8];

    Partner *partner = [Partner currentPartnerInContext:self.context];

    NSMutableArray *presentationModeOptions = [NSMutableArray array];

    if ([partner hasWorksWithPrice]) {
        [presentationModeOptions addObject:@{
            AROptionsKey : ARHideAllPrices,
            AROptionsName : @"Hide Prices",
        }];
    }

    if ([partner hasSoldWorksWithPrices]) {
        [presentationModeOptions addObject:@{
            AROptionsKey : ARHidePricesForSoldWorks,
            AROptionsName : @"Hide Price For Sold Works",
        }];
    }

    if ([partner hasUnpublishedWorks] && [partner hasPublishedWorks]) {
        [presentationModeOptions addObject:@{
            AROptionsKey : ARHideUnpublishedWorks,
            AROptionsName : @"Hide Unpublished Works",
        }];
    }

    if ([partner hasNotForSaleWorks] && [partner hasForSaleWorks]) {
        [presentationModeOptions addObject:@{
            AROptionsKey : ARHideWorksNotForSale,
            AROptionsName : @"Hide Works Not For Sale",
        }];
    }

    [presentationModeOptions addObject:@{
        AROptionsKey : ARHideConfidentialNotes,
        AROptionsName : @"Hide Confidential Notes",
    }];

    [presentationModeOptions addObject:@{
        AROptionsKey : ARHideArtworkEditButton,
        AROptionsName : @"Hide Artwork Edit Button",
    }];

    _presentationModeOptions = [NSArray arrayWithArray:presentationModeOptions];

    /// extends the height of the tableview header; unfortunately, you can't do this with autolayout size classes yet
    if ([UIDevice isPhone]) {
        UIView *header = self.tableView.tableHeaderView;
        CGRect frame = header.frame;
        frame.size.height = frame.size.height + 20;
        header.frame = frame;
        [self.tableView updateConstraintsIfNeeded];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *option = self.presentationModeOptions[indexPath.row];

    UITableViewCell *cell = [[ARTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"presentationMode"];
    cell.textLabel.text = option[AROptionsName];
    cell.textLabel.font = [UIFont serifFontWithSize:17];

    ARToggleSwitch *toggle = [ARToggleSwitch buttonWithFrame:CGRectMake(0, 0, 76, 28)];
    toggle.on = [self.defaults boolForKey:option[AROptionsKey]];
    toggle.userInteractionEnabled = NO;

    cell.accessoryView = toggle;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *option = self.presentationModeOptions[indexPath.row];

    BOOL on = ![self.defaults boolForKey:option[AROptionsKey]];
    [self.defaults setBool:on forKey:option[AROptionsKey]];
    [self.defaults synchronize];

    ARToggleSwitch *toggle = (id)[tableView cellForRowAtIndexPath:indexPath].accessoryView;
    toggle.on = on;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.presentationModeOptions.count;
}

- (void)setTitle:(NSString *)title
{
    if ([UIDevice isPad]) {
        [super setTitle:title];
        return;
    }

    [self addTitleViewWithText:title font:[UIFont sansSerifFontWithSize:ARPhoneFontSansRegular] xOffset:40];
}

- (NSManagedObjectContext *)context
{
    return _context ?: [CoreDataManager mainManagedObjectContext];
}

- (NSUserDefaults *)defaults
{
    return _defaults ?: [NSUserDefaults standardUserDefaults];
}

- (void)setupNavigationBar
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];

    if ([UIDevice isPhone]) {
        [self addSettingsBackButtonWithTarget:@selector(returnToMasterViewController) animated:YES];
    }
}

- (void)returnToMasterViewController
{
    [self.navigationController.navigationController popToRootViewControllerAnimated:YES];
}

@end
