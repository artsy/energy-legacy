#import "ARTableViewCell.h"


@interface ARTickedTableViewCell : ARTableViewCell

- (void)setTickSelected:(BOOL)selected animated:(BOOL)animated;

- (BOOL)isSelected;
@end
