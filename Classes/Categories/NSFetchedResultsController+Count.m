#import "NSFetchedResultsController+Count.h"


@implementation NSFetchedResultsController (Count)

// We don't really need the sections here but hey

- (NSInteger)count
{
    NSInteger total = 0;
    for (id<NSFetchedResultsSectionInfo> section in [self sections]) {
        total += [section numberOfObjects];
    }
    return total;
}

@end
