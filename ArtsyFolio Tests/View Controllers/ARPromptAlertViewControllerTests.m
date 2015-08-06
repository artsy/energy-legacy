#import "ARPromptAlertViewController.h"
#import "ARBaseViewController+TransparentModals.h"

SpecBegin(ARPromptAlertViewController);

__block ARPromptAlertViewController *sut;

before(^{
    sut = [[ARPromptAlertViewController alloc] init];
});

itHasSnapshotsForDevices(@"default state", ^{
    UIViewController *emptyController = [[UIViewController alloc] init];
    [emptyController presentTransparentModalViewController:sut animated:NO withAlpha:0.3f];
    return emptyController;
});

SpecEnd
