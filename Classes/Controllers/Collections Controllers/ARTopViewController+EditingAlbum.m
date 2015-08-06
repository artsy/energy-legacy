#import "ARTopViewController+EditingAlbum.h"
#import "ARBaseViewController+TransparentModals.h"
#import "ARSearchViewController.h"


@implementation ARTopViewController (EditingAlbum)

- (void)registerForAlbumEditNotifications
{
    [self observeNotification:ARAlbumRemoveAlbumNotification globallyWithSelector:@selector(removeAlbumObject:)];
}

- (void)removeAlbumObject:(NSNotification *)notification
{
    if (self.transparentModalViewController) return;

    Album *album = [notification userInfo][ARAlbumItemKey];
    NSString *alertTitle = [NSString stringWithFormat:@"DELETE ALBUM \"%@\"?", [album.name uppercaseString]];

    [self presentTransparentAlertWithText:alertTitle withOKAs:@"DELETE" andCancelAs:@"CANCEL" completion:^(enum ARModalAlertViewControllerStatus status) {
        if (status == ARModalAlertOK) {
            [ARAnalytics event:ARDeleteAlbumEvent];

            [album deleteEntity];
            [CoreDataManager saveMainContext];
            [self reloadCurrentViewController];
            [[ARSearchViewController sharedController] reloadSearchResults];
        }

        [self dismissTransparentModalViewControllerAnimated:YES];
    }];
}

@end
