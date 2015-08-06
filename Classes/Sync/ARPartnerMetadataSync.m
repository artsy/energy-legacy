#import "ARPartnerMetadataSync.h"
#import <DRBOperationTree/DRBOperationTree.h>
#import "ARPartnerFullMetadataDownloader.h"

@interface ARPartnerMetadataSync ()

@property (readwrite, nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (readwrite, nonatomic, strong) NSUserDefaults *defaults;

@end

@implementation ARPartnerMetadataSync

-(instancetype)initWithContext:(NSManagedObjectContext *)context
{
    self = [super init];
    if (!self) { return nil; }
    
    _managedObjectContext = context;
    
    return self;
}

#pragma mark -
#pragma mark syncing

- (void)performPartnerMetadataSync:(void (^)())completion
{
    NSString *partnerSlug = [self.defaults stringForKey:ARPartnerID];
    DRBOperationTree *rootNode = [self createPartnerMetadataTree];
    
    if (partnerSlug) {
        [rootNode enqueueOperationsForObject:partnerSlug completion:^{
            [self save];
            completion();
        }];
    }

}

- (DRBOperationTree *)createPartnerMetadataTree
{
    NSManagedObjectContext *context = self.managedObjectContext;
    NSOperationQueue *requestOperationQueue = [[NSOperationQueue alloc] init];
    
    DRBOperationTree *partnerNode = [[DRBOperationTree alloc] initWithOperationQueue:requestOperationQueue];
    partnerNode.provider = [[ARPartnerFullMetadataDownloader alloc] initWithContext:context];
    
    return partnerNode;
}

- (void)save
{
    Partner *currentPartner = [Partner currentPartnerInContext:self.managedObjectContext];
    [currentPartner saveManagedObjectContextLoggingErrors];
}



#pragma mark -
#pragma mark dependency injection

- (NSManagedObjectContext *)managedObjectContext
{
    return _managedObjectContext ?: [CoreDataManager mainManagedObjectContext];
}

- (NSUserDefaults *)defaults
{
    return _defaults ?: [NSUserDefaults standardUserDefaults];
}


@end
