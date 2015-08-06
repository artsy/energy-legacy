#import <Foundation/Foundation.h>


@interface UIViewController (SimpleChildren)

/// Add a childVC to another controller, deals with the normal
/// View Controller containment methods.

- (void)ar_addChildViewController:(UIViewController *)controller atFrame:(CGRect)frame;

/// Allows you to add a childViewController inside a view in your hierarchy and will deal
/// the normal view controller containment methods.

- (void)ar_addChildViewController:(UIViewController *)controller inView:(UIView *)view atFrame:(CGRect)frame;

/// For Auto-Layout child view controllers. The other methods aren't deprecated yet but you shouldn't be using them.
- (void)ar_addModernChildViewController:(UIViewController *)controller;

/// For Auto Layout, adds the childVC but allows you to place the view inside another view
- (void)ar_addModernChildViewController:(UIViewController *)controller intoView:(UIView *)view;

/// Remove a child View Controller and removes from superview
- (void)ar_removeChildViewController:(UIViewController *)controller;
@end
