#import "_Location.h"
#import "ARManagedObject.h"


@interface Location : _Location <ARArtworkContainer, ARGridViewItem>

@property (strong, nonatomic) NSSet *artworkSlugs;

/// Gets all the Location objects
+ (NSFetchRequest *)allLocationsFetchRequestInContext:(NSManagedObjectContext *)context defaults:(NSUserDefaults *)defaults;

@end
