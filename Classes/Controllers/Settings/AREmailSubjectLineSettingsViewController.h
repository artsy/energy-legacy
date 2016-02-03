#import "AREmailSettingsViewModel.h"


@interface AREmailSubjectLineSettingsViewController : UIViewController <UITextViewDelegate>

- (void)setupWithSubjectType:(AREmailSubjectType)subjectType viewModel:(AREmailSettingsViewModel *)viewModel;

@end
