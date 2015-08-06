#import "ARTextToolbarButton.h"


@implementation ARTextToolbarButton

- (void)tintColorDidChange
{
    [super tintColorDidChange];

    self.tintColor = [UIColor artsyForegroundColor];

    UIImage *backgroundImage = [[UIImage imageNamed:@"ButtonBackgroundWhite"] stretchableImageWithLeftCapWidth:22 topCapHeight:4];
    backgroundImage = [backgroundImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self setBackgroundImage:backgroundImage forState:UIControlStateNormal];

    [self setTitleColor:self.tintColor forState:UIControlStateNormal];
    [self setTitleColor:[self.tintColor colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
    [self setTitleColor:[self.tintColor colorWithAlphaComponent:0.5] forState:UIControlStateDisabled];

    UIColor *darkGrayColor = [UIColor artsySingleLineGrey];
    UIColor *background = [UIColor artsyBackgroundColor];

    [self setBackgroundColor:background forState:UIControlStateNormal];
    [self setBorderColor:background forState:UIControlStateNormal];

    [self setBackgroundColor:darkGrayColor forState:UIControlStateHighlighted];
    [self setTitleColor:darkGrayColor forState:UIControlStateDisabled];
}

@end
