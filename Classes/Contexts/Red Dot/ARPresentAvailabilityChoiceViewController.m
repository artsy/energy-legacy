#import "ARPresentAvailabilityChoiceViewController.h"
#import "ARAvailabilityTableViewCell.h"


@interface ARPresentAvailabilityChoiceViewController ()

@property (nonatomic, copy) NSArray *orderedAvailabilities;
@property (nonatomic, copy) NSDictionary *titles;
@end


@implementation ARPresentAvailabilityChoiceViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Basically Green - Orange - Red - Grey
    _orderedAvailabilities = @[
        @(ARArtworkAvailabilityForSale),
        @(ARArtworkAvailabilityOnHold),
        @(ARArtworkAvailabilitySold),
        @(ARArtworkAvailabilityNotForSale),
        @(ARArtworkAvailabilityOnLoan),
        @(ARArtworkAvailabilityPermenentCollection)
    ];

    [self.tableView registerClass:ARAvailabilityTableViewCell.class forCellReuseIdentifier:@"Cell"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ARArtworkAvilabilityCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ARAvailabilityTableViewCell *cell = (ARAvailabilityTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[ARAvailabilityTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }

    NSNumber *availability = self.orderedAvailabilities[indexPath.row];
    [cell updateWithAvailabilty:availability.integerValue];

    if (availability.integerValue == self.currentAvailability) {
        [cell setTickSelected:YES animated:NO];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSNumber *availability = self.orderedAvailabilities[indexPath.row];

    for (int i = 0; i < ARArtworkAvilabilityCount; i++) {
        ARAvailabilityTableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        [cell setTickSelected:NO animated:NO];
    }

    AvailabilityFinishedCallback completed = ^(BOOL success) {
        NSInteger currentIndex = [self.orderedAvailabilities indexOfObject:@(self.currentAvailability)];
        NSIndexPath *oldSelection = [NSIndexPath indexPathForRow:currentIndex inSection:0];
        NSIndexPath *newSelection = success ? indexPath : oldSelection;
        UIColor *tickColor = success ? [UIColor artsyPurpleRegular] : [UIColor redColor];

        ARAvailabilityTableViewCell *cell = [tableView cellForRowAtIndexPath:newSelection];
        [cell setTickColor:tickColor];
        [cell setTickSelected:YES animated:YES];
    };

    if (self.callback) {
        self.callback(availability.integerValue, completed);
    }
}

- (CGSize)preferredContentSize
{
    return CGSizeMake(320, 20 + ARArtworkAvilabilityCount * 54);
}

@end
