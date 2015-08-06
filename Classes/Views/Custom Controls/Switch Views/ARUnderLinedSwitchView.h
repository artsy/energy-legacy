#import "ARSwitchView.h"

enum ARSwitchViewStyle {
    ARSwitchViewStyleSansSerif,
    ARSwitchViewStyleSmallSansSerif,
    ARSwitchViewStyleSmallerSansSerif,
    ARSwitchViewStyleWhiteSmallSansSerif
};


@interface ARUnderLinedSwitchView : ARSwitchView

// Style properties
@property (nonatomic, assign) enum ARSwitchViewStyle style;

- (void)fadeInFromDisabledAnimated:(BOOL)animated;

@end
