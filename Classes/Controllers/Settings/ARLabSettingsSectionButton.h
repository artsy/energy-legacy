


@interface ARLabSettingsSectionButton : UIButton

- (void)setTitle:(NSString *)title;

- (void)setTitleTextColor:(UIColor *)color;

/// Hides default top border
- (void)hideTopBorder;

/// Hides default chevron
- (void)hideChevron;

/// Can show or hide alert badge; by default it's hidden
- (void)showAlertBadge:(BOOL)show;

@end
