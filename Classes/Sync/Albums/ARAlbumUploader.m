#import <AFNetworking/AFNetworking.h>

#import "ARAlbumArtworksDownloader.h"
#import "ARRouter.h"
#import "AlbumUpload.h"
#import "ARAlbumEditOperation.h"
#import "ARAlbumUploader.h"

@interface ARAlbumUploader()
@property (nonatomic, strong, readonly) NSManagedObjectContext *context;
@end

@implementation ARAlbumUploader

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
    completion([AlbumUpload findAllInContext:self.context]);
}

- (NSOperation *)operationTree:(DRBOperationTree *)node
            operationForObject:(AlbumUpload *)albumUpload
                  continuation:(void (^)(id, void (^)()))continuation
                       failure:(void (^)())failure
{
    ARAlbumEditOperation *operation = [[ARAlbumEditOperation alloc] initWithAlbumUpload:albumUpload
                                                                            createModel:YES
                                                                                  toAdd:@[]
                                                                               toRemove:@[]];
    operation.onCompletion = ^(){
        continuation(nil, nil);
        
        [albumUpload deleteInContext:albumUpload.managedObjectContext];
    };

    return operation;
}

@end
