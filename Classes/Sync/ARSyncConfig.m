#import "ARSyncConfig.h"


@implementation ARSyncConfig

- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext *)context
                                    defaults:(NSUserDefaults *)defaults
                                     deleter:(ARSyncDeleter *)deleter
{
    self = [super init];
    if (!self) return nil;

    _managedObjectContext = context;
    _defaults = defaults;
    _deleter = deleter;

    return self;
}

@end
