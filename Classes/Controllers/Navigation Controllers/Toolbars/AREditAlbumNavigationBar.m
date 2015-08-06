#import "AREditAlbumNavigationBar.h"


@implementation AREditAlbumNavigationBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    [[AREditAlbumNavigationBar appearance] setBarTintColor:[UIColor artsyBackgroundColor]];
    [[AREditAlbumNavigationBar appearance] setTintColor:[UIColor artsyForegroundColor]];

    if (![UIDevice isPad]) {
        [[UIBarButtonItem appearanceWhenContainedIn:AREditAlbumNavigationBar.class, nil] setBackButtonBackgroundVerticalPositionAdjustment:12 forBarMetrics:UIBarMetricsDefault];
    } else {
        [[AREditAlbumNavigationBar appearance] setTitleVerticalPositionAdjustment:-8 forBarMetrics:UIBarMetricsDefault];
    }

    return self;
}

- (CGSize)sizeThatFits:(CGSize)size
{
    size.height = [UIDevice isPad] ? ARToolbarSizeHeight : 40;
    size.width = self.superview.bounds.size.width;
    return size;
}

- (void)tintColorDidChange
{
    [super tintColorDidChange];

    UIView *background = [self.subviews firstObject];
    background.backgroundColor = [UIColor artsyBackgroundColor];

    CGFloat fontSize = [UIDevice isPad] ? 16 : 14;
    [self setTitleTextAttributes:@{
        NSForegroundColorAttributeName : [UIColor artsyForegroundColor],
        NSFontAttributeName : [UIFont sansSerifFontWithSize:fontSize]
    }];
}

@end
