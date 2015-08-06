#import "ARAmbiguousSplitStackView.h"
#import <ORStackView/ORSplitStackView.h>


@interface ARAmbiguousSplitStackView ()
@property (nonatomic, weak, readonly) ORStackView *stackView;
@property (nonatomic, weak, readonly) ORSplitStackView *splitStackView;
@property (nonatomic, assign, readwrite) BOOL addToRightStack;
@end


@implementation ARAmbiguousSplitStackView

- (instancetype)init
{
    self = [self initWithFrame:CGRectZero];

    _itemsPerSplitToggle = 1;

    return self;
}

- (void)addSubview:(UIView *)view withTopMargin:(NSString *)margin
{
    [self addSubview:view withTopMargin:margin sideMargin:nil];
}

- (void)addSubview:(UIView *)view withTopMargin:(NSString *)topMargin sideMargin:(NSString *)sideMargin
{
    if (!self.stackView && !self.splitStackView) {
        [self addStack];
    }

    ORStackView *stack = nil;
    if (self.stackView) {
        stack = self.stackView;

    } else if (self.splitStackView) {
        stack = self.addToRightStack ? self.splitStackView.rightStack : self.splitStackView.leftStack;

        if (self.itemsPerSplitToggle == 1 || (stack.subviews.count) % self.itemsPerSplitToggle) {
            self.addToRightStack = !self.addToRightStack;
        }
    }

    [stack addSubview:view withTopMargin:topMargin sideMargin:sideMargin];
}

- (void)addStack
{
    if (self.isSplit) {
        ORSplitStackView *splitStack = [[ORSplitStackView alloc] initWithLeftPredicate:nil rightPredicate:nil];
        [super addSubview:splitStack];

        NSString *marginString = [NSString stringWithFormat:@"%@", @(self.centerMargin / 2)];
        [splitStack.leftStack alignAttribute:NSLayoutAttributeTrailing toAttribute:NSLayoutAttributeCenterX ofView:self predicate:[@"-" stringByAppendingString:marginString]];
        [splitStack.rightStack alignAttribute:NSLayoutAttributeLeading toAttribute:NSLayoutAttributeCenterX ofView:self predicate:marginString];

        [self alignToView:splitStack];
        _splitStackView = splitStack;

    } else {
        ORStackView *stackView = [[ORStackView alloc] init];
        stackView.bottomMarginHeight = 0;

        [super addSubview:stackView];

        [self alignToView:stackView];
        _stackView = stackView;
    }
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    [super setBackgroundColor:backgroundColor];
    [self.stackView setBackgroundColor:backgroundColor];
    [self.splitStackView setBackgroundColor:backgroundColor];
    [self.splitStackView.rightStack setBackgroundColor:backgroundColor];
    [self.splitStackView.leftStack setBackgroundColor:backgroundColor];
}

@end
