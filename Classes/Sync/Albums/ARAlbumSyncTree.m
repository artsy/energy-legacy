#import "ARSyncOperations.h"
#import "ARAlbumSyncTree.h"
#import "ARSyncConfig.h"


@implementation ARAlbumSyncTree

+ (void)appendAlbumOperationTree:(ARSyncConfig *)config toNode:(DRBOperationTree *)rootNode operations:(NSMutableArray *)operationQueues;
{
    NSManagedObjectContext *context = config.managedObjectContext;

    // Concuurrency of 1? Well, 2 reasons: 1, this uses sentinels to indicate it's time to progress
    // down this tree (order of these matters). 2 we are potentially making many, in-order edits to an album. This way they happen sequentially.
    NSOperationQueue *requestOperationQueue = [[NSOperationQueue alloc] init];
    requestOperationQueue.maxConcurrentOperationCount = 1;
    [operationQueues addObject:requestOperationQueue];

    // Writes
    DRBOperationTree *albumUpdateNode = [[DRBOperationTree alloc] initWithOperationQueue:requestOperationQueue];
    DRBOperationTree *albumDeletionNode = [[DRBOperationTree alloc] initWithOperationQueue:requestOperationQueue];
    // Reads
    DRBOperationTree *albumsNode = [[DRBOperationTree alloc] initWithOperationQueue:requestOperationQueue];
    DRBOperationTree *albumArtworksNode = [[DRBOperationTree alloc] initWithOperationQueue:requestOperationQueue];

    albumUpdateNode.provider = [[ARAlbumChangeUploader alloc] initWithContext:context];
    albumDeletionNode.provider = [[ARAlbumDeleter alloc] initWithContext:context];

    albumsNode.provider = [[ARAlbumDownloader alloc] initWithContext:context deleter:config.deleter];
    albumArtworksNode.provider = [[ARAlbumArtworksDownloader alloc] init];

    // update -> deletes -> download albums -> album artworks
    //                                      -> album artworks
    //                                      -> album artworks
    //                                      -> ...

    [rootNode addChild:albumUpdateNode];
    [albumUpdateNode addChild:albumDeletionNode];

    [albumUpdateNode addChild:albumsNode];
    [albumsNode addChild:albumArtworksNode];
}

@end
