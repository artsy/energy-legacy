#import <Artsy+UIFonts/UIFont+ArtsyFonts.h>
#import "ARGroupedTableViewHeader.h"


@implementation ARGroupedTableViewHeader

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (!self) return nil;

    self.detailTextLabel.font = [UIFont sansSerifFontWithSize:14];

    return self;
}

@end
