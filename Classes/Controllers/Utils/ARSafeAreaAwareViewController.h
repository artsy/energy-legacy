#import <UIKit/UIKit.h>

/// Constrains the available space inside the safeView to a safe area on iOS 11

@interface ARSafeAreaAwareViewController : UIViewController

@property (nonatomic, weak, readonly) UIView *safeView;

@end
