#import "ARLabSettingsPresentationModeViewController.h"
#import "ARTableViewCell.h"
#import "AROptions.h"
#import "ARToggleSwitch.h"
#import <Artsy+UIFonts/UIFont+ArtsyFonts.h>
#import "NSString+NiceAttributedStrings.h"


@interface ARLabSettingsPresentationModeViewController ()
@property (nonatomic, copy) NSArray *presentationModeOptions;
@property (weak, nonatomic) IBOutlet UILabel *explanatoryTextLabel;

@end


@implementation ARLabSettingsPresentationModeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.explanatoryTextLabel.attributedText = [self.explanatoryTextLabel.text attributedStringWithLineSpacing:8];

    Partner *partner = [Partner currentPartnerInContext:self.context];
    NSMutableArray *presentationModeOptions = [NSMutableArray array];

    if ([partner hasWorksWithPrice]) {
        [presentationModeOptions addObject:@{
            AROptionsKey : ARShowPrices,
            AROptionsName : @"Hide All Artwork Prices"
        }];
    }

    if ([partner hasForSaleWorks]) {
        [presentationModeOptions addObject:@{
            AROptionsKey : ARShowPrices,
            AROptionsName : @"Hide Prices For Sold Works Only"
        }];
    }

    if ([partner hasPublishedWorks]) {
        [presentationModeOptions addObject:@{
            AROptionsKey : ARHideUnpublishedWorks,
            AROptionsName : @"Hide Unpublished Works"
        }];
    }

    if ([partner hasConfidentialNotes]) {
        [presentationModeOptions addObject:@{
            AROptionsKey : ARShowPrices,
            AROptionsName : @"Hide Not For Sale Works"
        }];
    }

    if ([partner hasConfidentialNotes]) {
        [presentationModeOptions addObject:@{
            AROptionsKey : ARShowPrices,
            AROptionsName : @"Hide Artwork Edit Button"
        }];
    }

    self.presentationModeOptions = [NSArray arrayWithArray:presentationModeOptions];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[ARTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"presentationMode"];
    cell.textLabel.text = self.presentationModeOptions[indexPath.row][AROptionsName];
    cell.textLabel.font = [UIFont serifFontWithSize:17];

    ARToggleSwitch *toggle = [ARToggleSwitch buttonWithFrame:CGRectMake(0, 0, 76, 28)];
    NSString *option = self.presentationModeOptions[indexPath.row][AROptionsKey];
    toggle.on = [self.defaults boolForKey:option];
    toggle.userInteractionEnabled = NO;

    cell.accessoryView = toggle;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *option = self.presentationModeOptions[indexPath.row][AROptionsKey];

    BOOL on = ![self.defaults boolForKey:option];
    [self.defaults setBool:on forKey:option];
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
