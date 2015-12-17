


@interface UIViewController (SettingsNavigationItemHelpers)

/// Adds a button to dismiss the entire settings split view controller as a left bar button item on its caller. For iPhone, its image is a small x, and for iPad, a square settings icon.
- (void)addSettingsExitButtonWithTarget:(SEL)target animated:(BOOL)animated;

/// Adds an Artsy custom back button as a left bar button item on its caller
- (void)addSettingsBackButtonWithTarget:(SEL)target animated:(BOOL)animated;

@end
