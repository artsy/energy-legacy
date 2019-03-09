#import "ARTableViewCell.h"

/// A table view cell that has the cute animated purple tick
@interface ARTickedTableViewCell : ARTableViewCell

/// Use this instead of the official API for selection
- (void)setTickSelected:(BOOL)selected animated:(BOOL)animated;
/// Is it already active or not
- (BOOL)isSelected;

/// The color for the tick, be careful with the re-use on this
/// as it won't get reset across re-uses
- (void)setTickColor:(UIColor *)color;

@end
