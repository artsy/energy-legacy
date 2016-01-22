
@import MessageUI;

#import "ARTheme.h"
#import "ARNavigationBar.h"
#import "ARTextToolbarButton.h"
#import "AROptions.h"
#import "ARNavigationController.h"
#import "ARTopViewController.h"


@implementation ARTheme

+ (void)setupWithWhiteFolio:(BOOL)useWhiteFolio
{
    [UIColor updateFolioColorsToWhite:useWhiteFolio];

    [self setupBackButton];
    [self setupNavTitle];
    [self setupNavigationButtons];

    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [self setupWindowTintOnWindow:window];
    [self setupMailViewControllerButtons];
}

+ (void)setupWindowTintOnWindow:(UIWindow *)window
{
    window.tintColor = [UIColor artsyForegroundColor];
    window.backgroundColor = [UIColor artsyBackgroundColor];
}

+ (void)setupMailViewControllerButtons
{
    [[UIBarButtonItem appearanceWhenContainedIn:MFMailComposeViewController.class, nil] setTitleTextAttributes:@{
        NSForegroundColorAttributeName : [UIColor blackColor],
        NSFontAttributeName : [UIFont boldSystemFontOfSize:14],
    } forState:UIControlStateNormal];
}

/// Note: Nav bar theming is done in ARNavigationBar.xib

+ (void)setupBackButton
{
    BOOL whiteFolio = [AROptions boolForOption:AROptionsUseWhiteFolio];

    [[UIBarButtonItem appearanceWhenContainedIn:ARNavigationBar.class, nil] setBackgroundVerticalPositionAdjustment:-15 forBarMetrics:UIBarMetricsDefault];

    [[UIBarButtonItem appearanceWhenContainedIn:ARNavigationBar.class, nil] setTitleTextAttributes:@{
        NSForegroundColorAttributeName : [UIColor artsyForegroundColor],
        NSFontAttributeName : [UIFont sansSerifFontWithSize:16]

    } forState:UIControlStateNormal & UIControlStateHighlighted & UIControlStateDisabled];

    if ([UIDevice isPad]) {
        UIImage *base = whiteFolio ? [[UIImage imageNamed:@"BackButtonBackground"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] : [[UIImage imageNamed:@"BackButtonBackgroundWhite"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];

        UIImage *backgroundImage = [base resizableImageWithCapInsets:UIEdgeInsetsMake(22, 22, 22, 26)];

        [[UIBarButtonItem appearanceWhenContainedIn:ARNavigationBar.class, nil] setBackButtonBackgroundImage:backgroundImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];

        [[UIBarButtonItem appearanceWhenContainedIn:ARNavigationBar.class, nil] setBackButtonTitlePositionAdjustment:UIOffsetMake(5, -15) forBarMetrics:UIBarMetricsDefault];

        [[UIBarButtonItem appearanceWhenContainedIn:ARNavigationBar.class, nil] setBackButtonBackgroundVerticalPositionAdjustment:-14 forBarMetrics:UIBarMetricsDefault];
    }


    [[UINavigationBar appearance] setTintColor:[UIColor artsyForegroundColor]];
    [ARNavigationController rootController].navigationBar.tintColor = [UIColor artsyForegroundColor];
    [[ARNavigationController rootController].navigationBar tintColorDidChange];
}

+ (void)setupNavTitle
{
    if ([UIDevice isPad]) {
        [[ARNavigationBar appearance] setTitleVerticalPositionAdjustment:-15 forBarMetrics:UIBarMetricsDefault];
    }

    [[ARNavigationBar appearance] setBarTintColor:[UIColor artsyBackgroundColor]];
    [[ARNavigationBar appearance] setTintColor:[UIColor artsyForegroundColor]];

    // Because UINavbars don't use tintColor for BG we have to send the tintColorDidChange ourselves
    [[ARNavigationController rootController].navigationBar tintColorDidChange];
}

+ (void)setupNavigationButtons
{
    BOOL whiteFolio = [AROptions boolForOption:AROptionsUseWhiteFolio];
    UIImage *selectedBGImage = whiteFolio ? [UIImage imageNamed:@"Black.png"] : [UIImage imageNamed:@"White.png"];

    [[ARTextToolbarButton appearance] setBackgroundImage:selectedBGImage forState:UIControlStateSelected];
    [[ARTextToolbarButton appearance] setTitleColor:[UIColor artsyBackgroundColor] forState:UIControlStateSelected];
}

@end
