#import "ARAvailabilityTableViewCell.h"


@implementation ARAvailabilityTableViewCell

- (void)updateWithAvailabilty:(ARArtworkAvailability)availability
{
    NSDictionary *titles = @{
        @(ARArtworkAvailabilityNotForSale) : @"Not For Sale",
        @(ARArtworkAvailabilityForSale) : @"For Sale",
        @(ARArtworkAvailabilitySold) : @"Sold",
        @(ARArtworkAvailabilityOnHold) : @"On Hold",
        @(ARArtworkAvailabilityOnLoan) : @"On Loan",
        @(ARArtworkAvailabilityPermenentCollection) : @"Permenent Collection"
    };

    NSString *label = titles[@(availability)];

    // Use an attributed string to add the color circle
    NSString *fullString = [@" •  " stringByAppendingString:label];
    NSMutableAttributedString *attributedLabel = [[NSMutableAttributedString alloc] initWithString:fullString];

    // Color and size that dot
    UIColor *color = [Artwork colorForAvailabilityState:availability];
    [attributedLabel addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, 3)];
    [attributedLabel addAttribute:NSFontAttributeName value:[UIFont serifItalicFontWithSize:22] range:NSMakeRange(0, 3)];

    self.textLabel.attributedText = attributedLabel;
}

- (void)switchTickToNextChevron
{
    NSString *path = [[NSBundle bundleForClass:self.class] pathForResource:@"Chevron_Black" ofType:@"png"];
    UIImage *chevronImage = [UIImage imageWithContentsOfFile:path];
    UIImageView *chevron = [[UIImageView alloc] initWithImage:chevronImage];
    self.accessoryView = chevron;
}

@end
