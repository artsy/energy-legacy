#import "ARRootNavigationControllerDelegate.h"
#import "UIButton+FolioButtons.h"


@interface ARRootNavigationControllerDelegate ()
@property (nonatomic, weak) UINavigationController *navigationController;
@end


@implementation ARRootNavigationControllerDelegate

//- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
//{
//    _navigationController = navigationController;
//    if ([navigationController.viewControllers count] > 1 && [UIDevice isPad]) {
//        NSInteger viewIndex = [navigationController.viewControllers indexOfObject:viewController];
//        if (viewIndex == NSNotFound) return;
//
//        NSString *title = [navigationController.viewControllers[viewIndex - 1] title];
//
//        UIButton *backButton = [UIButton folioUnborderedToolbarButtonWithTitle:title];
//        backButton.accessibilityLabel = @"Back";
//
//        UIImage *backgroundImage = [[[UIImage imageNamed:@"BackButtonBackground"] stretchableImageWithLeftCapWidth:24 topCapHeight:4] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
//        [backButton setBackgroundImage:backgroundImage forState:UIControlStateNormal];
//
//        CGSize textSize = [title ar_sizeWithFont:backButton.titleLabel.font constrainedToSize:CGSizeMake(120, 20)];
//        backButton.titleEdgeInsets = UIEdgeInsetsMake(0, 30, 0, 15);
//
//        backButton.frame = CGRectMake(0, 0, textSize.width + 80, 44);
//        [backButton addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
//
//        UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
//        viewController.navigationItem.hidesBackButton = YES;
//        viewController.navigationItem.leftBarButtonItem = barButtonItem;
//    }
//}

- (void)pop
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
