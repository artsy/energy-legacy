#import <CoreData/CoreData.h>


@interface NSFetchRequest (ARModelDebugging)

+ (void)debug_countAllInstancesOfArtworkContainerClass:(Class)klass inContext:(NSManagedObjectContext *)context defaults:(NSUserDefaults *)defaults;

@end
