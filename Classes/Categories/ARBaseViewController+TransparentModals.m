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
    [self presentTransparentModalViewController:aViewController animated:isAnimated withAlpha:anAlpha withStyle:ARTransparentModalAnimationStyleVerticalSpring];
}

- (void)presentTransparentAlertWithText:(NSString *)text withOKAs:(NSString *)okText andCancelAs:(NSString *)cancel completion:(void (^)(enum ARModalAlertViewControllerStatus))completion
{
    ARAlertViewController *alertVC = [[ARAlertViewController alloc] initWithCompletionBlock:completion];
    alertVC.okTitle = okText;
    alertVC.cancelTitle = cancel;
    alertVC.alertText = text;

    [self presentTransparentModalViewController:alertVC animated:YES withAlpha:0.3 withStyle:ARTransparentModalAnimationStyleVerticalSpring];
}

- (void)presentTransparentModalViewController:(UIViewController *)aViewController
                                     animated:(BOOL)isAnimated
                                    withAlpha:(CGFloat)anAlpha
                                    withStyle:(ARTransparentModalAnimationStyle)style
{
    self.transparentModalViewController = aViewController;
    UIView *view = aViewController.view;

    view.opaque = NO;
    view.backgroundColor = [view.backgroundColor colorWithAlphaComponent:0];

    if (isAnimated) {
        [self.view addSubview:view];

        switch (style) {
            case ARTransparentModalAnimationStyleVerticalSpring:
                [self presentModalWithVerticalSpring:view alpha:anAlpha];
                break;
            case ARTransparentModalAnimationStyleCrossDissolve:
                [self presentModalWithCrossDissolve:view alpha:anAlpha];
                break;
        }

    } else {
        view.frame = [[UIScreen mainScreen] bounds];
        view.backgroundColor = [view.backgroundColor colorWithAlphaComponent:anAlpha];
        [self.view addSubview:view];
    }
}

- (void)presentModalWithVerticalSpring:(UIView *)view alpha:(CGFloat)anAlpha
{
    CGRect mainrect = [self.view bounds];
    CGRect newRect = CGRectMake(0, mainrect.size.height, mainrect.size.width, mainrect.size.height);
    view.frame = newRect;

    [UIView animateWithDuration:ARAnimationLongDuration delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseIn animations:^{

        view.frame = mainrect;

        if (self.navigationController) {
            self.navigationController.navigationBar.alpha = 0.5;
            self.navigationController.navigationBar.userInteractionEnabled = NO;
        }

    } completion:^(BOOL finished) {
        view.backgroundColor = [view.backgroundColor colorWithAlphaComponent:anAlpha];
    }];
}

- (void)presentModalWithCrossDissolve:(UIView *)view alpha:(CGFloat)anAlpha
{
    view.alpha = 0.0;

    [UIView animateWithDuration:ARAnimationLongDuration animations:^{
        view.alpha = 1.0;

        if (self.navigationController) {
            self.navigationController.navigationBar.alpha = 0.5;
            self.navigationController.navigationBar.userInteractionEnabled = NO;
        }
    }];
    view.backgroundColor = [view.backgroundColor colorWithAlphaComponent:anAlpha];
}

- (void)dismissTransparentModalViewControllerAnimated:(BOOL)animated
{
    [self dismissTransparentModalViewControllerAnimated:animated withStyle:ARTransparentModalAnimationStyleVerticalSpring];
}

- (void)dismissTransparentModalViewControllerAnimated:(BOOL)animated withStyle:(ARTransparentModalAnimationStyle)style
{
    void (^completion)() = ^{
        [self.transparentModalViewController.view removeFromSuperview];
        self.transparentModalViewController = nil;
    };

    if (animated) {
        switch (style) {
            case ARTransparentModalAnimationStyleVerticalSpring:
                [self dismissModalVertically:completion];
                break;
            case ARTransparentModalAnimationStyleCrossDissolve:
                [self dimissModalWithCrossDissolve:completion];
                break;
        }
    } else {
        if (self.navigationController) {
            self.navigationController.navigationBar.alpha = 1;
            self.navigationController.navigationBar.userInteractionEnabled = YES;
        }
        completion();
    }
}


- (void)dismissModalVertically:(void (^)(void))completion
{
    UIView *view = self.transparentModalViewController.view;
    view.backgroundColor = [view.backgroundColor colorWithAlphaComponent:0];

    CGRect mainrect = [self.view bounds];
    CGRect newRect = CGRectMake(0, mainrect.size.height, mainrect.size.width, mainrect.size.height);

    [UIView animateWithDuration:ARAnimationDuration animations:^{
        self.transparentModalViewController.view.frame = newRect;
        if (self.navigationController) {
            self.navigationController.navigationBar.alpha = 1;
            self.navigationController.navigationBar.userInteractionEnabled = YES;
        }
    } completion:^(BOOL finished) {
        completion();
    }];
}

- (void)dimissModalWithCrossDissolve:(void (^)(void))completion
{
    UIView *view = self.transparentModalViewController.view;
    view.backgroundColor = [view.backgroundColor colorWithAlphaComponent:0];

    [UIView animateWithDuration:ARAnimationDuration animations:^{
        view.alpha = 0.0;
        if (self.navigationController) {
            self.navigationController.navigationBar.alpha = 1;
            self.navigationController.navigationBar.userInteractionEnabled = YES;
        }
    } completion:^(BOOL finished) {
        completion();
    }];
}

@end
