#import "ARTopViewController+EditingAlbum.h"
#import "ARBaseViewController+TransparentModals.h"
#import "ARSearchViewController.h"
#import "AlbumDelete.h"


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

            AlbumDelete *remoteDelete = [AlbumDelete objectInContext:album.managedObjectContext];
            remoteDelete.albumID = album.publicSlug;

            [album deleteEntity];
            [remoteDelete saveManagedObjectContextLoggingErrors];

            [self reloadCurrentViewController];
            [[ARSearchViewController sharedController] reloadSearchResults];
        }

        [self dismissTransparentModalViewControllerAnimated:YES];
    }];
}

@end
