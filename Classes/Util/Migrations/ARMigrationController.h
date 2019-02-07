
/// Handles migrating between different versions of the Core Data model
/// which is normally forwards compatible and you dont need to do work
/// but sometimes it's not, and this gives you hooks for that.
///
/// See: http://artsy.github.io/blog/2014/06/11/testing-core-data-migrations/
@interface ARMigrationController : NSObject

+ (void)performMigrationsInContext:(NSManagedObjectContext *)context;

@end
