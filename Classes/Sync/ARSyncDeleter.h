#import "ARSync.h"

@class ARSyncBackgroundedCheck;

/// Holds all the slugs for objects that should be deleted
/// in a sync, you mark an object for deletion and unmark it
/// later if found.


@interface ARSyncDeleter : NSObject <ARSyncPlugin>

@property (nonatomic, readwrite, strong) ARSyncBackgroundedCheck *backgroundCheck;

/// Loop though all instances of a class within the deleter's context
/// marking them for deletion
- (void)markAllObjectsInClassForDeletion:(Class)klass;

/// Mark an individual item for deletion
- (void)markObjectForDeletion:(NSManagedObject *)object;

/// Remove an individual item from later deletion
- (void)unmarkObjectForDeletion:(NSManagedObject *)object;

/// Remove all marked objects
- (void)deleteObjects;

/// All current marked objects
- (NSSet *)markedObjects;

@end
