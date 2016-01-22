
#import "ARTitleLabel.h"

static CGFloat MaximumPortraitTitleWidth = 320;
static CGFloat MaximumLandscapeTitleWidth = 600;


@implementation ARTitleLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.font = [UIFont sansSerifFontWithSize:ARFontSansLarge];
        self.shadowColor = [UIColor clearColor];
        self.textColor = [UIColor whiteColor];
        self.textAlignment = NSTextAlignmentCenter;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)sizeToFit
{
    [super sizeToFit];

    CGFloat margin = 4;
    CGRect rect = self.frame;
    rect.size.width += margin * 2;
    self.frame = rect;
}

- (void)setFrame:(CGRect)frame
{
    BOOL isPortrait = UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation);
    CGFloat maxWidth = isPortrait ? MaximumPortraitTitleWidth : MaximumLandscapeTitleWidth;

    if (maxWidth < frame.size.width) {
        frame.origin.x += (frame.size.width - maxWidth) / 2;
        frame.size.width = maxWidth;
    }

    [super setFrame:frame];
}

@end
