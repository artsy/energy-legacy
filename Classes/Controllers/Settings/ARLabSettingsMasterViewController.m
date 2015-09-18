#import "ARLabSettingsMasterViewController.h"
#import "AROptions.h"
#import "ARLabSettingsNavController.h"


@interface ARLabSettingsMasterViewController ()
@property (weak, nonatomic) IBOutlet UIButton *settingsButton;
@property (weak, nonatomic) IBOutlet UIButton *ogSettingsButton;
@end


@implementation ARLabSettingsMasterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupSettingsButton];
}

- (void)setupSettingsButton
{
    [self.settingsButton setImage:[[UIImage imageNamed:@"settings_btn_whiteborder"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [self.settingsButton setTintColor:UIColor.blackColor];
    [self.settingsButton setBackgroundColor:UIColor.whiteColor];
}

- (IBAction)settingButtonPressed:(id)sender
{
    [self exitSettingsPanel];
}

- (IBAction)ogSettingsButtonPressed:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:AROptionsUseLabSettings];
    [self exitSettingsPanel];
}

- (void)exitSettingsPanel
{
    NSAssert([self.navigationController isKindOfClass:ARLabSettingsNavController.class], @"Master parent must be an ARLabSettingsNavController");
    [self.navigationController dismissViewControllerAnimated:NO completion:nil];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
