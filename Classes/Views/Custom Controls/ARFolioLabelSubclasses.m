#import "ARFolioLabelSubclasses.h"


@interface ARLabel ()
- (void)setup;
@end

// http://stackoverflow.com/questions/17491376/ios-autolayout-multi-line-uilabel


@implementation ARFolioResizingSerifLabel

/// iOS7
- (void)setBounds:(CGRect)bounds
{
    if (bounds.size.width != CGRectGetWidth(self.bounds)) {
        [self setNeedsUpdateConstraints];
    }
    [super setBounds:bounds];
}

/// iOS8
- (void)updateConstraints
{
    if (self.preferredMaxLayoutWidth != CGRectGetWidth(self.bounds)) {
        self.preferredMaxLayoutWidth = CGRectGetWidth(self.bounds);
    }
    [super updateConstraints];
}

@end


@implementation ARFolioSerifLabel

- (void)setup
{
    [super setup];
    self.backgroundColor = [UIColor artsyBackgroundColor];
    self.textColor = [UIColor artsyForegroundColor];
}

@end


@implementation ARFolioSansSerifLabel

- (void)setup
{
    [super setup];
    self.backgroundColor = [UIColor artsyBackgroundColor];
    self.textColor = [UIColor artsyForegroundColor];
}

@end
