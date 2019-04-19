#import <AFNetworking/AFNetworking.h>

#import "ARAlbumArtworksDownloader.h"
#import "ARRouter.h"
#import "AlbumEdit.h"
#import "ARAlbumEditOperation.h"
#import "ARAlbumChangeUploader.h"


@interface ARAlbumChangeUploader ()
@property (nonatomic, strong, readonly) NSManagedObjectContext *context;
@end


@implementation ARAlbumChangeUploader

- (instancetype)initWithContext:(NSManagedObjectContext *)context
{
    self = [super init];
    if (!self) {
        return nil;
    }

    _context = context;

    return self;
}

- (void)operationTree:(DRBOperationTree *)tree objectsForObject:(NSString *)partnerID completion:(void (^)(NSArray *))completion
{
    NSFetchRequest *allEditsWithAlbumsFetch = [[NSFetchRequest alloc] init];
    allEditsWithAlbumsFetch.entity = [NSEntityDescription entityForName:@"AlbumEdit" inManagedObjectContext:self.context];
    allEditsWithAlbumsFetch.predicate = [NSPredicate predicateWithFormat:@"album != nil"];
    allEditsWithAlbumsFetch.sortDescriptors = @[ [NSSortDescriptor sortDescriptorWithKey:@"createdAt" ascending:YES] ];

    NSArray *albums = [self.context executeFetchRequest:allEditsWithAlbumsFetch error:nil];
    NSArray *albumsPlusEndingSentinel = [albums arrayByAddingObject:[NSNull null]];
    completion(albumsPlusEndingSentinel);
}

- (NSOperation *)operationTree:(DRBOperationTree *)node
            operationForObject:(AlbumEdit *)albumUpload
                  continuation:(void (^)(id, void (^)()))continuation
                       failure:(void (^)())failure
{
    if ([albumUpload isEqual:[NSNull null]]) {
        NSBlockOperation *noopOperation = [[NSBlockOperation alloc] init];

        noopOperation.completionBlock = ^{
            continuation([NSNull null], nil);
        };

        return noopOperation;
    } else {
        ARAlbumEditOperation *operation = [[ARAlbumEditOperation alloc] initWithAlbum:albumUpload.album createModel:albumUpload.albumWasCreated.boolValue toAdd:albumUpload.addedArtworks toRemove:albumUpload.removedArtworks];

        operation.onCompletion = ^() {
            if (albumUpload.deleteAlbumAfterSync) {
                [albumUpload.album deleteInContext:albumUpload.managedObjectContext];
            }

            [albumUpload deleteInContext:albumUpload.managedObjectContext];
            continuation(nil, nil);
        };

        return operation;
    }
}

@end
