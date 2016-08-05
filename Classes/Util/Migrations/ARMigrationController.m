#import "ARMigrationController.h"
#import "ARFileUtils+FolioAdditions.h"


@implementation ARMigrationController

+ (void)performMigrationsInContext:(NSManagedObjectContext *)context
{
    [self moveCoreDataStackIfNeeded];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //    NSString *oldMigrationVersion = [defaults stringForKey:ARAppSyncVersion];
    //    CGFloat pastVersion = [oldMigrationVersion floatValue];

    /// Converts pre 2.5.1 versions of Folio to support multiple artists
    BOOL shouldSwitchArtistToArtists = [defaults boolForKey:@"ARHasSwitchedArtistToArtists"] == NO;
    if (shouldSwitchArtistToArtists) {
        // Migrate any singular artist into artists
        for (Artwork *artwork in [Artwork findAllInContext:context]) {
            artwork.artists = [NSSet setWithObject:artwork.artist];
        }

        [defaults setBool:YES forKey:@"ARHasSwitchedArtistToArtists"];
    }

    /// Sets an artistOrderingKey to handle multiple Artists
    BOOL shouldSetTheArtistOrderingKey = [defaults boolForKey:@"ARHasAddedArtistOrderingKey"] == NO;
    if (shouldSwitchArtistToArtists) {
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
        [defaults synchronize];
    }
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

@end
