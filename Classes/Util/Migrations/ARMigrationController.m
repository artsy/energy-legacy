#import "ARMigrationController.h"
#import "ARFileUtils+FolioAdditions.h"


@implementation ARMigrationController

+ (void)performMigrationsInContext:(NSManagedObjectContext *)context
{
    [self moveCoreDataStackIfNeeded];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *oldMigrationVersion = [defaults stringForKey:ARAppSyncVersion];
    CGFloat pastVersion = [oldMigrationVersion floatValue];

    if (pastVersion && pastVersion < 1.39) {
        ARSyncLog(@"Migrating!");

        // perform migration steps (or just have users re-install now the sync is faster
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
