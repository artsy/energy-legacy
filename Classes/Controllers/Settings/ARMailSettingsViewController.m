#import <Artsy+UIFonts/UIFont+ArtsyFonts.h>

#import "ARMailSettingsViewController.h"
#import "ARSettingsDefaultsEditor.h"
#import "ARTableViewCell.h"


@implementation ARMailSettingsViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        sectionHeaders = [[NSMutableArray alloc] initWithObjects:@"Email Settings", nil];
        optionsTitles = @[ @"CC Address", @"1 Artwork Subject", @"Multiple Artworks subject", @"Works from Artist Subject", @"Greeting", @"Signature" ];
        optionsDefaultStrings = @[ AREmailCCEmail, AREmailSubject, ARMultipleEmailSubject, ARMultipleSameArtistEmailSubject, AREmailGreeting, AREmailSignature ];
        self.title = [@"Mail Settings" uppercaseString];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.tableView.accessibilityLabel = @"Mail Settings TableView";
    [super viewWillAppear:animated];
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:SettingsCellReuse];
    if (cell == nil) {
        cell = [[ARTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SettingsCellReuse];
    }
    cell.textLabel.font = [UIFont sansSerifFontWithSize:ARFontSansRegular];

    if ([optionsTitles count] > indexPath.row) {
        cell.textLabel.text = [optionsTitles[indexPath.row] uppercaseString];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        NSString *preview = [[NSUserDefaults standardUserDefaults] objectForKey:optionsDefaultStrings[indexPath.row]];
        if (!preview || [preview isEqualToString:@""]) preview = @"Not set";
        cell.detailTextLabel.text = preview;
    }
    return cell;
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([optionsTitles count] > indexPath.row) {
        ARSettingsDefaultsEditor *editorVC = [[ARSettingsDefaultsEditor alloc] initWithNibName:@"ARSettingsDefaultsEditor" bundle:nil];
        editorVC.title = [NSString stringWithFormat:@"Edit %@", optionsTitles[indexPath.row]];
        editorVC.defaultsAddress = optionsDefaultStrings[indexPath.row];
        [self.navigationController pushViewController:editorVC animated:YES];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)aTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ARTableViewCellSettingsHeight;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
    return optionsTitles.count;
}

- (CGSize)preferredContentSize
{
    CGFloat height = ARTableViewCellSettingsHeight;
    height += optionsTitles.count * ARTableViewCellSettingsHeight;
    return CGSizeMake(320, height);
}

@end
