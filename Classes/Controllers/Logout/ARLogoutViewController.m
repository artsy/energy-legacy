#import "ARLogoutViewController.h"


@implementation ARLogoutViewController {
    IBOutlet UILabel *_statusLabel;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    _statusLabel.font = [UIFont sansSerifFontWithSize:ARFontSansRegular];
    _statusLabel.text = @"LOGGING OUT";
}

@end
