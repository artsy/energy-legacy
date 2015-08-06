#import "ARGroupedTableViewCell.h"
#import "ARGroupedView.h"


@interface ARGroupedTableViewCell ()
@property (nonatomic, retain) ARGroupedView *backgroundView;
@end


@implementation ARGroupedTableViewCell
@dynamic backgroundView;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) return nil;

    self.backgroundView = [[ARGroupedView alloc] init];

    return self;
}

- (void)prepareForReuse
{
    self.isTopCell = NO;

    [super prepareForReuse];
}

- (void)setIsTopCell:(BOOL)isTopCell
{
    _isTopCell = isTopCell;
    self.backgroundView.isTopCell = isTopCell;
    [self.backgroundView setNeedsDisplay];
}

@end
