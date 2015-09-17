#import "ARLabSettingsMasterViewController.h"
#import "AROptions.h"
#import "ARLabSettingsNavController.h"

@interface ARLabSettingsMasterViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *exitButton;
@property (nonatomic, strong) NSArray *settings;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *settingsButton;
@property (nonatomic, strong) ARLabSettingsViewController *splitViewController;
@end

@implementation ARLabSettingsMasterViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.settings = @[ @"Sync Content", @"Presentation Mode", @"OLD SETTINGS PLS"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;

}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.settings.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.textLabel.text = [self.settings[indexPath.row] uppercaseString];
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.font = [UIFont sansSerifFontWithSize:ARFontSansRegular];


    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *selectedSetting = self.settings[indexPath.row];

    if ([selectedSetting isEqualToString:@"OLD SETTINGS PLS"]) {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:AROptionsUseLabSettings];
        [self exitSettingsPanel];
    }
}

- (IBAction)settingButtonPressed:(id)sender
{
    [self exitSettingsPanel];
}

- (void)exitSettingsPanel
{
    NSAssert([self.navigationController isKindOfClass:ARLabSettingsNavController.class], @"Master parent must be an ARLabSettingsNavControllers");
    [self.navigationController dismissViewControllerAnimated:NO completion:nil];

}

-(BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
