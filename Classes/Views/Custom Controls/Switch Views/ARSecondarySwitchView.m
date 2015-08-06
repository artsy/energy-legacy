#import "ARSecondarySwitchView.h"

CGFloat ARSupplementaryViewMargin = 20;
CGFloat ARSwitchViewHeight = 50;
CGFloat ARSerifViewButtonMargin = 15;


@implementation ARSecondarySwitchView {
    NSMutableArray *enabledButtons;
    NSInteger _selectedIndex;
    BOOL hasContent;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;

    self.backgroundColor = [UIColor artsyBackgroundColor];
    _selectedIndex = 0;

    return self;
}

- (void)setEnabledStates:(NSArray *)enabledStates
{
    [super setEnabledStates:enabledStates];
    [self updateIntrinsicContentSize];
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    if (!self.titles && !self.enabledStates) return;

    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (_rightSupplementaryView) {
        [self addSubview:_rightSupplementaryView];
        CGRect rightFrame = _rightSupplementaryView.bounds;
        rightFrame.origin.x = CGRectGetWidth(self.bounds) - CGRectGetWidth(_rightSupplementaryView.bounds) - ARSupplementaryViewMargin;
        rightFrame.origin.y = CGRectGetHeight(self.bounds) / 2 - CGRectGetHeight(_rightSupplementaryView.bounds) / 2;
        rightFrame.size.height = CGRectGetHeight(self.bounds);
        _rightSupplementaryView.frame = rightFrame;
    }

    // If only one tab is enabled, we won't show the tabs
    NSArray *enabledStates = [self.enabledStates select:^BOOL(NSNumber *flag) {
        return flag.boolValue;
    }];

    if (enabledStates.count < 2) return;

    enabledButtons = [NSMutableArray array];

    for (NSString *title in self.titles) {
        NSInteger index = [self.titles indexOfObject:title];

        if (self.enabledStates && [self.enabledStates[index] boolValue]) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button addTarget:self action:@selector(buttonPushed:) forControlEvents:UIControlEventTouchUpInside];

            CGFloat fontSize = ([UIDevice isPad]) ? ARFontSerif : ARPhoneFontSerif;
            if (CGRectGetWidth(self.bounds) == 320) {
                fontSize -= 2;
            }
            button.titleLabel.font = [UIFont serifFontWithSize:fontSize];
            button.accessibilityLabel = title;
            button.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            button.tag = index;
            button.enabled = (index != _selectedIndex);

            // set title colours, remember we're faking a switch, so they are backwards
            UIColor *fontColor = [UIColor artsyForegroundColor];
            [button setTitleColor:[fontColor colorWithAlphaComponent:0.5] forState:UIControlStateNormal];
            [button setTitleColor:[fontColor colorWithAlphaComponent:0.3] forState:UIControlStateHighlighted];
            [button setTitleColor:[fontColor colorWithAlphaComponent:1] forState:UIControlStateDisabled];
            [button setTitle:[title uppercaseString] forState:UIControlStateNormal];

            CGRect buttonFrame = self.bounds;
            buttonFrame.size.width = button.intrinsicContentSize.width + (ARSerifViewButtonMargin * 2);
            button.frame = buttonFrame;

            [enabledButtons addObject:button];
        }
    }

    CGFloat totalWidth = 0;

    for (UIButton *button in enabledButtons) {
        totalWidth += CGRectGetWidth(button.bounds);
    }

    CGFloat xOffset = CGRectGetWidth(self.bounds) / 2 - totalWidth / 2;
    for (UIButton *button in enabledButtons) {
        // set the x position
        CGRect buttonFrame = button.frame;
        buttonFrame.origin.x = xOffset;
        xOffset += buttonFrame.size.width;

        button.frame = buttonFrame;

        // take into account the font's line-height
        button.contentEdgeInsets = UIEdgeInsetsMake(8, 0, 0, 0);
        [self addSubview:button];

        // Add the dividers
        if (button != [enabledButtons lastObject]) {
            UIImage *separator = [UIImage imageNamed:@"switch_seperator"];
            separator = [separator imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];

            UIImageView *dividerImage = [[UIImageView alloc] initWithImage:separator];
            dividerImage.tintColor = [UIColor artsyForegroundColor];

            CGFloat x = CGRectGetMaxX(button.frame) - CGRectGetWidth(dividerImage.frame) / 2;
            CGFloat y = CGRectGetHeight(self.frame) / 2 - CGRectGetHeight(dividerImage.frame) / 2;
            y += 2;

            CGRect frame = CGRectMake(x, y, dividerImage.bounds.size.width, dividerImage.bounds.size.height);
            dividerImage.frame = frame;

            // Place above the buttons so they can effectively ignore them
            // in their own layouts
            [self insertSubview:dividerImage atIndex:99];
        }
    }

    [self setSelectedIndex:_selectedIndex animated:NO];
}

- (void)setTitles:(NSArray *)titles
{
    [super setTitles:titles];
    [self updateIntrinsicContentSize];
}

- (void)buttonPushed:(UIButton *)button
{
    NSInteger index = button.tag;

    [self setSelectedIndex:index animated:YES];

    if ([self.delegate respondsToSelector:@selector(switchView:didSelectIndex:animated:)]) {
        [self.delegate switchView:self didSelectIndex:index animated:YES];
    }
}

- (NSInteger)selectedIndex
{
    return _selectedIndex;
}

- (void)setSelectedIndex:(NSInteger)index animated:(BOOL)animated
{
    // Make the old one usable
    _selectedIndex = index;

    for (UIButton *button in enabledButtons) {
        button.enabled = (button.tag != index);
    }
}

- (void)setRightSupplementaryView:(UIView *)rightSupplementaryView
{
    [_rightSupplementaryView removeFromSuperview];
    _rightSupplementaryView = rightSupplementaryView;
    [self updateIntrinsicContentSize];
    [self setNeedsLayout];
}

- (void)updateIntrinsicContentSize
{
    NSArray *enabledOnlyStates = [self.enabledStates select:^BOOL(NSNumber *flag) {
        return flag.boolValue;
    }];

    hasContent = enabledOnlyStates.count > 1 || self.rightSupplementaryView;
}

- (CGSize)intrinsicContentSize
{
    return (CGSize){UIViewNoIntrinsicMetric, hasContent ? ARSwitchViewHeight : 0};
}

@end
