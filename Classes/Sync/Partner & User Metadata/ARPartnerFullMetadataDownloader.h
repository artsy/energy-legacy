#import <DRBOperationTree/DRBOperationTree.h>


@interface ARPartnerFullMetadataDownloader : NSObject <DRBOperationProvider>
- (instancetype)initWithContext:(NSManagedObjectContext *)context;
@end
