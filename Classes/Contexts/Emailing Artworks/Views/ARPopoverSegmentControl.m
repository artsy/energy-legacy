

#import "ARPopoverSegmentControl.h"
#import "UIImage+ImageFromColor.h"


@implementation ARPopoverSegmentControl

- (instancetype)initWithItems:(NSArray *)items
{
    self = [super initWithItems:items];

    [self setBackgroundImage:[UIImage imageFromColor:UIColor.artsyPurpleRegular] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    [self setBackgroundImage:[UIImage imageFromColor:UIColor.artsyPurpleRegular] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];

    [self setDividerImage:[UIImage imageFromColor:[UIColor artsyGrayMedium]] forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];

    [self setTitleTextAttributes:@{
        NSFontAttributeName : [UIFont serifFontWithSize:14],
        NSForegroundColorAttributeName : [UIColor blackColor]
    } forState:UIControlStateNormal];

    [self setTitleTextAttributes:@{
        NSFontAttributeName : [UIFont serifFontWithSize:14],
        NSForegroundColorAttributeName : [UIColor whiteColor]
    } forState:UIControlStateSelected];

    // Sets the selected BG colour
    self.tintColor = [UIColor artsyPurpleRegular];

    return self;
}

@end
