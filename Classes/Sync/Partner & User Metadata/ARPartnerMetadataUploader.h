#import <DRBOperationTree/DRBOperationTree.h>


@interface ARPartnerMetadataUploader : NSObject <DRBOperationProvider>

- (instancetype)initWithContext:(NSManagedObjectContext *)context;

@end
