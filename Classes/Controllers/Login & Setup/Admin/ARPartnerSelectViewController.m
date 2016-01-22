
#import "ARPartnerSelectViewController.h"


@implementation ARPartnerSelectViewController {
    IBOutlet UIPickerView *picker;
    IBOutlet UIButton *button;
    IBOutlet UILabel *label;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    picker.delegate = self;
    picker.dataSource = self;
    label.font = [UIFont sansSerifFontWithSize:ARFontSansLarge];
    button.titleLabel.font = [UIFont sansSerifFontWithSize:ARFontSansRegular];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (IBAction)buttonClicked:(id)sender
{
    NSUInteger index = [picker selectedRowInComponent:0];
    NSDictionary *partner = _partners[index];
    if (_callback) {
        _callback(partner);
    }
}

#pragma mark UIPickerView data source
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [_partners count];
}

#pragma mark UIPickerView delegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _partners[row][@"name"];
}

@end
