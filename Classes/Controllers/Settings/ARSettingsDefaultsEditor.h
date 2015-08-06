#import <UIKit/UIKit.h>
#import "ARSettingsBaseViewController.h"


@interface ARSettingsDefaultsEditor : ARSettingsBaseViewController {
    IBOutlet UIButton *cancelButton;
    IBOutlet UIButton *saveButton;
}

@property (nonatomic) IBOutlet UITextView *textView;
@property (nonatomic, copy) NSString *defaultsAddress;

- (IBAction)save:(id)sender;

- (IBAction)cancel:(id)sender;

@end
