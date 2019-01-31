#import "ARPresentAvailabilityChoiceViewController.h"
#import "ARTickedTableViewCell.h"
#import "ARAvailabilityTableViewCell.h"
#import "EditionSet.h"
#import "AREditEditionsViewController.h"
#import "ARTableHeaderView.h"
#import "ARPopoverController.h"
#import "AREditAvailabilityNetworkModel.h"


@interface AREditEditionsViewController ()

@property (readonly, nonatomic, strong) ARPopoverController *popover;
@property (readonly, nonatomic, strong) NSArray<EditionSet *> *editions;
@end


@implementation AREditEditionsViewController

- (instancetype)initWithArtwork:(Artwork *)artwork popover:(nonnull ARPopoverController *)popover
{
    self = [super init];
    if (!self) {
        return self;
    }

    _artwork = artwork;
    NSSortDescriptor *heightSort = [NSSortDescriptor sortDescriptorWithKey:@keypath(EditionSet.new, height) ascending:YES];
    _editions = [artwork.editionSets sortedArrayUsingDescriptors:@[ heightSort ]];
    _popover = popover;

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.tableView registerClass:ARAvailabilityTableViewCell.class forCellReuseIdentifier:@"Availability"];
    [self.tableView registerClass:ARTableViewCell.class forCellReuseIdentifier:@"EditionInfo"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.artwork.editionSets.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UIView *)tableView:(UITableView *)aTableView viewForHeaderInSection:(NSInteger)section
{
    CGRect frame = CGRectMake(0, 0, CGRectGetWidth(self.tableView.frame), [ARTableHeaderView heightOfCell]);
    EditionSet *edition = self.editions[section];
    return [[ARTableHeaderView alloc] initWithFrame:frame title:[edition.displayDescription uppercaseString] style:ARTableHeaderViewStyleLight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return [ARTableHeaderView heightOfCell];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ARAvailabilityTableViewCell *cell = (ARAvailabilityTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[ARAvailabilityTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }

    EditionSet *edition = self.editions[indexPath.section];

    BOOL isAvailabilityRow = indexPath.row == 0;
    if (isAvailabilityRow) {
        [cell updateWithAvailabilty:edition.availabilityState];
        [cell switchTickToNextChevron];
    } else {
        cell.textLabel.text = edition.editionSize;
    }

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EditionSet *edition = self.editions[indexPath.section];
    BOOL isAvailabilityRow = indexPath.row == 0;

    if (isAvailabilityRow) {
        ARPresentAvailabilityChoiceViewController *updateEditionsVC = [[ARPresentAvailabilityChoiceViewController alloc] init];
        updateEditionsVC.currentAvailability = edition.availabilityState;

        updateEditionsVC.callback = ^(ARArtworkAvailability newAvailability, AvailabilityFinishedCallback _Nonnull finished) {
            AREditAvailabilityNetworkModel *networkModel = [[AREditAvailabilityNetworkModel alloc] init];
            [networkModel updateArtwork:self.artwork editionSet:edition toAvailability:newAvailability completion:^(BOOL success) {
                // Update the UI in the popover
                finished(success);

                if (success) {
                    // Update the core data model, then tell all grids and artwork pages to reload
                    edition.availability = [Artwork stringForAvailabilityState:newAvailability];
                    [edition saveManagedObjectContextLoggingErrors];

                    // Hide the popover after it's confirmed
                    ar_dispatch_after(0.3, ^{
                        [self.popover dismissPopoverAnimated:YES];
                        [[NSNotificationCenter defaultCenter] postNotificationName:ARArtworkAvailabilityUpdated object:nil];
                    });
                }
            }];
        };
        [self.navigationController pushViewController:updateEditionsVC animated:YES];
    }
}

- (CGSize)preferredContentSize
{
    CGFloat height = self.editions.count * ([ARTableHeaderView heightOfCell] + (ARTableViewCellSettingsHeight * 2));
    return CGSizeMake(320, height);
}

@end
