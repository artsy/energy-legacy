#import "ARFileUtils+FolioAdditions.h"

static NSManagedObjectModel *managedObjectModel = nil;
static NSManagedObjectContext *mainManagedObjectContext = nil;
static NSPersistentStoreCoordinator *persistentStoreCoordinator = nil;
static BOOL ARRunningUnitTests = NO;

static const NSString *ThreadContextKey = @"ThreadContextKey";


@implementation CoreDataManager

+ (void)initialize
{
    if (self == [CoreDataManager class]) {
        NSString *XCInjectBundle = [[[NSProcessInfo processInfo] environment] objectForKey:@"XCInjectBundle"];
        ARRunningUnitTests = [XCInjectBundle hasSuffix:@".xctest"];
    }
}

+ (NSManagedObjectContext *)mainManagedObjectContext
{
    if (ARRunningUnitTests) {
        @throw [NSException exceptionWithName:@"ARCoreDataError" reason:@"Nope - you should be using a stubbed context somewhere." userInfo:nil];
    }

    if (mainManagedObjectContext == nil) {
        NSLog(@"Storing data at %@", [ARFileUtils coreDataStorePath]);

        mainManagedObjectContext = [self newManagedObjectContext];
        [mainManagedObjectContext setStalenessInterval:60.0];
        [[NSNotificationCenter defaultCenter] addObserver:[CoreDataManager class]
                                                 selector:@selector(mergeChangesIntoMainContextForDidSaveNotification:)
                                                     name:NSManagedObjectContextDidSaveNotification
                                                   object:nil];
    }
    return mainManagedObjectContext;
}

+ (NSManagedObjectContext *)newManagedObjectContext
{
    if (ARRunningUnitTests) {
        @throw [NSException exceptionWithName:@"ARCoreDataError" reason:@"Nope - you should be using a stubbed context somewhere." userInfo:nil];
    }

    NSManagedObjectContext *context = nil;
    NSThread *thisThread = [NSThread currentThread];
    BOOL isMainThread = [thisThread isMainThread];
    if (!isMainThread) {
        context = [[thisThread threadDictionary] objectForKey:ThreadContextKey];
        if (context) return context;
    }

    NSPersistentStoreCoordinator *coordinator = [CoreDataManager persistentStoreCoordinator];
    if (coordinator != nil) {
        context = [[NSManagedObjectContext alloc] initWithConcurrencyType:isMainThread ? NSMainQueueConcurrencyType : NSPrivateQueueConcurrencyType];
        [context setPersistentStoreCoordinator:coordinator];
        [context setMergePolicy:NSMergeByPropertyObjectTrumpMergePolicy];
        [context setUndoManager:nil];
    }

    if (!isMainThread && context) {
        [[thisThread threadDictionary] setObject:context forKey:ThreadContextKey];
    }
    return context;
}


// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.

+ (NSManagedObjectModel *)managedObjectModel
{
    @autoreleasepool
    {
        if (managedObjectModel != nil) {
            return managedObjectModel;
        }

        @try {
            NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"ArtsyPartner" withExtension:@"momd"];
            managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
        }
        @catch (NSException *e) {
            NSLog(@"Failed to initialize managed object model: %@", e);
            managedObjectModel = nil;
        }
        if (!managedObjectModel) {
            @try {
                managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
            }
            @catch (NSException *e) {
                NSLog(@"Failed to initialize managed object mode (second attempt). Raising exception.");
                @throw e;
            }
        }

        return managedObjectModel;
    }
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */

