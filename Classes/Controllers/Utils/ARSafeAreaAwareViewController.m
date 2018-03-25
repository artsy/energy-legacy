#import "ARSafeAreaAwareViewController.h"
#import <FLKAutoLayout/UIView+FLKAutoLayout.h>

@implementation ARSafeAreaAwareViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIView *safeView =  [[UIView alloc] init];
    safeView.backgroundColor = [UIColor blackColor];
    safeView.translatesAutoresizingMaskIntoConstraints = NO;

    _safeView = safeView;

    [self.view addSubview:safeView];

    if (@available(iOS 11, *)) {
        UILayoutGuide *guide = self.view.safeAreaLayoutGuide;
        [safeView.leadingAnchor constraintEqualToAnchor:guide.leadingAnchor].active = YES;
        [safeView.trailingAnchor constraintEqualToAnchor:guide.trailingAnchor].active = YES;
        [safeView.topAnchor constraintEqualToAnchor:guide.topAnchor].active = YES;
        [safeView.bottomAnchor constraintEqualToAnchor:guide.bottomAnchor].active = YES;
    } else {
        [self.safeView alignToView:self.view];
    }
}

@end
