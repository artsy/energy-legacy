@import Artsy_UIFonts;

#import "ARSettingsDefaultsEditor.h"
#import "ARTableViewCell.h"

// this size gives it a perfect 10px margin from sides / keyboard in landscape
CGFloat ViewHeightBeforeResizing = 275;


@interface ARSettingsDefaultsEditor (
    private)
- (void)setupStyle;
@end


@implementation ARSettingsDefaultsEditor

@synthesize defaultsAddress;
@synthesize textView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];

    textView.text = [[NSUserDefaults standardUserDefaults] stringForKey:self.defaultsAddress];
    [textView becomeFirstResponder];
    textView.tintColor = [UIColor artsyPurple];

    [self setupStyle];
}

- (IBAction)save:(id)sender
{
    [ARAnalytics event:AREmailSettingsChangeEvent withProperties:@{ @"Setting" : self.defaultsAddress }];

    [[NSUserDefaults standardUserDefaults] setObject:textView.text forKey:self.defaultsAddress];
    [[NSUserDefaults standardUserDefaults] synchronize];

    [self cancel:self];
}

- (IBAction)cancel:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupStyle
{
    textView.font = [UIFont serifFontWithSize:ARFontSerif];
    cancelButton.titleLabel.font = [UIFont sansSerifFontWithSize:ARFontSansRegular];
    saveButton.titleLabel.font = [UIFont sansSerifFontWithSize:ARFontSansRegular];
}

- (CGSize)preferredContentSize
{
    CGFloat height = ARTableViewCellSettingsHeight;
    height += [UIDevice isPad] ? ViewHeightBeforeResizing : 140;
    return CGSizeMake(320, height);
}

@end
