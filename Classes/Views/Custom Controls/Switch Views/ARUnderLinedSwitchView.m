@import Artsy_UIFonts;

#import "ARUnderLinedSwitchView.h"


@interface ARUnderLinedSwitchView () {
    CGRect _originalFrame;
    CALayer *_underline;

    CGFloat _fontSize;
    UIColor *_fontColor;

    CGFloat _underlineHeight;
    UIColor *_underlineColor;
    CGFloat _underlineYOffset;

    NSInteger _selectedIndex;
}

@property (strong) NSMutableArray *buttons;
@end

CGFloat ARUnderlineAnimationDuration = 0.3;


@implementation ARUnderLinedSwitchView


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _originalFrame = frame;
    }
    return self;
}

- (void)buttonPushed:(UIButton *)button
{
    NSInteger index = button.tag;

    [self setSelectedIndex:index animated:YES];
    [self.delegate switchView:self didSelectIndex:index animated:YES];
}

- (void)setStyle:(enum ARSwitchViewStyle)style
{
    _style = style;

    switch (style) {
        case ARSwitchViewStyleSansSerif:
            _underlineHeight = 4;
            _underlineColor = [UIColor artsyForegroundColor];

            _fontSize = ARFontSansLarge;
            _fontColor = [UIColor artsyForegroundColor];
            break;

        case ARSwitchViewStyleSmallerSansSerif:
        case ARSwitchViewStyleSmallSansSerif:
            _underlineHeight = 2;
            _underlineColor = [UIColor artsyForegroundColor];

            _fontSize = style == ARSwitchViewStyleSmallerSansSerif ? ARPhoneFontSansSmall - 1 : ARPhoneFontSansRegular;
            _fontColor = [UIColor artsyForegroundColor];
            break;
        /// This one is for the search popover so it should be using whiteColor/blackColor
        case ARSwitchViewStyleWhiteSmallSansSerif:
            _underlineHeight = 2;
            _underlineColor = [UIColor blackColor];

            _fontSize = ARFontSansRegular;
            self.backgroundColor = [UIColor whiteColor];
            _fontColor = [UIColor blackColor];
            break;
    }
}

- (void)setFrame:(CGRect)frame
{
    CGSize oldSize = self.frame.size;

    // Don't resize the TopVC's switch
    if (self.style == ARSwitchViewStyleSansSerif && self.titles) {
        frame.size.width = _originalFrame.size.width;
    }

    [super setFrame:frame];

    // Recreate view heirarchy on rotation when we have a new size
    // We don't do this in layoutsubviews because views are added / removed
    if (!CGSizeEqualToSize(oldSize, self.frame.size) && self.titles) {
        self.titles = self.titles;
        [self setSelectedIndex:_selectedIndex animated:NO];
    }
}

