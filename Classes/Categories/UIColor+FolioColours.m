#import <EDColor/EDColor.h>


@implementation UIColor (ArtsyColours)

// We will be asking for frontColor or backColor very often
// so we don't want to do an NSUserDefaults each time, so we use a
// static var.

static BOOL ARUseWhiteFolio;

+ (void)updateFolioColorsToWhite:(BOOL)useWhiteFolio
{
    ARUseWhiteFolio = useWhiteFolio;
}

+ (UIColor *)artsyForegroundColor
{
    return ARUseWhiteFolio ? [UIColor blackColor] : [UIColor whiteColor];
}

+ (UIColor *)artsyBackgroundColor
{
    return ARUseWhiteFolio ? [UIColor whiteColor] : [UIColor blackColor];
}

+ (UIColor *)artsySingleLineGrey
{
    return [UIColor colorWithRed:0.180 green:0.180 blue:0.184 alpha:1.000];
}

+ (UIColor *)artsyHighlightGreen
{
    return [UIColor colorWithHex:0x5ADB7B];
}

+ (UIColor *)artsyHeavyGreen
{
    return [UIColor colorWithHex:0x4d8008];
}

@end
