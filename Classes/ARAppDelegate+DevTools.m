#import "ARAppDelegate+DevTools.h"
#import "ARSwitchBoard.h"

// You can tell git to ignore changes to this file by running:
// git update-index --assume-unchanged /Classes/ARAppDelegate+DevTools.m

// Example:
// [ARSwitchBoard jumpToArtworkViewControllerWithArtworkName:@"Motion in ruby" inContext:[CoreDataManager mainManagedObjectContext]];


@implementation ARAppDelegate (DevTools)

- (void)appHasBeenInjected:(NSNotification *)notification
{
    UINavigationController *navigationController = (id)self.window.rootViewController;
    [navigationController popViewControllerAnimated:NO];
    [self performDeveloperExtras];
}

- (void)performDeveloperExtras
{
    //    [ARSwitchBoard pushEditAlbumViewController:album];
}

@end
