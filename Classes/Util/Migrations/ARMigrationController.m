#import "ARMigrationController.h"
#import "ARFileUtils+FolioAdditions.h"
#import "ARBaseViewController+TransparentModals.h"
#import "AlbumEdit.h"
#import "ARSync.h"

@implementation ARMigrationController

+ (void)performMigrationsInContext:(NSManagedObjectContext *)context
{
    [self moveCoreDataStackIfNeeded];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //    NSString *oldMigrationVersion = [defaults stringForKey:ARAppSyncVersion];
    //    CGFloat pastVersion = [oldMigrationVersion floatValue];

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"


    /// Converts pre 2.5.1 versions of Folio to support multiple artists
    BOOL shouldSwitchArtistToArtists = [defaults boolForKey:@"ARHasSwitchedArtistToArtists"] == NO;
    if (shouldSwitchArtistToArtists) {
        // Migrate any singular artist into artists
        for (Artwork *artwork in [Artwork findAllInContext:context]) {
            artwork.artists = [NSSet setWithObject:artwork.artist];
        }

        [defaults setBool:YES forKey:@"ARHasSwitchedArtistToArtists"];
    }

#pragma clang diagnostic pop


    /// Sets an artistOrderingKey to handle multiple Artists
    BOOL shouldSetTheArtistOrderingKey = [defaults boolForKey:@"ARHasAddedArtistOrderingKey"] == NO;
    if (shouldSetTheArtistOrderingKey) {
        // Migrate any singular artist into artists
        for (Artwork *artwork in [Artwork findAllInContext:context]) {
            artwork.artistOrderingKey = [artwork artistOrderingKey];
        }

        [defaults setBool:YES forKey:@"ARHasAddedArtistOrderingKey"];
    }


    // I changed a BOOL which was incorrectly being set to YES all the time, now
    // we have a migration to switch them all to NO, and the next sync will deal with
    // the correct setup

    BOOL shouldSwitchAllImageProcessing = [defaults boolForKey:@"ARHasSwitchedAllImagesProcessing"] == NO;
    if (shouldSwitchAllImageProcessing) {
        for (Image *image in [Image findAllInContext:context]) {
            image.processing = @(NO);
        }
        [context save:nil];
        [defaults setBool:YES forKey:@"ARHasSwitchedAllImagesProcessing"];
    }

    // We've relied on albums with 0 artworks = deleted for years, now that we have
    // album sync, I'm going to make the explicit ( because we need to trigger remote deletions)

    BOOL shouldDeleteEmptyAlbums = [defaults boolForKey:@"ARHasDeletedEmptyAlbums"] == NO;
    if (shouldDeleteEmptyAlbums) {
        for (Album *album in [Album editableAlbumsByLastUpdateInContext:context]) {
            if (album.artworks.count == 0) {
                [album deleteInContext:context];
            }
        }

        [defaults setBool:YES forKey:@"ARHasDeletedEmptyAlbums"];
    }

    [defaults synchronize];
}

+ (void)moveCoreDataStackIfNeeded
{
    NSString *oldPath = [ARFileUtils pre15CoreDataStorePath];
    NSString *newPath = [ARFileUtils coreDataStorePath];
    NSError *error = nil;

    BOOL oldCoreDataStoreExists = [ARFileUtils pre15CoreDataStoreExists];
    if (oldCoreDataStoreExists) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager copyItemAtPath:oldPath toPath:newPath error:&error];
        if (error) {
            NSLog(@"Error copying files in performCoreDataMigrations: %@ ", error);
            return;
        }

        [fileManager removeItemAtPath:oldPath error:&error];
        if (error) {
            NSLog(@"Error removing old core data sqlite file:%@ ", error);
        }
    }
}

+ (void)migrateOnAppAlbumsToGravity:(UIViewController *)viewControllerToPresentOn context:(NSManagedObjectContext *)context sync:(ARSync *)sync
{
    NSString *migratedToCloudKey = @"ARHasMigratedAlbums";
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    BOOL shouldOfferToMigrateAlbums = [defaults boolForKey:migratedToCloudKey] == NO;
    if (shouldOfferToMigrateAlbums) {
        [defaults setBool:YES forKey:migratedToCloudKey];

        NSInteger albumCount = [Album editableAlbumsByLastUpdateInContext:context].count;
        if (albumCount == 0) {
            // NOOP, bubt also will happen when you first launch the app
            return;
        }

        NSString *messaging = NSStringWithFormat(@"Folio albums are now stored in the cloud. Sync %@ albums online?", @(albumCount));
        [viewControllerToPresentOn presentTransparentAlertWithText: messaging withOKAs:@"MIGRATE" andCancelAs:@"DELETE" completion:^(enum ARModalAlertViewControllerStatus completion) {
            switch (completion) {
                case ARModalAlertOK: {
                    NSArray *albumsToUpload = [Album editableAlbumsByLastUpdateInContext:context];
                    // Make an AlbumEdit for every album
                    for (Album *album in albumsToUpload) {
                        AlbumEdit *uploadRequest = [AlbumEdit objectInContext:context];
                        uploadRequest.album = album;
                        uploadRequest.albumWasCreated = @YES;
                        uploadRequest.createdAt = album.createdAt;
                        uploadRequest.addedArtworks = album.artworks;
                        [uploadRequest saveManagedObjectContextLoggingErrors];

                        // These will get re-created from the sync
                        [album deleteInContext:context];
                    }

                    // Makes the Album screen say "Syncing your albums"
                    [defaults setBool:YES forKey:ARFinishedFirstSync];
                    break;
                }

                // I know this is a bit drastic, but there's not really much choice wiithout a lot more work,
                // and this feature has already taken about 5 years to get built.
                case ARModalAlertCancel: {
                    NSArray *albumsToRemove = [Album editableAlbumsByLastUpdateInContext:context];
                    // :wave:
                    for (Album *album in albumsToRemove) {
                        [album deleteInContext:context];
                    }
                    break;
                }
            }

            [sync sync];
            [viewControllerToPresentOn dismissTransparentModalViewControllerAnimated:YES];
        }];
    }
}

@end
