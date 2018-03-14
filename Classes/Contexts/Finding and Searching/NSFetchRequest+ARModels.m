#import "NSFetchRequest+ARModels.h"
#import "AROptions.h"

// As more and more filtering options become available it makes sense to
// keep all of the places that need to react to them in one place.


@implementation NSFetchRequest (ARModels)

+ (instancetype)ar_allArtworksOfArtworkContainerWithSelfPredicate:(NSPredicate *)selfScopePredicate inContext:(NSManagedObjectContext *)context defaults:(NSUserDefaults *)defaults
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:NSStringFromClass(Artwork.class) inManagedObjectContext:context];
    request.predicate = [self compoundPredicateForScopedArtworksWithInitialPredicate:selfScopePredicate defaults:defaults];
    return request;
}

+ (instancetype)ar_allInstancesOfArtworkContainerClass:(Class)klass inContext:(NSManagedObjectContext *)context defaults:(NSUserDefaults *)defaults
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:NSStringFromClass(klass) inManagedObjectContext:context];
    request.predicate = [self compoundPredicateForArtworksWithDefaults:defaults];
    request.sortDescriptors = @[ [NSSortDescriptor sortDescriptorWithKey:@"orderingKey" ascending:YES] ];
    return request;
}

+ (NSPredicate *)compoundPredicateForScopedArtworksWithInitialPredicate:(NSPredicate *)scopePredicate defaults:(NSUserDefaults *)defaults
{
    NSMutableArray *predicates = [NSMutableArray array];
    if (scopePredicate) {
        [predicates addObject:scopePredicate];
    }

    if ([self hideUnpublishedWithDefaults:defaults]) {
        [predicates addObject:[NSPredicate predicateWithFormat:@"isPublished == %@", @(YES)]];
    }

    if ([self hideUnavailableWithDefaults:defaults]) {
        [predicates addObject:[NSPredicate predicateWithFormat:@"isAvailableForSale == %@", @(YES)]];
    }

    [predicates addObject:[NSPredicate predicateWithFormat:@"images.@count > 0"]];
    [predicates addObject:[NSPredicate predicateWithFormat:@"ANY images.processing == %@ ", @(NO)]];

    return [NSCompoundPredicate andPredicateWithSubpredicates:predicates];
}

+ (NSPredicate *)compoundPredicateForArtworksWithDefaults:(NSUserDefaults *)defaults
{
    NSMutableArray *predicates = [NSMutableArray array];

    if ([self hideUnpublishedWithDefaults:defaults]) {
        [predicates addObject:[NSPredicate predicateWithFormat:@"ANY artworks.isPublished == %@", @(YES)]];
    }

    if ([self hideUnavailableWithDefaults:defaults]) {
        [predicates addObject:[NSPredicate predicateWithFormat:@"ANY artworks.isAvailableForSale == %@", @(YES)]];
    }

    [predicates addObject:[NSPredicate predicateWithFormat:@"artworks.@count > 0"]];

    return [NSCompoundPredicate andPredicateWithSubpredicates:predicates];
}

+ (BOOL)hideUnpublishedWithDefaults:(NSUserDefaults *)defaults
{
    return [defaults boolForKey:ARPresentationModeOn] ? [defaults boolForKey:ARHideUnpublishedWorks] : NO;
}

+ (BOOL)hideUnavailableWithDefaults:(NSUserDefaults *)defaults
{
    return [defaults boolForKey:ARPresentationModeOn] ? [defaults boolForKey:ARHideWorksNotForSale] : NO;
}

@end
