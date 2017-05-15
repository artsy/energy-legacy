

@interface ARTheme : NSObject

/// Setup the UIAppearance tints and image backgrounds
/// mainly for the navigation bar
+ (void)setupWithWhiteFolio:(BOOL)useWhiteFolio;

/// As it's possible to change colours of the fly, we
/// can trigger a UIAppearance cascade of tintViewDidChange
/// by changing it on the window.
+ (void)setupWindowTintOnWindow:(UIWindow *)window;

+ (void)resetWindowTint;

+ (void)setWindowTint:(UIColor *)tintColor;

@end
