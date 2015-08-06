#import "ARPartnerMetadataSync.h"

@interface ARCMSStatusMonitor : NSObject

- (void)checkCMSForUpdates:(void (^)(BOOL))completion;

-(instancetype)initWithContext:(NSManagedObjectContext *)context;

@property (nonatomic, strong, readwrite) ARPartnerMetadataSync *sync;

@end
