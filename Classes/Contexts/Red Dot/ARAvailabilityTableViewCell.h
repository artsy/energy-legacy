#import "ARTickedTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN


@interface ARAvailabilityTableViewCell : ARTickedTableViewCell

/// Used from the re-use
- (void)updateWithAvailabilty:(ARArtworkAvailability)availability;

/// This is a destructive action, don't expect a re-use to be able to tick
- (void)switchTickToNextChevron;

@end

NS_ASSUME_NONNULL_END
