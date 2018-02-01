
#import "ARTextToolbarButton.h"

static const CGFloat ARButtonHorizontalMargin = 16;


@implementation UIButton (ArtsyButtons)

+ (UIButton *)folioUnborderedToolbarButtonWithTitle:(NSString *)title
{
    return [self stretchableButtonTitled:title bordered:NO];
}

+ (UIButton *)folioToolbarButtonWithTitle:(NSString *)title
{
    return [UIButton stretchableButtonTitled:title bordered:YES];
}

+ (UIButton *)textBasedToolbarButtonWithTitle:(NSString *)title
{
    UIButton *button = [UIButton stretchableButtonTitled:title.uppercaseString bordered:YES];
    button.accessibilityLabel = title;

    [button setBackgroundImage:[UIImage imageNamed:@"White"] forState:UIControlStateSelected];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    return button;
}

+ (UIButton *)stretchableButtonTitled:(NSString *)title bordered:(BOOL)bordered
{
    Class klass = bordered ? ARTextToolbarButton.class : ARToolbarButton.class;
    UIButton *button = [klass buttonWithType:UIButtonTypeCustom];

    button.tintColor = [UIColor artsyForegroundColor];
    [button setTitle:[title uppercaseString] forState:UIControlStateNormal];

    CGFloat fontSize = [UIDevice isPad] ? ARFontSansRegular : ARPhoneFontSansRegular;
    button.titleLabel.font = [UIFont sansSerifFontWithSize:fontSize];
    button.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;

    button.contentEdgeInsets = UIEdgeInsetsMake(0, ARButtonHorizontalMargin, 0, ARButtonHorizontalMargin);
    [button sizeToFit];

    button.accessibilityLabel = title;
    return button;
}

+ (UIButton *)folioImageButtonWithName:(NSString *)name withTarget:(id)target andSelector:(SEL)selector
{
    ARToolbarButton *button = [ARToolbarButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    button.accessibilityLabel = [NSString stringWithFormat:@"%@", name];

    BOOL isThinDevice = (CGRectGetWidth([UIScreen mainScreen].bounds) <= 320);
    if (isThinDevice) {
        button.frame = CGRectMake(0, 0, 32, 43);
    } else {
        button.frame = CGRectMake(0, 0, 43, 43);
    }
    [button setToolbarImagesWithName:name];
    return button;
}

- (void)setToolbarImagesWithName:(NSString *)name
{
    NSString *buttonImageName = [[name lowercaseString] stringByReplacingOccurrencesOfString:@" " withString:@""];

//    if ([UIDevice isPad]) {
//        UIImage *normalImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_btn_whiteborder", buttonImageName]];
//        normalImage = [normalImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
//        [self setImage:normalImage forState:UIControlStateNormal];
//
//        UIImage *activeImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_btn_solidwhite", buttonImageName]];
//        activeImage = [activeImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
//        [self setImage:activeImage forState:UIControlStateHighlighted];
//        [self setImage:activeImage forState:UIControlStateSelected];
//
//    } else {
        UIImage *buttonImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_btn", buttonImageName]];
        buttonImage = [buttonImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [self setImage:buttonImage forState:UIControlStateNormal];
//    }
}


@end
