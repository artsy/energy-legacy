#import "ARSupportSettingsViewController.h"
#import "ARTableViewCell.h"
#import "ARAppDelegate.h"
#import "ARAdminSettingsViewController.h"
#import "ARNavigationController.h"
#import "AROptions.h"
#import <Intercom/Intercom.h>

NS_ENUM(NSInteger, ARSupportSettingsPositions){
    ARSupportSettingsAdminSettingsRow,
    ARSupportSettingsEmailRepRow,
    ARSupportSettingsLogoutRow,
};

typedef enum _ARSupportSettingsAlertViewButtonIndex {
    ARSupportSettingsAlertViewButtonIndexCancel,
    ARSupportSettingsAlertViewButtonIndexLogout
} ARSupportSettingsAlertViewButtonIndex;


@interface ARSupportSettingsViewController () <UIAlertViewDelegate>
@end


@implementation ARSupportSettingsViewController

- (instancetype)init
{
    self = [super init];
    if (!self) return nil;

    self.title = [@"Admin & Support" uppercaseString];

    return self;
}

#pragma mark - UITableView delegate and datasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[ARTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"support"];

    if (indexPath.row == ARSupportSettingsLogoutRow) {
        cell.textLabel.text = NSLocalizedString(@"Logout", @"Log out action menu item");

    } else if (indexPath.row == ARSupportSettingsEmailRepRow) {
        cell.textLabel.text = NSLocalizedString(@"Contact Artsy Support", @"Contact Artsy Support menu item");

    } else if (indexPath.row == ARSupportSettingsAdminSettingsRow) {
        cell.textLabel.text = NSLocalizedString(@"Folio Settings", @"Folio Settings menu item");
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == ARSupportSettingsLogoutRow) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self showDidPressLogoutAlertView];


    } else if (indexPath.row == ARSupportSettingsEmailRepRow) {
        [Intercom presentMessageComposer];
        [[NSNotificationCenter defaultCenter] postNotificationName:ARDismissAllPopoversNotification object:nil];

    } else if (indexPath.row == ARSupportSettingsAdminSettingsRow) {
        NSManagedObjectContext *context = [CoreDataManager mainManagedObjectContext];
        NSArray *options = ([[User currentUserInContext:context] isAdmin]) ? [AROptions labsOptions] : nil;

        ARAdminSettingsViewController *settings = [[ARAdminSettingsViewController alloc] initWithContext:context labOptions:options];
        [self.navigationController pushViewController:settings animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ARTableViewCellSettingsHeight;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (CGSize)preferredContentSize
{
    CGFloat height = ARTableViewCellSettingsHeight;
    height += [self tableView:self.tableView numberOfRowsInSection:0] * ARTableViewCellSettingsHeight;
    return CGSizeMake(320, height);
}

#pragma mark - triggered UI actions

- (void)showDidPressLogoutAlertView
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:NSLocalizedString(@"Confirm Logout?", @"Confirm Logout")
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"Cancel", @"Cancel")
                                          otherButtonTitles:NSLocalizedString(@"Logout", @"Logout"), nil];
    [alert show];
}

#pragma mark - UIAlertView delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == ARSupportSettingsAlertViewButtonIndexLogout) {
        ARAppDelegate *appDelegate = (ARAppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate startLogout];

        [[NSNotificationCenter defaultCenter] postNotificationName:ARDismissAllPopoversNotification object:nil];
    }
}

@end
