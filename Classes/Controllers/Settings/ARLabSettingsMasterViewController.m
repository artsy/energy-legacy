#import "ARLabSettingsMasterViewController.h"
#import "AROptions.h"
#import "Folio-Swift.h"


@interface ARLabSettingsMasterViewController ()
@property (weak, nonatomic) IBOutlet UIButton *settingsButton;
@property (weak, nonatomic) IBOutlet UIButton *ogSettingsButton;
@property (weak, nonatomic) IBOutlet UIButton *syncSettingsButton;
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

- (IBAction)syncSettingsButtonPressed:(id)sender
{
    [self performSegueWithIdentifier:@"syncOptionsSegue" sender:self];
}

- (IBAction)presentationModeButtonPressed:(id)sender
{
    [self performSegueWithIdentifier:@"presentationModeSegue" sender:self];
}

- (IBAction)ogSettingsButtonPressed:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:AROptionsUseLabSettings];
    [self exitSettingsPanel];
}


- (void)exitSettingsPanel
{
    NSAssert([self.navigationController isKindOfClass:ARLabSettingsNavigationController.class], @"Master parent must be an ARLabSettingsNavController");
    [(ARLabSettingsNavigationController *)self.navigationController exitSettingsPanel];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
