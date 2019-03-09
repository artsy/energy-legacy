#import "ARSelectionToolbarView.h"
#import "AROptions.h"


@implementation ARSelectionToolbarView

- (instancetype)init
{
    self = [super init];
    if (!self) return self;

    self.backgroundColor = [UIColor artsyBackgroundColor];

    return self;
}

- (void)tintColorDidChange
{
    for (UIButton *item in self.buttons) {
        [item setTintColor:[UIColor artsyForegroundColor]];
    }
}

- (void)addTopBorder
{
    UIView *topBorder = [[UIView alloc] initWithFrame:self.bounds];
    topBorder.backgroundColor = [UIColor artsySingleLineGrey];
    [self addSubview:topBorder];
    [topBorder constrainHeight:@"1"];
    [topBorder alignTop:@"0" leading:@"0" bottom:nil trailing:@"0" toView:self];
}

- (void)addBottomBorder
{
    UIView *topBorder = [[UIView alloc] initWithFrame:self.bounds];
    topBorder.backgroundColor = [UIColor artsySingleLineGrey];
    [self addSubview:topBorder];
    [topBorder constrainHeight:@"1"];
    [topBorder alignTop:nil leading:@"0" bottom:@"0" trailing:@"0" toView:self];
}

- (CGSize)intrinsicContentSize
{
    return (CGSize){UIViewNoIntrinsicMetric, self.isHorizontallyConstrained ? 60 : 80};
}

- (void)setBarButtonItems:(NSArray *)barButtonItems
{
    _barButtonItems = barButtonItems;

    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    if (self.isAttachedToTop) [self addBottomBorder];
    if (self.isAttachedToBottom) [self addTopBorder];

    _buttons = [barButtonItems map:^(UIBarButtonItem *item) {
        UIButton *button = [self buttonForItem:item];
        item.customView = button;
        return button;
    }];

    _button = self.buttons.firstObject;

    if (self.horizontallyConstrained) {
        [self fillWidthButtons];
    } else {
        [self alignButtonsTrailing];
    }

    // This is to ensure it never gets caught layouting in
    // an animation context.

    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (UIButton *)buttonForItem:(UIBarButtonItem *)item
{
    UIButton *button;
    if (self.horizontallyConstrained) {
        button = [UIButton folioUnborderedToolbarButtonWithTitle:item.title];
    } else {
        button = [UIButton folioToolbarButtonWithTitle:item.title];
    }
    [button addTarget:item.target action:item.action forControlEvents:UIControlEventTouchUpInside];

    return button;
}

- (CGFloat)widthMultiplier
{
    return 1.0 / self.barButtonItems.count;
}

- (void)fillWidthButtons
{
    NSString *widthPredicateWithMultiplier = NSStringWithFormat(@"*%f", self.widthMultiplier);
    [self.buttons eachWithIndex:^(UIButton *button, NSUInteger index) {
        [self addSubview:button];
        [button constrainWidthToView:self predicate:widthPredicateWithMultiplier];

        if (index == 0) {
            [button alignLeadingEdgeWithView:self predicate:nil];
        } else {
            [self addLeadingBorderToButton:button];
            [button constrainLeadingSpaceToView:self.buttons[index - 1] predicate:nil];
        }

        if (self.isAttachedToTop) {
            [button alignBottomEdgeWithView:self predicate:@"0"];
        } else if (self.isAttachedToBottom) {
            [button alignTopEdgeWithView:self predicate:@"0"];
        }

        [button constrainHeight:@"58"];
    }];
}

- (void)addLeadingBorderToButton:(UIButton *)button
{
    UIView *topBorder = [[UIView alloc] initWithFrame:self.bounds];
    topBorder.backgroundColor = [UIColor artsySingleLineGrey];
    [button addSubview:topBorder];
    [topBorder constrainWidth:@"1"];
    [topBorder alignTop:@"-1" leading:@"0" bottom:@"1" trailing:nil toView:button];
}

- (void)alignButtonsTrailing
{
    [self.buttons eachWithIndex:^(UIButton *button, NSUInteger index) {
        [self addSubview:button];

        if (index == 0) {
            [button alignTrailingEdgeWithView:self predicate:@"-20"];

        } else {
            [button alignAttribute:NSLayoutAttributeTrailing toAttribute:NSLayoutAttributeLeading ofView:self.buttons[index - 1] predicate:@"-20"];
        }
        [button alignTopEdgeWithView:self predicate:@"20"];
        [button constrainHeight:@"43"];
    }];
}


@end