+ (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }

    NSURL *storeURL = [NSURL fileURLWithPath:[ARFileUtils coreDataStorePath]];
    if (ARIsOSSBuild) {
        storeURL = [[NSBundle mainBundle] URLForResource:@"oss_stubbed_data" withExtension:@"sqlite"];
    }

    NSDictionary *options = @{ NSMigratePersistentStoresAutomaticallyOption : @(YES),
                               NSInferMappingModelAutomaticallyOption : @(YES) };

    NSError *error = nil;
    NSManagedObjectModel *model = [CoreDataManager managedObjectModel];
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];

    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                  configuration:nil
                                                            URL:storeURL
                                                        options:options
                                                          error:&error]) {
        persistentStoreCoordinator = nil;
        [CoreDataManager logCoreDataError:error];
    }

    return persistentStoreCoordinator;
}

+ (NSManagedObjectContext *)stubbedManagedObjectContext
{
    NSDictionary *options = @{ NSMigratePersistentStoresAutomaticallyOption : @(YES),
                               NSInferMappingModelAutomaticallyOption : @(YES) };

    NSError *error = nil;
    NSManagedObjectModel *model = [CoreDataManager managedObjectModel];
    NSPersistentStoreCoordinator *persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSInMemoryStoreType
                                                  configuration:nil
                                                            URL:nil
                                                        options:options
                                                          error:&error]) {
        persistentStoreCoordinator = nil;
        [CoreDataManager logCoreDataError:error];
    }

    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    context.persistentStoreCoordinator = persistentStoreCoordinator;
    return context;
}

+ (void)mergeChangesIntoMainContextForDidSaveNotification:(NSNotification *)notification
{
    BOOL isInTestingEnvironment = (NSClassFromString(@"XCTest") != nil);
    if (isInTestingEnvironment) return;

    if ([NSThread currentThread] != [NSThread mainThread]) {
        [[CoreDataManager class] performSelectorOnMainThread:@selector(mergeChangesIntoMainContextForDidSaveNotification:)
                                                  withObject:notification
                                               waitUntilDone:YES];
    }

    else {
        NSManagedObjectContext *context = [CoreDataManager mainManagedObjectContext];
        [context mergeChangesFromContextDidSaveNotification:notification];
    }
}

+ (void)logCoreDataError:(NSError *)error
{
    ARLog(@"Core Data Error: %@", [error userInfo]);
}

+ (void)saveMainContext
{
    NSError *error = nil;
    NSManagedObjectContext *context = [self mainManagedObjectContext];
    if (context != nil) {
        if ([context hasChanges] && ![context save:&error]) {
            /*
             Replace this implementation with code to handle the error appropriately.

             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        }
    }
}

#pragma mark -
#pragma mark Reset Methods

+ (void)resetCoreDataWithSuccess:(dispatch_block_t)success
                         failure:(void (^)(NSError *error))failure
{
    if (![NSThread isMainThread]) {
        return;
    }

    [CoreDataManager deleteCoreDataStoreWithSuccess:success failure:failure];
}

+ (void)deleteCoreDataStoreWithSuccess:(dispatch_block_t)success
                               failure:(void (^)(NSError *error))failure
{
    NSManagedObjectContext *mainManagedObjectContext = [self mainManagedObjectContext];
    NSPersistentStoreCoordinator *persistentStoreCoordinator = [mainManagedObjectContext persistentStoreCoordinator];
    NSPersistentStore *persistentStore = [[persistentStoreCoordinator persistentStores] lastObject];
    NSError *error = nil;

    // Clear managed objects from the main managed object context
    [mainManagedObjectContext lock];
    [mainManagedObjectContext reset];

    // Remove persistent store from coordinator
    NSURL *storeURL = [NSURL fileURLWithPath:[ARFileUtils coreDataStorePath]];
    [persistentStoreCoordinator removePersistentStore:persistentStore error:&error];
    if (error) {
        [mainManagedObjectContext unlock];

        if (failure) {
            failure(error);
        }
        return;
    }

    // Delete current persistent store from disk
    [[NSFileManager defaultManager] removeItemAtURL:storeURL error:&error];
    if (error) {
        [mainManagedObjectContext unlock];

        if (failure) {
            failure(error);
        }
        return;
    }

    [mainManagedObjectContext unlock];

    if (success) {
        success();
    }
}

@end
