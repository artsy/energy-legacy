#import "ARCMSStatusMonitor.h"
#import <DRBOperationTree/DRBOperationTree.h>
#import "ARPartnerFullMetadataDownloader.h"

@interface ARCMSStatusMonitor ()

@property (readwrite, nonatomic, strong) NSUserDefaults *defaults;
@property (readwrite, nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end

@implementation ARCMSStatusMonitor

-(instancetype)initWithContext:(NSManagedObjectContext *)context
{
    self = [super init];
    if (!self) { return nil; }
    
    _managedObjectContext = context;
    
    return self;
}

- (void)checkCMSForUpdates:(void (^)(BOOL))completion
{
    [self.sync performPartnerMetadataSync:^{
        [[self defaults] setBool:self.cmsLoginSinceLastSync forKey:ARRecommendSync];
        completion([self cmsLoginSinceLastSync]);
    }];
}

- (BOOL)cmsLoginSinceLastSync
{
    Partner *currentPartner = [Partner currentPartnerInContext:self.managedObjectContext];
    NSDate *lastCMSLoginDate = currentPartner.lastCMSLoginDate;
    if (lastCMSLoginDate) {
        NSDate *lastSyncDate = [self.defaults objectForKey:ARLastSyncDate];
        return [lastSyncDate laterDate:lastCMSLoginDate] == lastCMSLoginDate;
    } else {
        return NO;
    }
}

#pragma mark -
#pragma mark dependency injection

- (ARPartnerMetadataSync *)sync
{
    return _sync ?: [[ARPartnerMetadataSync alloc] initWithContext:self.managedObjectContext];
}

- (NSUserDefaults *)defaults
{
    return _defaults ?: [NSUserDefaults standardUserDefaults];
}

- (NSManagedObjectContext *)managedObjectContext
{
    return _managedObjectContext ?: [CoreDataManager mainManagedObjectContext];
}

@end
