// Has a UINavigationItem-like API for adding bottom aligned buttons to a view


@interface ARBottomAlignedToolbar : UIView

@property (weak, nonatomic, readwrite) UINavigationItem *proxyNavItem;

@property (copy, nonatomic) NSArray *leftBarButtonItems;
@property (copy, nonatomic) NSArray *rightBarButtonItems;

@property (readwrite, nonatomic, strong) UIBarButtonItem *leftBarButtonItem;
@property (readwrite, nonatomic, strong) UIBarButtonItem *rightBarButtonItem;

- (void)setTitleView:(UIView *)titleView;

@end
