

@interface UIBarButtonItem (toolbarHelpers)

/// Generate a square toolbar button with a symbol
+ (UIBarButtonItem *)toolbarImageButtonWithName:(NSString *)name withTarget:(id)target andSelector:(SEL)selector;

/// Generate a text based bar button that has a title
+ (UIBarButtonItem *)toolbarButtonWithTitle:(NSString *)title target:(id)target action:(SEL)action;

/// Grab the button behind the toolbar button, will return nil if custom view is not a button
- (UIButton *)representedButton;

@end
