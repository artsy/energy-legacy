#import <DRBOperationTree/DRBOperationTree.h>

@class ARSyncDeleter;


@interface ARIDMapperDownloader : NSObject <DRBOperationProvider>

- (instancetype)initWithContext:(NSManagedObjectContext *)context deleter:(ARSyncDeleter *)deleter;

- (Class)classForRenderedObjects;

- (NSURLRequest *)urlRequestForIDsWithObject:(id)object;

- (NSURLRequest *)urlRequestForObjectWithID:(NSString *)objectID;

- (void)performWorkWithDownloadObject:(id)object;

@end
