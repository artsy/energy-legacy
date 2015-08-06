#import "ARNavigationController+Testing.h"
#import "ARTheme.h"
#import "ARNavigationBar.h"
#import "UIDevice+DeviceInfo.h"


@implementation ARNavigationController (Testing)

+ (instancetype)onscreenNavigationController
{
    return [self onscreenNavigationControllerWithRootViewController:nil];
}

+ (instancetype)onscreenNavigationControllerWithRootViewController:(UIViewController *)controller;
{
    ARNavigationController *navController = [[ARNavigationController alloc] init];
    [(ARNavigationBar *)navController.navigationBar setExtendedHeight:[UIDevice isPad]];

    if (controller) {
        navController.viewControllers = @[ controller ];
    }

    UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    window.rootViewController = controller;
    [controller beginAppearanceTransition:YES animated:NO];
    [window makeKeyAndVisible];
    [controller endAppearanceTransition];

    [ARTheme setupWindowTintOnWindow:window];
    [navController.navigationBar tintColorDidChange];

    return navController;
}

@end
