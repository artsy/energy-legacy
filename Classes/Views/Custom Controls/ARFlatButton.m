
#import "ARFlatButton.h"
#import "UIImage+ImageFromColor.h"


@implementation ARButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;

    [self setup];

    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setup];
}

- (void)setup
{
    @throw [NSException exceptionWithName:@"No ARButtons" reason:@"Abstract class" userInfo:nil];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state
{
    [self setBackgroundImage:[UIImage imageFromColor:backgroundColor] forState:state];
}

// All Artsy buttons only use caps so far, this could change, but for now
// it makes sense to put it on the subclass

- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    title = [title uppercaseString];
    [super setTitle:title forState:state];
}

@end


@interface ARFlatButton ()
@property (nonatomic, strong) NSMutableDictionary *backgroundColors;
@property (nonatomic, strong) NSMutableDictionary *borderColors;
@property (nonatomic, assign) BOOL isSetup;
@end


@implementation ARFlatButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setup];
}

- (void)setup
{
    CALayer *layer = [self layer];
    layer.masksToBounds = YES;
    layer.cornerRadius = 0;
    layer.borderWidth = 2;

    self.backgroundColors = [NSMutableDictionary dictionary];
    self.borderColors = [NSMutableDictionary dictionary];
    self.borderColor = UIColor.artsyMediumGrey;

    self.backgroundColor = UIColor.artsyMediumGrey;
    self.titleLabel.font = [UIFont sansSerifFontWithSize:ARFontSansRegular];

    [self setBackgroundColor:UIColor.artsyMediumGrey forState:UIControlStateNormal];
    [self setBackgroundColor:UIColor.artsyPurple forState:UIControlStateHighlighted];

    [self setBorderColor:UIColor.artsyMediumGrey forState:UIControlStateNormal];
    [self setBorderColor:UIColor.whiteColor forState:UIControlStateHighlighted];

    [self setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [self setTitleColor:UIColor.whiteColor forState:UIControlStateHighlighted];

    self.isSetup = YES;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state
{
    [self.backgroundColors setObject:backgroundColor forKey:@(state)];
    if (self.isSetup && state == self.state) {
        [self changeColorsForStateChange];
    }
}

- (void)setBorderColor:(UIColor *)borderColor forState:(UIControlState)state
{
    [self.borderColors setObject:borderColor forKey:@(state)];
}

- (void)changeColorsForStateChange
{
    if (!self.layer.backgroundColor) self.layer.backgroundColor = [UIColor clearColor].CGColor;

    UIColor *newBackgroundColor = [self.backgroundColors objectForKey:@(self.state)];
    if (newBackgroundColor && newBackgroundColor.CGColor != self.layer.backgroundColor) {
        CABasicAnimation *fade = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
        fade.fromValue = (__bridge id)(self.layer.backgroundColor);
        fade.toValue = (__bridge id)(newBackgroundColor.CGColor);
        fade.duration = .2;
        [self.layer addAnimation:fade forKey:@"backgroundFade"];
        self.layer.backgroundColor = newBackgroundColor.CGColor;
    };

    if (!self.layer.borderColor) self.layer.borderColor = [UIColor clearColor].CGColor;

    UIColor *newBorderColor = [self.borderColors objectForKey:@(self.state)];
    if (newBorderColor && newBorderColor.CGColor != self.layer.borderColor) {
        CABasicAnimation *fade = [CABasicAnimation animationWithKeyPath:@"borderColor"];
        fade.fromValue = (__bridge id)(self.layer.borderColor);
        fade.toValue = (__bridge id)(newBorderColor.CGColor);
        fade.duration = .2;
        [self.layer addAnimation:fade forKey:@"borderFade"];
        self.layer.borderColor = newBorderColor.CGColor;
    };
}

- (void)setBorderColor:(UIColor *)borderColor
{
    if (self.state == UIControlStateNormal) {
        self.layer.borderColor = borderColor.CGColor;
    }
    [self setBorderColor:borderColor forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    [self changeColorsForStateChange];
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    [self changeColorsForStateChange];
}

- (void)setEnabled:(BOOL)enabled
{
    [self setEnabled:enabled animated:NO];
}

- (void)setEnabled:(BOOL)enabled animated:(BOOL)animated
{
    [super setEnabled:enabled];

    [self changeColorsForStateChange];
    [UIView animateIf:animated duration:ARAnimationQuickDuration:^{
        self.alpha = enabled ? 1 : 0.5;
    }];
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    title = [title uppercaseString];
    [super setTitle:title forState:state];
}

@end


@implementation ARLoginFlatButton

- (void)setup
{
    [super setup];

    [self setBackgroundColor:UIColor.blackColor forState:UIControlStateNormal];
    [self setBackgroundColor:UIColor.artsyHeavyGrey forState:UIControlStateHighlighted];
    [self setBackgroundColor:UIColor.blackColor forState:UIControlStateDisabled];

    [self setBorderColor:UIColor.whiteColor forState:UIControlStateNormal];
    [self setBorderColor:UIColor.artsyLightGrey forState:UIControlStateDisabled];

    [self setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];

    [self changeColorsForStateChange];
}

@end


@implementation ARSyncFlatButton

- (void)setup
{
    [super setup];

    [self setBackgroundColor:UIColor.artsyHeavyGrey forState:UIControlStateNormal];
    [self setBackgroundColor:UIColor.artsyLightGrey forState:UIControlStateHighlighted];

    [self setBorderColor:UIColor.artsyHeavyGrey forState:UIControlStateNormal];
    [self setBorderColor:UIColor.artsyLightGrey forState:UIControlStateDisabled];

    [self setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];

    [self changeColorsForStateChange];
}

@end


@implementation ARLabSyncFlatButton

- (void)setup
{
    [super setup];

    [self setBackgroundColor:UIColor.blackColor forState:UIControlStateNormal];
    [self setBackgroundColor:UIColor.artsyPurple forState:UIControlStateHighlighted];

    [self setBorderColor:UIColor.blackColor forState:UIControlStateNormal];
    [self setBorderColor:UIColor.artsyLightGrey forState:UIControlStateDisabled];

    [self setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];

    [self changeColorsForStateChange];
}

@end


@implementation ARAlertLowVisualPriorityButton

- (void)setup
{
    [super setup];

    self.layer.borderWidth = 3;

    [self setBackgroundColor:UIColor.whiteColor forState:UIControlStateNormal];

    [self setBorderColor:UIColor.blackColor forState:UIControlStateNormal];
    [self setBorderColor:UIColor.artsyMediumGrey forState:UIControlStateDisabled];
    [self setBorderColor:UIColor.artsyMediumGrey forState:UIControlStateHighlighted];

    [self setTitleColor:UIColor.blackColor forState:UIControlStateNormal];

    [self changeColorsForStateChange];
}

@end


@implementation ARAlertHighVisualPriorityButton

- (void)setup
{
    [super setup];

    self.layer.borderWidth = 0;

    [self setBackgroundColor:UIColor.blackColor forState:UIControlStateNormal];
    [self setBackgroundColor:UIColor.artsyMediumGrey forState:UIControlStateDisabled];

    [self setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];

    [self changeColorsForStateChange];
}

@end
