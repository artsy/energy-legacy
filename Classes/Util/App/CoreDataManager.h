#import <Foundation/Foundation.h>

/// The Core Data Singleton - used to generate per-thread copies of our
/// managed object contexts as well as keeping all the related objects in
/// a single place.
@interface CoreDataManager : NSObject

/// For main thread work
+ (NSManagedObjectContext *)mainManagedObjectContext;

/// For your new thread
+ (NSManagedObjectContext *)newManagedObjectContext;

/// Singleton because it can operate across threads
+ (NSPersistentStoreCoordinator *)persistentStoreCoordinator;

/// Singleton because it can operate across threads, represents the data mode version
+ (NSManagedObjectModel *)managedObjectModel;

/// Returns an in-memory managed object context with default data - specifically useful
/// for writing tests.
+ (NSManagedObjectContext *)stubbedManagedObjectContext;

/// Saves the state of the main MOC
+ (void)saveMainContext;

///  Deletes the core data store and create new instance, used in logging out
+ (void)resetCoreDataWithSuccess:(dispatch_block_t)success
                         failure:(void (^)(NSError *error))failure;

@end
