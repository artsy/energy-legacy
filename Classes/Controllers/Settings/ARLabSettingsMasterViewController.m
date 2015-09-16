#import "ARLabSettingsMasterViewController.h"
#import "AROptions.h"
#import "ARTopViewController.h"

@interface ARLabSettingsMasterViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *exitButton;
@property (nonatomic, strong) NSArray *settings;
@end

@implementation ARLabSettingsMasterViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.settings = @[ @"Sync Content", @"Presentation Mode", @"Take me back to the old settings format please", @"Exit"];
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

    cell.textLabel.text = self.settings[indexPath.row];

    if ([self.settings[indexPath.row] isEqualToString:@"Sync Content"]) cell.backgroundColor = [UIColor orangeColor];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *selectedSetting = self.settings[indexPath.row];

    if ([selectedSetting isEqualToString:@"Exit"]) [self selfDestruct];
    else if ([selectedSetting isEqualToString:@"Take me back to the old settings format please"]) {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:AROptionsUseLabSettings];
        [self selfDestruct];
    }
}

- (IBAction)exitButtonPressed:(id)sender
{
    [self selfDestruct];
}

- (void)selfDestruct
{
    ARTopViewController *mainVC = [ ARTopViewController sharedInstance];
    [mainVC dismissViewControllerAnimated:YES completion:nil];
}

@end
