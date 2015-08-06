#import "ARSearchViewController.h"
#import "ARPopoverController.h"

@class ARSelectionToolbarView;


@interface ARNavigationController : UINavigationController <ARSearchViewControllerDelegate, WYPopoverControllerDelegate>

+ (ARNavigationController *)rootController;
+ (NSString *)pageID;

- (NSDictionary *)dictionaryForViewControllers;

- (UIBarButtonItem *)newSearchPopoverButton;

/// Allows you to change the transparency of the navigation bar background
- (void)setBarTransparency:(BOOL)transparent;

@end
