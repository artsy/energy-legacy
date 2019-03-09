


@implementation UIBarButtonItem (toolbarHelpers)

+ (UIBarButtonItem *)toolbarImageButtonWithName:(NSString *)name withTarget:(id)target andSelector:(SEL)selector
{
    UIButton *contentButton = [UIButton folioImageButtonWithName:name withTarget:target andSelector:selector];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:contentButton];
    barButton.accessibilityLabel = [NSString stringWithFormat:@"%@", name];
    return barButton;
}

+ (UIBarButtonItem *)toolbarButtonWithTitle:(NSString *)title target:(id)target action:(SEL)action
{
    UIButton *contentButton = [UIButton folioUnborderedToolbarButtonWithTitle:title];
    [contentButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:contentButton];
}

- (UIButton *)representedButton
{
    if ([self.customView isKindOfClass:[UIButton class]]) return (id)self.customView;
    return nil;
}

@end
