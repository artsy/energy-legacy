//  Based on http://stackoverflow.com/questions/849458/transparent-modal-view-on-navigation-controller

#import "ARTopViewController.h"
#import "ARAlertViewController.h"


@interface UIViewController (TransparentModals)

- (void)setTransparentModalViewController:(UIViewController *)viewController;

- (UIViewController *)transparentModalViewController;

- (void)presentTransparentModalViewController:(UIViewController *)aViewController
                                     animated:(BOOL)isAnimated
                                    withAlpha:(CGFloat)anAlpha;

- (void)dismissTransparentModalViewControllerAnimated:(BOOL)animated;

- (void)presentTransparentAlertWithText:(NSString *)text withOKAs:(NSString *)okText andCancelAs:(NSString *)cancel completion:(void (^)(enum ARModalAlertViewControllerStatus))completion;

@end
