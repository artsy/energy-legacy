#import "ARSettingsNavigationBar.h"
#import <Artsy+UIFonts/UIFont+ArtsyFonts.h>


@implementation ARSettingsNavigationBar

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (!self) return nil;

    [[ARSettingsNavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    [[ARSettingsNavigationBar appearance] setTintColor:[UIColor blackColor]];

    [self hideBottomBorder];

    [self setTitleTextAttributes:@{
        NSForegroundColorAttributeName : [UIColor blackColor],
        NSFontAttributeName : [UIDevice isPad] ? [UIFont sansSerifFontWithSize:ARFontSansLarge] : [UIFont sansSerifFontWithSize:ARPhoneFontSansRegular]
    }];

    return self;
}

- (CGSize)sizeThatFits:(CGSize)size
{
    size.height = [UIDevice isPad] ? ARToolbarSizeHeight : 40;
    size.width = self.superview.bounds.size.width;
    return size;
}

- (void)hideBottomBorder
{
    [self setBackgroundImage:[UIImage imageNamed:@"White.png"] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [self setShadowImage:[UIImage imageNamed:@"White.png"]];
}

- (void)drawRect:(CGRect)rect
{
    UIImage *image = [UIImage imageNamed:@"White.png"];
    [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
}

- (void)tintColorDidChange
{
    /// No operation
}

@end
