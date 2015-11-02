#import "ARSyncLogger.h"
#import "SyncLog.h"
#import "UIDevice+SpaceStats.h"


@interface ARSyncLogger ()

@property (nonatomic, assign) NSInteger initialArtworkCount;
@property (nonatomic, assign) NSInteger initialAlbumCount;
@property (nonatomic, assign) NSInteger initialShowCount;

@property (nonatomic, strong) SyncLog *log;
@end


@implementation ARSyncLogger

- (void)syncDidStart:(ARSync *)sync
{
    NSManagedObjectContext *context = sync.config.managedObjectContext;

    self.log = [SyncLog createInContext:context];

    self.log.dateStarted = [NSDate date];

    self.initialArtworkCount = [Artwork countInContext:context error:nil];
    self.initialAlbumCount = [Album countInContext:context error:nil];
    self.initialShowCount = [Show countInContext:context error:nil];
}

- (void)syncDidFinish:(ARSync *)sync
{
    NSManagedObjectContext *context = sync.config.managedObjectContext;

    self.log.timeToCompletion = @([[NSDate date] timeIntervalSinceDate:self.log.dateStarted]);

    self.log.artworkDelta = @([Artwork countInContext:context error:nil] - self.initialArtworkCount);
    self.log.albumsDelta = @([Album countInContext:context error:nil] - self.initialAlbumCount);
    self.log.showDelta = @([Show countInContext:context error:nil] - self.initialShowCount);
}


@end
