#import <DRBOperationTree/DRBOperationTree.h>


@interface ARUserMetadataDownloader : NSObject <DRBOperationProvider>

- (instancetype)initWithContext:(NSManagedObjectContext *)context;

@end
