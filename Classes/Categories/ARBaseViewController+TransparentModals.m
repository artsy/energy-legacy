#import "ARBaseViewController+TransparentModals.h"
#import <objc/runtime.h>


@interface UIViewController (Property)
@property (nonatomic, strong) NSObject *transparentViewController;
@end


@implementation UIViewController (TransparentModals)

- (void)setTransparentModalViewController:(UIViewController *)viewController
{
    objc_setAssociatedObject(self, @selector(transparentViewController), viewController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIViewController *)transparentModalViewController
{
    return objc_getAssociatedObject(self, @selector(transparentViewController));
}

- (void)presentTransparentModalViewController:(UIViewController *)aViewController
                                     animated:(BOOL)isAnimated
                                    withAlpha:(CGFloat)anAlpha
{
    self.transparentModalViewController = aViewController;
    UIView *view = aViewController.view;

    view.opaque = NO;
    view.backgroundColor = [view.backgroundColor colorWithAlphaComponent:0];

    if (isAnimated) {
        CGRect mainrect = [self.view bounds];
        CGRect newRect = CGRectMake(0, mainrect.size.height, mainrect.size.width, mainrect.size.height);

        [self.view addSubview:view];
        view.frame = newRect;

        [UIView animateWithDuration:ARAnimationLongDuration delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            view.frame = mainrect;
            
            if (self.navigationController) {
                self.navigationController.navigationBar.alpha = 0.5;
                self.navigationController.navigationBar.userInteractionEnabled = NO;
            }

        } completion:^(BOOL finished) {
            [UIView animateWithDuration:ARAnimationQuickDuration animations:^{
                view.backgroundColor = [view.backgroundColor colorWithAlphaComponent:anAlpha];
            }];
        }];

    } else {
        view.frame = [[UIScreen mainScreen] bounds];
        view.backgroundColor = [view.backgroundColor colorWithAlphaComponent:anAlpha];
        [self.view addSubview:view];
    }
}

- (void)dismissTransparentModalViewControllerAnimated:(BOOL)animated
{
    UIView *view = self.transparentModalViewController.view;
    view.backgroundColor = [view.backgroundColor colorWithAlphaComponent:0];

    CGRect mainrect = [self.view bounds];
    CGRect newRect = CGRectMake(0, mainrect.size.height, mainrect.size.width, mainrect.size.height);

    [UIView animateIf:animated duration:ARAnimationDuration:^{
        self.transparentModalViewController.view.frame = newRect;
        if (self.navigationController) {
            self.navigationController.navigationBar.alpha = 1;
            self.navigationController.navigationBar.userInteractionEnabled = YES;
        }
    } completion:^(BOOL finished) {
        [self.transparentModalViewController.view removeFromSuperview];
        self.transparentModalViewController = nil;
    }];
}

- (void)presentTransparentAlertWithText:(NSString *)text withOKAs:(NSString *)okText andCancelAs:(NSString *)cancel completion:(void (^)(enum ARModalAlertViewControllerStatus))completion
{
    ARAlertViewController *alertVC = [[ARAlertViewController alloc] initWithCompletionBlock:completion];
    alertVC.okTitle = okText;
    alertVC.cancelTitle = cancel;
    alertVC.alertText = text;

    [self presentTransparentModalViewController:alertVC animated:YES withAlpha:0.3];
}

@end
