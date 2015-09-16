@import Artsy_UIFonts;

#import "ARSettingsBaseViewController.h"


@implementation ARSettingsBaseViewController

NSString *SettingsCellReuse = @"SettingsCellReuse";

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self addBackButton];

    if (_tableView) {
        [_tableView reloadData];
        _tableView.bounces = NO;
        _tableView.separatorInset = UIEdgeInsetsZero;
    }
}

- (void)setTitle:(NSString *)title
{
    UILabel *titleView = (UILabel *)self.navigationItem.titleView;
    if (!titleView) {
        titleView = [[UILabel alloc] initWithFrame:CGRectZero];
        titleView.backgroundColor = [UIColor whiteColor];
        title = [title uppercaseString];

        titleView.font = [UIFont sansSerifFontWithSize:ARFontSansRegular];
        titleView.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.0];
        titleView.textColor = [UIColor blackColor];
        titleView.textAlignment = NSTextAlignmentCenter;

        self.navigationItem.titleView = titleView;
    }
    if ([titleView respondsToSelector:@selector(text)]) {
        titleView.text = [title uppercaseString];
    }
    [self.navigationItem.titleView sizeToFit];
}

#pragma mark stubs
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"warning %@", NSStringFromSelector(_cmd));

    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SettingsCellReuse];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"warning %@", NSStringFromSelector(_cmd));
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"warning %@", NSStringFromSelector(_cmd));
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [sectionHeaders count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return sectionHeaders[section];
}

- (void)addBackButton
{
    if ([self.navigationController.viewControllers count] > 1) {
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [backButton setBackgroundImage:[UIImage imageNamed:@"MenuBack"] forState:UIControlStateNormal];
        [backButton setBackgroundImage:[UIImage imageNamed:@"MenuBackSelected"] forState:UIControlStateHighlighted];
        backButton.titleLabel.font = [UIFont sansSerifFontWithSize:ARFontSansSmall];
        [backButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
        backButton.frame = CGRectMake(0, 0, 64, 32);
        backButton.accessibilityLabel = @"SettingsBackButton";
        UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        self.navigationItem.hidesBackButton = YES;
        self.navigationItem.leftBarButtonItem = barButtonItem;
    }
}

- (void)popViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
