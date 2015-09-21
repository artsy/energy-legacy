//  Based on http://stackoverflow.com/questions/849458/transparent-modal-view-on-navigation-controller

#import "ARAlertViewController.h"

typedef NS_ENUM(NSInteger, ARTransparentModalAnimationStyle) {
    ARTransparentModalAnimationStyleCrossDissolve,
    ARTransparentModalAnimationStyleVerticalSpring,
};


@interface UIViewController (TransparentModals)

- (void)setTransparentModalViewController:(UIViewController *)viewController;

- (UIViewController *)transparentModalViewController;

// legacy present method; defaults to vertical spring style
- (void)presentTransparentModalViewController:(UIViewController *)aViewController
                                     animated:(BOOL)isAnimated
                                    withAlpha:(CGFloat)anAlpha;

- (void)presentTransparentModalViewController:(UIViewController *)aViewController
                                     animated:(BOOL)isAnimated
                                    withAlpha:(CGFloat)anAlpha
                                    withStyle:(ARTransparentModalAnimationStyle)style;

// legacy dismiss method; defaults to vertical spring style
- (void)dismissTransparentModalViewControllerAnimated:(BOOL)animated;

- (void)dismissTransparentModalViewControllerAnimated:(BOOL)animated withStyle:(ARTransparentModalAnimationStyle)style;

- (void)presentTransparentAlertWithText:(NSString *)text withOKAs:(NSString *)okText andCancelAs:(NSString *)cancel completion:(void (^)(enum ARModalAlertViewControllerStatus))completion;

@end
