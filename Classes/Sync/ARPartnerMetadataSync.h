@interface ARPartnerMetadataSync : NSObject

-(instancetype)initWithContext:(NSManagedObjectContext *)context;

/// Runs a sync for Partner model only
- (void)performPartnerMetadataSync:(void (^)())completion;

@end
