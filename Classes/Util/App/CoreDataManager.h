#import <Foundation/Foundation.h>


@interface CoreDataManager : NSObject

+ (NSManagedObjectContext *)mainManagedObjectContext;

+ (NSManagedObjectContext *)newManagedObjectContext;

+ (NSPersistentStoreCoordinator *)persistentStoreCoordinator;

+ (NSManagedObjectModel *)managedObjectModel;

/// Returns an in-memory managed object context with default data
+ (NSManagedObjectContext *)stubbedManagedObjectContext;

+ (void)mergeChangesIntoMainContextForDidSaveNotification:(NSNotification *)notification;

+ (void)saveMainContext;

+ (void)logCoreDataError:(NSError *)error;

///  Deletes the core data store and create new instance
+ (void)resetCoreDataWithSuccess:(dispatch_block_t)success
                         failure:(void (^)(NSError *error))failure;

@end
