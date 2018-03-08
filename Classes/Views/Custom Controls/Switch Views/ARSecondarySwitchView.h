#import "ARSwitchView.h"


@interface ARSecondarySwitchView : ARSwitchView

@property (readwrite, nonatomic) BOOL leftAlign;
@property (readwrite, strong, nonatomic) UIView *rightSupplementaryView;

@end
