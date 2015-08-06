#import "ARFeedTranslator.h"

static BOOL ARShouldParseJSON = YES;


@implementation ARFeedTranslator

+ (void)shouldParseJSON:(BOOL)shouldParseJSON
{
    ARShouldParseJSON = shouldParseJSON;
}

+ (NSArray *)backgroundAddOrUpdateObjects:(NSArray *)objects withClass:(Class) class inContext:(NSManagedObjectContext *)context saving:(BOOL)shouldSave completion:(void (^)(NSArray *objects))completion
{
    NSParameterAssert(entityName);

    NSString *entityName = NSStringFromClass(class);
    __block NSMutableDictionary *existingObjects;

    void (^jsonParsingBlock)(void) = ^() {
        NSMutableArray *objectIds = [[objects map:^id(NSDictionary *objectDict) {
            return [class folioSlug:objectDict];
        }] mutableCopy];

        existingObjects = [[self objectsIndexedByIdFromIds:objectIds withEntityName:entityName inContext:context] mutableCopy];

        [objects each:^(NSDictionary *objectDict) {
            NSString *objectId = [class folioSlug:objectDict];

            if (objectId == nil) {
                [ARAnalytics event:@"Error: Got an entity with no ID" withProperties:@{ @"Entity" : entityName, @"Data" : objectDict }];
                return;
            }

            [objectIds addObject:objectId];

            ARManagedObject *object = existingObjects[objectId];
            if (!object) {
                object = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:context];
                existingObjects[objectId] = object;
                object.slug = objectId;
            }

            [object updateWithDictionary:objectDict];
        }];

        if (shouldSave) {
            [self saveContextLoggingErrors:context];
        }

        if (completion) completion(existingObjects.allValues);
    };

    if (completion && ARShouldParseJSON) {
        @synchronized(context)
        {
            [context performBlock:jsonParsingBlock];
        }
        return nil;

    } else {
        jsonParsingBlock();
        return [existingObjects allValues];
    }
}

    + (NSArray *)addOrUpdateObjects : (NSArray *)objects withEntityName : (NSString *)entityName inContext : (NSManagedObjectContext *)context saving : (BOOL)shouldSave;
{
    return [self backgroundAddOrUpdateObjects:objects withClass:NSClassFromString(entityName) inContext:context saving:shouldSave completion:nil];
}

+ (NSManagedObject *)addOrUpdateObject:(NSDictionary *)dictionary withEntityName:(NSString *)entityName inContext:(NSManagedObjectContext *)context saving:(BOOL)shouldSave;
{
    return [self backgroundAddOrUpdateObjects:@[ dictionary ] withClass:NSClassFromString(entityName) inContext:context saving:shouldSave completion:nil].firstObject;
}

+ (NSDictionary *)objectsIndexedByIdFromIds:(NSArray *)objectIDs withEntityName:(NSString *)entityName inContext:(NSManagedObjectContext *)context
{
    NSParameterAssert(entityName);

    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
    request.entity = entity;
    request.predicate = [NSPredicate predicateWithFormat:@"slug IN %@", objectIDs];

    NSDictionary *immutableResult = nil;
    NSError *error = nil;

    NSArray *fetchedObjects = [context executeFetchRequest:request error:&error];
    if (fetchedObjects == nil) {
        NSLog(@"Failed to fetch objects from database in %@: %@", NSStringFromSelector(_cmd), [error localizedDescription]);
    } else {
        // Index the resulting objects by their ID for faster lookup
        NSMutableDictionary *existingImages = [[NSMutableDictionary alloc] initWithCapacity:fetchedObjects.count];
        for (ARManagedObject *object in fetchedObjects) {
            if ([object.slug length]) {
                existingImages[object.slug] = object;
            }
        }

        immutableResult = [[NSDictionary alloc] initWithDictionary:existingImages];
    }

    return immutableResult;
}

+ (void)saveContextLoggingErrors:(NSManagedObjectContext *)context
{
    NSError *error = nil;
    if (![context save:&error] && error) {
        NSArray *detailedErrors = [error userInfo][NSDetailedErrorsKey];

        if (detailedErrors != nil && [detailedErrors count] > 0) {
            for (NSError *detailedError in detailedErrors) {
                [ARAnalytics event:@"Error: Failed to save to data store" withProperties:@{ @"error" : detailedError.userInfo }];
            }
        } else {
            [ARAnalytics event:@"Error: Failed to save to data store" withProperties:@{ @"error" : error.localizedDescription }];
        }
    }
}

@end
