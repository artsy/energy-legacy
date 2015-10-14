#import <Artsy+UIFonts/UIFont+ArtsyFonts.h>
#import "ARToggleSwitch.h"


@implementation ARToggleSwitch {
    CALayer *_slidingToggleLayer;
    CAShapeLayer *_nubLayer;
    CAShapeLayer *_backgroundLayer;
}

+ (instancetype)buttonWithFrame:(CGRect)frame
{
    ARToggleSwitch *button = [[self alloc] initWithFrame:frame];
    [button setOn:NO];

    return button;
}


- (void)setOn:(BOOL)on
{
    _on = on;

    CGPoint slidePosition = (on) ? CGPointMake(0, 0) : CGPointMake(-42, 0);
    UIColor *backgroundColor = (on) ? [UIColor artsyPurple] : [UIColor whiteColor];
    UIColor *borderColor = (on) ? [UIColor artsyPurple] : [UIColor artsyLightGrey];

    _slidingToggleLayer.position = slidePosition;

    CABasicAnimation *backgroundAnimation = nil;
    backgroundAnimation = [self colorAnimationFrom:_backgroundLayer.fillColor
                                                to:backgroundColor.CGColor
                                          withPath:@"fillColor"];

    _backgroundLayer.fillColor = backgroundColor.CGColor;
    [_backgroundLayer addAnimation:backgroundAnimation forKey:@"backgroundColor"];

    // The border animation isn't a true border animation
    // it's actually setting the views background as that's exposed where the
    // border is visually

    CABasicAnimation *borderAnimation = nil;
    borderAnimation = [self colorAnimationFrom:self.layer.backgroundColor
                                            to:borderColor.CGColor
                                      withPath:@"backgroundColor"];
    borderAnimation.duration = 0.15;
    self.layer.backgroundColor = borderColor.CGColor;
    [self.layer addAnimation:borderAnimation forKey:@"borderColor"];
}

- (CABasicAnimation *)colorAnimationFrom:(CGColorRef)color to:(CGColorRef)toColor withPath:(NSString *)path
{
    CABasicAnimation *selectionAnimation = [CABasicAnimation animationWithKeyPath:path];
    selectionAnimation.fromValue = (__bridge id)color;
    selectionAnimation.toValue = (__bridge id)toColor;
    selectionAnimation.duration = 0.3;
    selectionAnimation.fillMode = kCAFillModeForwards;
    return selectionAnimation;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;

    CGRect theCAFrame = CGRectMake(0.5, 1.5, 74, 26);

    _backgroundLayer = [CAShapeLayer layer];
    _backgroundLayer.path = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(theCAFrame, 1.5, 1.5) cornerRadius:13].CGPath;
    _backgroundLayer.fillColor = [UIColor blackColor].CGColor;
    [self.layer addSublayer:_backgroundLayer];

    _slidingToggleLayer = [CALayer layer];

    CATextLayer *onTextLayer = [CATextLayer layer];
    [onTextLayer setString:@"ON"];

    [onTextLayer setFont:(__bridge CFTypeRef)([UIFont sansSerifFontWithSize:ARFontSerifSmall].fontName)];
    [onTextLayer setFontSize:ARFontSerifSmall];
    [onTextLayer setFrame:CGRectMake(11, 5, 26, 22)];
    [onTextLayer setContentsScale:[[UIScreen mainScreen] scale]];
    [onTextLayer setForegroundColor:[UIColor colorWithWhite:1 alpha:1].CGColor];
    [_slidingToggleLayer addSublayer:onTextLayer];

    CATextLayer *offTextLayer = [CATextLayer layer];
    [offTextLayer setString:@"OFF"];
    [offTextLayer setFont:(__bridge CFTypeRef)([UIFont sansSerifFontWithSize:ARFontSerifSmall].fontName)];

    [offTextLayer setContentsScale:[[UIScreen mainScreen] scale]];
    [offTextLayer setFontSize:ARFontSerifSmall];
    [offTextLayer setFrame:CGRectMake(77, 5, 35, 22)];
    [offTextLayer setForegroundColor:[UIColor artsyLightGrey].CGColor];

    [_slidingToggleLayer addSublayer:offTextLayer];

    _nubLayer = [CAShapeLayer layer];
    _nubLayer.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(50.5, 6.5, 16, 16)].CGPath;
    _nubLayer.fillColor = [UIColor artsyLightGrey].CGColor;
    [_slidingToggleLayer addSublayer:_nubLayer];

    [self.layer setBackgroundColor:[UIColor debugColourGreen].CGColor];
    [self.layer addSublayer:_slidingToggleLayer];

    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = [UIBezierPath bezierPathWithRoundedRect:theCAFrame cornerRadius:13].CGPath;
    maskLayer.fillColor = [UIColor blackColor].CGColor;

    [self.layer setMask:maskLayer];
    [self.layer setMasksToBounds:YES];
    return self;
}

@end
