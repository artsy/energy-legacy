#import "ARToolbarButton.h"


@implementation ARToolbarButton

- (void)tintColorDidChange
{
    [super tintColorDidChange];

    [self setup];
}

- (void)setup
{
    self.tintColor = [UIColor artsyForegroundColor];

    [self setTitleColor:self.tintColor forState:UIControlStateNormal];
    [self setTitleColor:[self.tintColor colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
    [self setTitleColor:[self.tintColor colorWithAlphaComponent:0.5] forState:UIControlStateDisabled];

    [self setToolbarImagesWithName:self.accessibilityLabel];
}

@end
