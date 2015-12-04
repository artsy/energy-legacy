#import "ARLabSettingsEmailViewModel.h"


@interface ARLabSettingsEmailSubjectLinesViewController : UIViewController <UITextViewDelegate>

- (void)setupWithSubjectType:(AREmailSubjectType)subjectType viewModel:(ARLabSettingsEmailViewModel *)viewModel;

@end
