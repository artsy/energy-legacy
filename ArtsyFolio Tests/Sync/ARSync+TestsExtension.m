#import "ARSync+TestsExtension.h"
#import <Forgeries/ForgeriesUserDefaults.h>


@interface ARSync (RippingOpenARSyncSorryNotSorry)
- (NSArray<id<ARSyncPlugin>> *)createPlugins;
@end


@implementation ARSync (Tests)

+ (instancetype)syncForTesting
{
    NSManagedObjectContext *context = [CoreDataManager stubbedManagedObjectContext];
    NSUserDefaults *defaults = (id)[ForgeriesUserDefaults defaults:@{}];
    return [self syncForTesting:context defaults:defaults];
}

+ (instancetype)syncForTesting:(NSManagedObjectContext *)context
{
    NSUserDefaults *defaults = (id)[ForgeriesUserDefaults defaults:@{}];
    return [self syncForTesting:context defaults:defaults];
}

+ (instancetype)syncForTesting:(NSManagedObjectContext *)context defaults:(NSUserDefaults *)defaults
{
    ARSyncDeleter *deleter = [[ARSyncDeleter alloc] init];

    ARSyncConfig *config = [[ARSyncConfig alloc] initWithManagedObjectContext:context defaults:defaults deleter:deleter];
    ARSync *sync = [[ARSync alloc] init];
    sync.config = config;
    return sync;
}


- (BOOL)createsPluginInstanceOfClass:(Class) class
{
    return [self.createPlugins find:^BOOL(id object) {
        return [object isKindOfClass:class];
    }] != nil;
}

@end
