#import "ARPresentAvailabilityChoiceViewController.h"
#import "ARAvailabilityTableViewCell.h"


@interface ARPresentAvailabilityChoiceViewController ()

@property (nonatomic, copy) NSArray *orderedAvailabilities;
@property (nonatomic, copy) NSDictionary *titles;
@end


@implementation ARPresentAvailabilityChoiceViewController

// https://github.com/artsy/volt/blob/fee6fa7d4409276eaaee65370b27c1b6c5575e83/app/models/availability.rb#L3-L13

+ (NSArray *)orderedAvailabilitiesForPartnerType:(NSString *)type
{
    if ([type isEqualToString:@"Gallery"]) {
        return @[
            @(ARArtworkAvailabilityForSale),
            @(ARArtworkAvailabilityOnHold),
            @(ARArtworkAvailabilitySold),
            @(ARArtworkAvailabilityOnLoan),
        ];
    } else if ([type isEqualToString:@"Private Collector"] || [type isEqualToString:@"Institution"]) {
        return @[
            @(ARArtworkAvailabilityOnLoan),
            @(ARArtworkAvailabilityPermenentCollection)
        ];
    }

    // Fallback to the gallery, you never know what the future data model could look like
    return @[
        @(ARArtworkAvailabilityForSale),
        @(ARArtworkAvailabilityOnHold),
        @(ARArtworkAvailabilitySold),
        @(ARArtworkAvailabilityNotForSale),
    ];
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    _orderedAvailabilities = [self.class orderedAvailabilitiesForPartnerType:[Partner currentPartner].partnerType];
    [self.tableView registerClass:ARAvailabilityTableViewCell.class forCellReuseIdentifier:@"Cell"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.orderedAvailabilities.count;
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

    for (int i = 0; i < [self tableView:tableView numberOfRowsInSection:0]; i++) {
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
    return CGSizeMake(320, 20 + [self tableView:self.tableView numberOfRowsInSection:0] * 54);
}

@end
