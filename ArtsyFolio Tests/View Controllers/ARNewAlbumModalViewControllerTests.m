#import "ARNewAlbumModalViewController.h"
#import "ARBaseViewController+TransparentModals.h"

SpecBegin(ARNewAlbumModalViewController);

__block ARNewAlbumModalViewController *sut;

before(^{
    sut = [[ARNewAlbumModalViewController alloc] init];
});

itHasSnapshotsForDevices(@"default state", ^{
    UIViewController *emptyController = [[UIViewController alloc] init];
    [emptyController presentTransparentModalViewController:sut animated:NO withAlpha:0.3f];
    return emptyController;
});

itHasSnapshotsForDevices(@"selected text", ^{
    UIViewController *emptyController = [[UIViewController alloc] init];
    [emptyController presentTransparentModalViewController:sut animated:NO withAlpha:0.3f];
    sut.inputTextField.text = @"Hello world";
    [sut textField:sut.inputTextField shouldChangeCharactersInRange:NSMakeRange(0, 0) replacementString:@""];
    
    return emptyController;
});

SpecEnd