- (void)setTitles:(NSArray *)titles
{
    if (titles.count == 0) {
        [NSException exceptionWithName:@"ARUnderLinedSwitch requires more than 0 titles" reason:@"ARUnderLinedSwitch requires > 0 titles" userInfo:nil];
    }
    [super setTitles:titles];

    [[self subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.buttons = [NSMutableArray array];

    // Only set the all the enabledStates the first time
    NSMutableArray *enabledStates = nil;
    if (!self.enabledStates) {
        enabledStates = [NSMutableArray array];
    }

    for (NSString *title in titles) {
        // setup button
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = [titles indexOfObject:title];
        button.accessibilityLabel = [NSString stringWithFormat:@"%@ %@ Button", self.accessibilityLabel, title];
        [button addTarget:self action:@selector(buttonPushed:) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = [UIFont sansSerifFontWithSize:_fontSize];

        // setup the positioning
        CGRect buttonFrame = self.bounds;

        buttonFrame.size.width = buttonFrame.size.width / titles.count;
        buttonFrame.origin.x = buttonFrame.size.width * [titles indexOfObject:title];
        button.frame = buttonFrame;

        // set title colours, remember we're faking a switch, so they are backwards
        [button setTitleColor:[_fontColor colorWithAlphaComponent:0.5] forState:UIControlStateNormal];
        [button setTitleColor:[_fontColor colorWithAlphaComponent:0.3] forState:UIControlStateHighlighted];
        [button setTitleColor:[_fontColor colorWithAlphaComponent:1] forState:UIControlStateDisabled];
        [button setBackgroundImage:nil forState:UIControlStateNormal];

        [button setTitle:[title uppercaseString] forState:UIControlStateNormal];
        // set titles & add to view heirarchy
        [self insertSubview:button atIndex:1];


        [enabledStates addObject:@(YES)];
        [self.buttons addObject:button];
    }

    if (enabledStates) [self setEnabledStates:enabledStates];

    [self setSelectedIndex:_selectedIndex animated:NO];
}

- (void)fadeInFromDisabledAnimated:(BOOL)animated
{
    _underline.opacity = 0;
    UIButton *currentButton = _buttons[_selectedIndex];
    currentButton.alpha = 0.5;

    [UIView animateIf:animated duration:ARAnimationDuration:^{
        _underline.opacity = 1;
        currentButton.alpha = 1;
    }];
}

- (NSInteger)selectedIndex
{
    return _selectedIndex;
}

- (void)setSelectedIndex:(NSInteger)index animated:(BOOL)animated
{
    if (!_underline) {
        _underline = [CALayer layer];
        _underline.backgroundColor = _underlineColor.CGColor;
        [self.layer addSublayer:_underline];
    }

    // make the old one usable
    UIButton *oldButton = self.buttons[_selectedIndex];
    oldButton.enabled = YES;
    _selectedIndex = index;

    UIButton *activeButton = self.buttons[index];
    activeButton.enabled = NO;

    CGRect underlineFrame = [self getUnderlineFrame];
    if (animated) {
        // http://cubic-bezier.com/#.68,.75,.7,1.35
        CAMediaTimingFunction *timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.68f:0.75f:0.7f:1.35f];

        [_underline removeAllAnimations];

        CABasicAnimation *boundsAnimation = [CABasicAnimation animationWithKeyPath:@"bounds"];
        boundsAnimation.duration = ARUnderlineAnimationDuration;
        boundsAnimation.fromValue = [NSValue valueWithCGRect:_underline.bounds];
        boundsAnimation.toValue = [NSValue valueWithCGRect:underlineFrame];
        boundsAnimation.fillMode = kCAFillModeForwards;
        boundsAnimation.timingFunction = timingFunction;

        CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
        positionAnimation.duration = ARUnderlineAnimationDuration;
        positionAnimation.fromValue = [NSValue valueWithCGPoint:_underline.position];
        positionAnimation.toValue = [NSValue valueWithCGPoint:underlineFrame.origin];
        positionAnimation.fillMode = kCAFillModeForwards;
        positionAnimation.timingFunction = timingFunction;

        [_underline setBounds:underlineFrame];
        [_underline addAnimation:boundsAnimation forKey:@"BoundsAnimation"];

        [_underline setPosition:underlineFrame.origin];
        [_underline addAnimation:positionAnimation forKey:@"PositionAnimation"];

    } else {
        [_underline setPosition:underlineFrame.origin];
        [_underline setBounds:underlineFrame];
    }

    self.enabledStates = self.enabledStates;
}

- (void)setEnabledStates:(NSArray *)enabledStates
{
    [super setEnabledStates:enabledStates];

    if (enabledStates.count != _buttons.count) {
        [NSException exceptionWithName:@"ARUnderLinedSwitch setting enabled state needs to have the same amount of indexes as buttons" reason:@"ARUnderLinedSwitch requires states to equal titles" userInfo:nil];
    }

    for (int i = 0; i < self.enabledStates.count; i++) {
        UIButton *button = _buttons[i];
        BOOL enabled = [self.enabledStates[i] boolValue];

        if (!enabled) {
            button.enabled = NO;
            button.alpha = 0.3;
        } else {
            button.alpha = 1;
        }
    }
}

- (CGRect)getUnderlineFrame
{
    UIButton *activeButton = self.buttons[_selectedIndex];
    CGSize titleSize = [activeButton.currentTitle ar_sizeWithFont:activeButton.titleLabel.font forWidth:200];

    CGFloat offsetX = (CGRectGetWidth(activeButton.bounds) - titleSize.width) / 2;
    CGFloat offsetY = (CGRectGetHeight(activeButton.bounds) - titleSize.height) / 2;

    CGRect underlineFrame = activeButton.frame;
    underlineFrame.origin.y = offsetY + titleSize.height + _underlineYOffset;
    underlineFrame.size.height = _underlineHeight;

    // These offsets are * I believe * to be based on the kerning of the letters in the titles
    // With them the underline is perfect in the folio title / search, whether it is elsewhere I can't promise. ./

    CGFloat const WidthModifier = 14;
    CGFloat const XPositionModifier = 1;

    // The combined buttons take up the full width, but the labels are only as big as the text
    // inside them due to them using sizeToFit after being set
    underlineFrame.size.width = fabs(offsetX) + titleSize.width - WidthModifier;
    underlineFrame.origin.x += fabs(CGRectGetWidth(activeButton.bounds) / 2) - XPositionModifier;
    return underlineFrame;
}

- (void)tintColorDidChange
{
    [super tintColorDidChange];

    // This should only effect the TopVC's switchview
    if (_style == ARSwitchViewStyleWhiteSmallSansSerif) return;

    UIColor *foregroundColor = [UIColor artsyForegroundColor];
    _underline.backgroundColor = foregroundColor.CGColor;

    for (UIButton *button in self.buttons) {
        [button setTitleColor:[foregroundColor colorWithAlphaComponent:0.5] forState:UIControlStateNormal];
        [button setTitleColor:[foregroundColor colorWithAlphaComponent:0.3] forState:UIControlStateHighlighted];
        [button setTitleColor:[foregroundColor colorWithAlphaComponent:1] forState:UIControlStateDisabled];
    }
}

@end
