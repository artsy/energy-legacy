#import "ARSyncLogger.h"
#import "SyncLog.h"


@interface ARSyncLogger ()

@property (nonatomic, assign) NSInteger initialArtworkCount;

@end


@implementation ARSyncLogger

- (void)syncDidStart:(ARSync *)sync
{
    self.initialArtworkCount = [Artwork countInContext:sync.config.managedObjectContext error:nil];
}

- (void)syncDidFinish:(ARSync *)sync
{
    NSManagedObjectContext *context = sync.config.managedObjectContext;
    SyncLog *newLog = [SyncLog createInContext:self.managedObjectContext];
    newLog.dateStarted = NSDate.date;
    newLog.artworkDelta = self.initialArtworkCount - [Artwork countInContext:context error:nil];
}

@end
