#import "ARBottomAlignedToolbar.h"

NS_ENUM(NSInteger, ARBottomAlignedToolbarDirection){
    ARBottomAlignedToolbarSideLeft,
    ARBottomAlignedToolbarDirectionRight};


@interface ARBottomAlignedToolbar ()
@property (readonly, nonatomic, strong) NSArray *rightButtons;
@property (readonly, nonatomic, strong) NSArray *leftButtons;
@end


@implementation ARBottomAlignedToolbar

- (instancetype)init
{
    self = [super init];
    if (!self) return self;

    self.backgroundColor = [UIColor artsyBackgroundColor];
    return self;
}

- (CGSize)intrinsicContentSize
{
    return (CGSize){UIViewNoIntrinsicMetric, 56};
}

- (void)setLeftBarButtonItem:(UIBarButtonItem *)leftBarButtonItem
{
    [self setLeftBarButtonItems:@[ leftBarButtonItem ?: [NSNull null] ]];
}

- (void)setLeftBarButtonItems:(NSArray *)leftBarButtonItems
{
    _leftBarButtonItems = leftBarButtonItems;
    _leftButtons = [self _setBarButtonItems:leftBarButtonItems direction:ARBottomAlignedToolbarSideLeft];
}

- (void)setRightBarButtonItem:(UIBarButtonItem *)rightBarButtonItem
{
    [self setRightBarButtonItems:@[ rightBarButtonItem ?: [NSNull null] ]];
}

- (void)setRightBarButtonItems:(NSArray *)rightBarButtonItems
{
    _rightBarButtonItems = rightBarButtonItems;
    _rightButtons = [self _setBarButtonItems:rightBarButtonItems direction:ARBottomAlignedToolbarDirectionRight];
}

- (NSArray *)_setBarButtonItems:(NSArray *)items direction:(enum ARBottomAlignedToolbarDirection)direction
{
    NSArray *buttons = (direction == ARBottomAlignedToolbarSideLeft) ? self.leftButtons : self.rightButtons;
    [buttons makeObjectsPerformSelector:@selector(removeFromSuperview)];

    __block UIButton *previousButton;

    return [[items select:^BOOL(id object) {
        return object != [NSNull null];

    }] map:^(UIBarButtonItem *item) {
        BOOL isFirstItem = [items indexOfObject:item] == 0;

        UIButton *button = nil;
        if ([item.customView isKindOfClass:UIButton.class]) {
            button = (id)item.customView;
        } else {
            button = [UIButton folioToolbarButtonWithTitle:item.title];
            [button addTarget:item.target action:item.action forControlEvents:UIControlEventTouchUpInside];
            [button setTitle:item.title forState:UIControlStateNormal];
        }

        [self addSubview:button];

        if (direction == ARBottomAlignedToolbarSideLeft) {
            if (isFirstItem) {
                [button alignLeadingEdgeWithView:self predicate:@"10"];
            } else {
                [button constrainLeadingSpaceToView:previousButton predicate:@"10"];
            }

        } else {
            if (isFirstItem) {
                [button alignTrailingEdgeWithView:self predicate:@"-10"];
            } else {
                [button alignAttribute:NSLayoutAttributeTrailing toAttribute:NSLayoutAttributeLeading ofView:previousButton predicate:@"-10"];
            }
        }

        [button alignTopEdgeWithView:self predicate:@"6"];
        previousButton = button;
        return button;
    }];
}

- (void)setTitleView:(UIView *)titleView
{
    self.proxyNavItem.titleView = titleView;
}

@end
