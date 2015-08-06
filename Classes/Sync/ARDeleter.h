/// Holds all the slugs for objects that should be deleted
/// in a sync, you mark an object for deletion and unmark it
/// later if found.


@interface ARDeleter : NSObject

/// Create an ARDeleter in a managed object context
- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext *)context;

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

/// Managed Object Context to run deletions from
@property (nonatomic, strong, readonly) NSManagedObjectContext *context;

@end
