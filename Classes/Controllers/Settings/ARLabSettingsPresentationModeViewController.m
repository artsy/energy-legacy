#import "ARLabSettingsPresentationModeViewController.h"
#import "ARTableViewCell.h"
#import "AROptions.h"
#import "ARToggleSwitch.h"
#import <Artsy+UIFonts/UIFont+ArtsyFonts.h>
#import "NSString+NiceAttributedStrings.h"
#import "Partner+InventoryHelpers.h"


@interface ARLabSettingsPresentationModeViewController ()
@property (nonatomic, copy) NSArray *presentationModeOptions;
@property (weak, nonatomic) IBOutlet UILabel *explanatoryTextLabel;

@end


@implementation ARLabSettingsPresentationModeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.explanatoryTextLabel.attributedText = [self.explanatoryTextLabel.text attributedStringWithLineSpacing:8];

    [self.navigationController setNavigationBarHidden:[UIDevice isPad]];

    Partner *partner = [Partner currentPartnerInContext:self.context];
    if (![partner hasUploadedWorks]) return; // zero state

    NSMutableArray *presentationModeOptions = [NSMutableArray array];

    if ([partner hasWorksWithPrice]) {
        [presentationModeOptions addObject:@{
            AROptionsKey : ARHideAllPrices,
            AROptionsName : @"Hide All Artwork Prices",
        }];
    }

    if ([partner hasSoldWorksWithPrices]) {
        [presentationModeOptions addObject:@{
            AROptionsKey : ARHidePricesForSoldWorks,
            AROptionsName : @"Hide Prices For Sold Works Only",
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
            AROptionsName : @"Hide Not For Sale Works",
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

    [[NSNotificationCenter defaultCenter] postNotificationName:ARUserDidChangeGridFilteringSettingsNotification object:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.presentationModeOptions.count;
}

- (NSManagedObjectContext *)context
{
    return _context ?: [CoreDataManager mainManagedObjectContext];
}

- (NSUserDefaults *)defaults
{
    return _defaults ?: [NSUserDefaults standardUserDefaults];
}

@end
