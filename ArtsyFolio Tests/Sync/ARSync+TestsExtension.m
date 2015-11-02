#import "ARSync+TestsExtension.h"
#import <Forgeries/ForgeriesUserDefaults.h>
#import <DRBOperationTree/DRBOperationTree.h>


@interface ARSync (RippingOpenARSyncSorryNotSorry)
- (NSArray<id<ARSyncPlugin>> *)createPlugins;
- (DRBOperationTree *)createSyncOperationTree;
@end


@interface DRBOperationTree (SorryNotSorry)
@property (nonatomic, strong) NSSet *children;
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

    - (BOOL)createsSyncStepInstanceOfClass : (Class) class
{
    DRBOperationTree *root = self.createSyncOperationTree;
    return [self tree:root containInstanceOfClass:class];
}

    - (BOOL)tree : (DRBOperationTree *)tree containInstanceOfClass : (Class) class
{
    NSArray *children = tree.children.allObjects;

    __block BOOL found = [children find:^BOOL(DRBOperationTree *tree) {
        return [tree.provider isKindOfClass:class];
    }] != nil;

    if (!found) {
        [children enumerateObjectsUsingBlock:^(DRBOperationTree *child, NSUInteger idx, BOOL *_Nonnull stop) {
            found = found || [self tree:child containInstanceOfClass:class];
            *stop = found;
        }];
    }

    return found;
}

@end
