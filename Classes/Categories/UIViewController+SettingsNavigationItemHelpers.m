#import "UIViewController+SettingsNavigationItemHelpers.h"


@implementation UIViewController (SettingsNavigationItemHelpers)


- (void)addSettingsExitButtonWithTarget:(SEL)target animated:(BOOL)animated
{
    self.navigationItem.hidesBackButton = YES;
    [self.navigationItem setLeftBarButtonItem:[self exitSettingsButtonWithTarget:target] animated:animated];
}

- (void)addSettingsBackButtonWithTarget:(SEL)target animated:(BOOL)animated
{
    self.navigationItem.hidesBackButton = YES;

    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];

    negativeSpacer.width = -7;

    [self.navigationItem setLeftBarButtonItems:@[ negativeSpacer, [self settingsBackButtonWithTarget:target] ] animated:animated];
}

- (UIBarButtonItem *)exitSettingsButtonWithTarget:(SEL)target
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];

    [button addTarget:self action:target forControlEvents:UIControlEventTouchUpInside];

    if ([UIDevice isPad]) {
        UIImage *settingsIconNormal = [[UIImage imageNamed:@"settings_btn_whiteborder"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        UIImage *settingsIconHighlighted = [[UIImage imageNamed:@"settings_btn_solidwhite"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [button setImage:settingsIconNormal forState:UIControlStateNormal];
        [button setImage:settingsIconHighlighted forState:UIControlStateHighlighted];

        button.frame = CGRectMake(0, 0, 50, 50);
    } else {
        UIImage *phoneExitIcon = [[UIImage imageNamed:@"close_window"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [button setImage:phoneExitIcon forState:UIControlStateNormal];

        button.frame = CGRectMake(0, 0, 12, 12);
    }

    [button setTintColor:UIColor.blackColor];
    [button setBackgroundColor:UIColor.whiteColor];


    button.accessibilityLabel = @"SettingsExitButton";
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (UIBarButtonItem *)settingsBackButtonWithTarget:(SEL)target
{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setBackgroundImage:[UIImage imageNamed:@"MenuBack"] forState:UIControlStateNormal];
    [backButton setBackgroundImage:[UIImage imageNamed:@"MenuBackSelected"] forState:UIControlStateHighlighted];
    backButton.titleLabel.font = [UIFont sansSerifFontWithSize:10];
    [backButton addTarget:self action:target forControlEvents:UIControlEventTouchUpInside];

    backButton.frame = [UIDevice isPad] ? CGRectMake(0, 0, 80, 40) : CGRectMake(0, 0, 60, 30);

    backButton.accessibilityLabel = @"BackButton";
    return [[UIBarButtonItem alloc] initWithCustomView:backButton];
}

- (void)addTitleViewWithText:(NSString *)text font:(UIFont *)font xOffset:(CGFloat)offset
{
    UILabel *titleView = (UILabel *)self.navigationItem.titleView;
    if (!titleView) {
        titleView = [[UILabel alloc] initWithFrame:CGRectZero];
        titleView.font = font;
        titleView.textColor = [UIColor blackColor];
        titleView.textAlignment = NSTextAlignmentCenter;
        titleView.text = text;

        self.navigationItem.titleView = titleView;
    }

    [self.navigationItem.titleView sizeToFit];

    if (offset) {
        CGRect currentFrame = self.navigationItem.titleView.frame;
        currentFrame.size.width = currentFrame.size.width + 30;
        self.navigationItem.titleView.frame = currentFrame;
    }
}

@end
