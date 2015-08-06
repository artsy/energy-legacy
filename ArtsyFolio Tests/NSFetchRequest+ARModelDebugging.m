#import "NSFetchRequest+ARModelDebugging.h"
#import "NSFetchRequest+ARModels.h"
#import "ARDefaults.h"


@interface NSFetchRequest (PrivateStubs)
+ (NSPredicate *)compoundPredicateForArtworksWithDefaults:(NSUserDefaults *)defaults;
@end


@implementation NSFetchRequest (ARModelDebugging)

+ (void)debug_countAllInstancesOfArtworkContainerClass:(Class)klass inContext:(NSManagedObjectContext *)context defaults:(NSUserDefaults *)defaults
{
    NSFetchRequest *currentRequest = [self ar_allInstancesOfArtworkContainerClass:klass inContext:context defaults:defaults];
    NSArray *currentObjects = [context executeFetchRequest:currentRequest error:nil];

    // Just unpublished

    NSFetchRequest *unpublishedRequest = [[NSFetchRequest alloc] init];
    unpublishedRequest.entity = [NSEntityDescription entityForName:NSStringFromClass(klass) inManagedObjectContext:context];
    unpublishedRequest.predicate = [self compoundPredicateForArtworksWithDefaults:(id)[FakeUserDefaults defaults:@{
        ARHideUnpublishedWorks : @(YES)
    }]];
    NSArray *unpublishedObjects = [context executeFetchRequest:unpublishedRequest error:nil];

    // Available only

    NSFetchRequest *onlyAvailableRequest = [[NSFetchRequest alloc] init];
    onlyAvailableRequest.entity = [NSEntityDescription entityForName:NSStringFromClass(klass) inManagedObjectContext:context];
    onlyAvailableRequest.predicate = [self compoundPredicateForArtworksWithDefaults:(id)[FakeUserDefaults defaults:@{
        ARHideUnpublishedWorks : @(YES)
    }]];
    NSArray *onlyAvailableObjects = [context executeFetchRequest:onlyAvailableRequest error:nil];


    NSLog(@"    Current fetch request: (%i)", currentObjects.count);
    NSLog(@"Unpublished fetch request: (%i)", unpublishedObjects.count);
    NSLog(@"  Available fetch request: (%i)", onlyAvailableObjects.count);
}

@end
