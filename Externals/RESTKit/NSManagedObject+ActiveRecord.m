//
//  NSManagedObject+ActiveRecord.m
//
//  Adapted from https://github.com/magicalpanda/MagicalRecord
//  Created by Saul Mora on 11/15/09.
//  Copyright 2010 Magical Panda Software, LLC All rights reserved.
//
//  Created by Chad Podoski on 3/18/11.
//

#import <objc/runtime.h>
#import "NSManagedObject+ActiveRecord.h"

static NSUInteger const kActiveRecordDefaultBatchSize = 10;
static NSNumber *defaultBatchSize = nil;


@implementation NSManagedObject (ActiveRecord)

#pragma mark - RKManagedObject methods

// TODO: Not sure that we even need the objectStore...
+ (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    if ([[NSThread currentThread] isMainThread]) {
        context = [CoreDataManager mainManagedObjectContext];
    } else {
        context = [CoreDataManager newManagedObjectContext];
    }
    return context;
}

+ (NSEntityDescription *)ar_entity
{
    NSString *className = @(class_getName([self class]));
    return [NSEntityDescription entityForName:className inManagedObjectContext:[self managedObjectContext]];
}

+ (NSEntityDescription *)entityInContext:(NSManagedObjectContext *)context
{
    NSString *className = @(class_getName([self class]));
    return [NSEntityDescription entityForName:className inManagedObjectContext:context];
}

+ (NSFetchRequest *)fetchRequestInContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [self entityDescriptionInContext:context];
    [fetchRequest setEntity:entity];
    return fetchRequest;
}

+ (NSFetchRequest *)fetchRequest
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [self ar_entity];
    [fetchRequest setEntity:entity];
    return fetchRequest;
}

+ (NSArray *)objectsWithFetchRequest:(NSFetchRequest *)fetchRequest
{
    NSError *error = nil;
    NSArray *objects = [[self managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    if (objects == nil) {
        NSLog(@"Error: %@", [error localizedDescription]);
    }
    return objects;
}

+ (NSArray *)objectsWithFetchRequests:(NSArray *)fetchRequests
{
    NSMutableArray *mutableObjectArray = [[NSMutableArray alloc] init];
    for (NSFetchRequest *fetchRequest in fetchRequests) {
        [mutableObjectArray addObjectsFromArray:[self objectsWithFetchRequest:fetchRequest]];
    }
    NSArray *objects = [NSArray arrayWithArray:mutableObjectArray];
    return objects;
}

+ (id)objectWithFetchRequest:(NSFetchRequest *)fetchRequest
{
    [fetchRequest setFetchLimit:1];
    NSArray *objects = [self objectsWithFetchRequest:fetchRequest];
    if ([objects count] == 0) {
        return nil;
    } else {
        return objects[0];
    }
}

+ (NSArray *)objectsWithPredicate:(NSPredicate *)predicate
{
    NSFetchRequest *fetchRequest = [self fetchRequest];
    [fetchRequest setPredicate:predicate];
    return [self objectsWithFetchRequest:fetchRequest];
}

+ (id)objectWithPredicate:(NSPredicate *)predicate
{
    NSFetchRequest *fetchRequest = [self fetchRequest];
    [fetchRequest setPredicate:predicate];
    return [self objectWithFetchRequest:fetchRequest];
}

+ (NSUInteger)countInContext:(NSManagedObjectContext *)context error:(NSError **)error
{
    NSFetchRequest *fetchRequest = [self fetchRequestInContext:context];
    return [context countForFetchRequest:fetchRequest error:error];
}

+ (NSUInteger)count:(NSError **)error
{
    return [self countInContext:[self managedObjectContext] error:error];
}

+ (NSUInteger)count
{
    NSError *error = nil;
    return [self count:&error];
}

+ (id)objectInContext:(NSManagedObjectContext *)context
{
    id object = [[self alloc] initWithEntity:[self entityInContext:context] insertIntoManagedObjectContext:context];
    return object;
}

+ (id)object
{
    id object = [[self alloc] initWithEntity:[self ar_entity] insertIntoManagedObjectContext:[self managedObjectContext]];
    return object;
}

- (BOOL)isNew
{
    NSDictionary *vals = [self committedValuesForKeys:nil];
    return [vals count] == 0;
}

#pragma mark - MagicalRecord Ported Methods

+ (void)setDefaultBatchSize:(NSUInteger)newBatchSize
{
    @synchronized(defaultBatchSize)
    {
        defaultBatchSize = [NSNumber numberWithInteger:newBatchSize];
    }
}

+ (NSInteger)defaultBatchSize
{
    if (defaultBatchSize == nil) {
        [self setDefaultBatchSize:kActiveRecordDefaultBatchSize];
    }
    return [defaultBatchSize integerValue];
}

+ (void)handleErrors:(NSError *)error
{
    if (error) {
        NSDictionary *userInfo = [error userInfo];
        for (NSArray *detailedError in [userInfo allValues]) {
            if ([detailedError isKindOfClass:[NSArray class]]) {
                for (NSError *e in detailedError) {
                    if ([e respondsToSelector:@selector(userInfo)]) {
                        NSLog(@"Error Details: %@", [e userInfo]);
                    } else {
                        NSLog(@"Error Details: %@", e);
                    }
                }
            } else {
                NSLog(@"Error: %@", detailedError);
            }
        }
        NSLog(@"Error Domain: %@", [error domain]);
        NSLog(@"Recovery Suggestion: %@", [error localizedRecoverySuggestion]);
    }
}

//- (void)handleErrors:(NSError *)error
//{
//	[[self class] handleErrors:error];
//}

+ (NSArray *)executeFetchRequest:(NSFetchRequest *)request inContext:(NSManagedObjectContext *)context
{
    NSError *error = nil;

    NSArray *results = [context executeFetchRequest:request error:&error];
    [self handleErrors:error];
    return results;
}

+ (NSArray *)executeFetchRequest:(NSFetchRequest *)request
{
    return [self executeFetchRequest:request inContext:[self managedObjectContext]];
}

+ (id)executeFetchRequestAndReturnFirstObject:(NSFetchRequest *)request inContext:(NSManagedObjectContext *)context
{
    [request setFetchLimit:1];

    NSArray *results = [self executeFetchRequest:request inContext:context];
    if ([results count] == 0) {
        return nil;
    }
    return results[0];
}

+ (id)executeFetchRequestAndReturnFirstObject:(NSFetchRequest *)request
{
    return [self executeFetchRequestAndReturnFirstObject:request inContext:[self managedObjectContext]];
}

#if TARGET_OS_IPHONE
+ (void)performFetch:(NSFetchedResultsController *)controller
{
    NSError *error = nil;
    if (![controller performFetch:&error]) {
        [self handleErrors:error];
    }
}
#endif

+ (NSEntityDescription *)entityDescriptionInContext:(NSManagedObjectContext *)context
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    if ([self respondsToSelector:@selector(entityInManagedObjectContext:)]) {
        NSEntityDescription *entity = [self performSelector:@selector(entityInManagedObjectContext:) withObject:context];
        return entity;
    }
#pragma clang diagnostic pop
    else {
        NSString *entityName = NSStringFromClass([self class]);
        return [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
    }
}

+ (NSEntityDescription *)entityDescription
{
    return [self entityDescriptionInContext:[self managedObjectContext]];
}

+ (NSArray *)propertiesNamed:(NSArray *)properties inContext:(NSManagedObjectContext *)context
{
    NSEntityDescription *description = [self entityDescriptionInContext:context];
    NSMutableArray *propertiesWanted = [NSMutableArray array];

    if (properties) {
        NSDictionary *propDict = [description propertiesByName];

        for (NSString *propertyName in properties) {
            NSPropertyDescription *property = propDict[propertyName];
            if (property) {
                [propertiesWanted addObject:property];
            } else {
                NSLog(@"Property '%@' not found in %@ properties for %@", propertyName, @([propDict count]), NSStringFromClass(self));
            }
        }
    }
    return propertiesWanted;
}

+ (NSArray *)sortAscending:(BOOL)ascending attributes:(id)attributesToSortBy, ...
{
    NSMutableArray *attributes = [NSMutableArray array];

    if ([attributesToSortBy isKindOfClass:[NSArray class]]) {
        id attributeName;
        va_list variadicArguments;
        va_start(variadicArguments, attributesToSortBy);
        while ((attributeName = va_arg(variadicArguments, id)) != nil) {
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:attributeName ascending:ascending];
            [attributes addObject:sortDescriptor];
        }
        va_end(variadicArguments);

    } else if ([attributesToSortBy isKindOfClass:[NSString class]]) {
        va_list variadicArguments;
        va_start(variadicArguments, attributesToSortBy);
        [attributes addObject:[[NSSortDescriptor alloc] initWithKey:attributesToSortBy ascending:ascending]];
        va_end(variadicArguments);
    }

    return attributes;
}

+ (NSArray *)ascendingSortDescriptors:(id)attributesToSortBy, ...
{
    return [self sortAscending:YES attributes:attributesToSortBy];
}

+ (NSArray *)descendingSortDescriptors:(id)attributesToSortyBy, ...
{
    return [self sortAscending:NO attributes:attributesToSortyBy];
}

+ (NSFetchRequest *)createFetchRequestInContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[self entityDescriptionInContext:context]];

    return request;
}

+ (NSFetchRequest *)createFetchRequest
{
    return [self createFetchRequestInContext:[self managedObjectContext]];
}

#pragma mark -
#pragma mark Number of Entities

+ (NSNumber *)numberOfEntitiesWithContext:(NSManagedObjectContext *)context
{
    NSError *error = nil;
    NSUInteger count = [context countForFetchRequest:[self createFetchRequestInContext:context] error:&error];
    [self handleErrors:error];

    return @(count);
}

+ (NSNumber *)numberOfEntities
{
    return [self numberOfEntitiesWithContext:[self managedObjectContext]];
}

+ (NSNumber *)numberOfEntitiesWithPredicate:(NSPredicate *)searchTerm inContext:(NSManagedObjectContext *)context
{
    NSError *error = nil;
    NSFetchRequest *request = [self createFetchRequestInContext:context];
    [request setPredicate:searchTerm];

    NSUInteger count = [context countForFetchRequest:request error:&error];
    [self handleErrors:error];

    return @(count);
}

+ (NSNumber *)numberOfEntitiesWithPredicate:(NSPredicate *)searchTerm;
{
    return [self numberOfEntitiesWithPredicate:searchTerm
                                     inContext:[self managedObjectContext]];
}

+ (BOOL)hasAtLeastOneEntityInContext:(NSManagedObjectContext *)context
{
    return [[self numberOfEntitiesWithContext:context] intValue] > 0;
}

+ (BOOL)hasAtLeastOneEntity
{
    return [self hasAtLeastOneEntityInContext:[self managedObjectContext]];
}

#pragma mark -
#pragma mark Reqest Helpers
+ (NSFetchRequest *)requestAll
{
    return [self createFetchRequestInContext:[self managedObjectContext]];
}

+ (NSFetchRequest *)requestAllInContext:(NSManagedObjectContext *)context
{
    return [self createFetchRequestInContext:context];
}

+ (NSFetchRequest *)requestAllWhere:(NSString *)property isEqualTo:(id)value inContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [self createFetchRequestInContext:context];
    [request setPredicate:[NSPredicate predicateWithFormat:@"%K = %@", property, value]];

    return request;
}

+ (NSFetchRequest *)requestAllWhere:(NSString *)property isEqualTo:(id)value
{
    return [self requestAllWhere:property isEqualTo:value inContext:[self managedObjectContext]];
}

+ (NSFetchRequest *)requestFirstWithPredicate:(NSPredicate *)searchTerm inContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [self createFetchRequestInContext:context];
    [request setPredicate:searchTerm];
    [request setFetchLimit:1];

    return request;
}

+ (NSFetchRequest *)requestFirstWithPredicate:(NSPredicate *)searchTerm
{
    return [self requestFirstWithPredicate:searchTerm inContext:[self managedObjectContext]];
}

+ (NSFetchRequest *)requestFirstByAttribute:(NSString *)attribute withValue:(id)searchValue inContext:(NSManagedObjectContext *)context;
{
    NSFetchRequest *request = [self createFetchRequestInContext:context];
    [request setPropertiesToFetch:[self propertiesNamed:@[ attribute ] inContext:context]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"%K = %@", attribute, searchValue]];

    return request;
}

+ (NSFetchRequest *)requestFirstByAttribute:(NSString *)attribute withValue:(id)searchValue;
{
    return [self requestFirstByAttribute:attribute withValue:searchValue inContext:[self managedObjectContext]];
}

+ (NSFetchRequest *)requestAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending inContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [self requestAllInContext:context];

    NSSortDescriptor *sortBy = [[NSSortDescriptor alloc] initWithKey:sortTerm ascending:ascending];
    [request setSortDescriptors:@[ sortBy ]];

    return request;
}

+ (NSFetchRequest *)requestAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending
{
    return [self requestAllSortedBy:sortTerm
                          ascending:ascending
                          inContext:[self managedObjectContext]];
}

+ (NSFetchRequest *)requestAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate *)searchTerm inContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [self requestAllInContext:context];
    [request setPredicate:searchTerm];
    [request setIncludesSubentities:NO];
    [request setFetchBatchSize:[self defaultBatchSize]];

    if (sortTerm != nil) {
        NSSortDescriptor *sortBy = [[NSSortDescriptor alloc] initWithKey:sortTerm ascending:ascending];
        [request setSortDescriptors:@[ sortBy ]];
    }

    return request;
}

+ (NSFetchRequest *)requestAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate *)searchTerm;
{
    NSFetchRequest *request = [self requestAllSortedBy:sortTerm
                                             ascending:ascending
                                         withPredicate:searchTerm
                                             inContext:[self managedObjectContext]];
    return request;
}


#pragma mark Finding Data
#pragma mark -

+ (NSArray *)findAllInContext:(NSManagedObjectContext *)context
{
    return [self executeFetchRequest:[self requestAllInContext:context] inContext:context];
}

+ (NSArray *)findAll
{
    return [self findAllInContext:[self managedObjectContext]];
}

+ (NSArray *)findAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending inContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [self requestAllSortedBy:sortTerm ascending:ascending inContext:context];

    return [self executeFetchRequest:request inContext:context];
}

+ (NSArray *)findAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending
{
    return [self findAllSortedBy:sortTerm
                       ascending:ascending
                       inContext:[self managedObjectContext]];
}

+ (NSArray *)findAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate *)searchTerm inContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [self requestAllSortedBy:sortTerm
                                             ascending:ascending
                                         withPredicate:searchTerm
                                             inContext:context];

    return [self executeFetchRequest:request inContext:context];
}

+ (NSArray *)findAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate *)searchTerm
{
    return [self findAllSortedBy:sortTerm
                       ascending:ascending
                   withPredicate:searchTerm
                       inContext:[self managedObjectContext]];
}

#pragma mark -
#pragma mark NSFetchedResultsController helpers

#if TARGET_OS_IPHONE

+ (NSFetchedResultsController *)fetchRequestAllGroupedBy:(NSString *)group withPredicate:(NSPredicate *)searchTerm sortedBy:(NSString *)sortTerm ascending:(BOOL)ascending inContext:(NSManagedObjectContext *)context
{
    NSString *cacheName = nil;
#ifdef STORE_USE_CACHE
    cacheName = [NSString stringWithFormat:@"ActiveRecord-Cache-%@", NSStringFromClass(self)];
#endif

    NSFetchRequest *request = [self requestAllSortedBy:sortTerm
                                             ascending:ascending
                                         withPredicate:searchTerm
                                             inContext:context];

    NSFetchedResultsController *controller = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                                 managedObjectContext:context
                                                                                   sectionNameKeyPath:group
                                                                                            cacheName:cacheName];
    return controller;
}

+ (NSFetchedResultsController *)fetchRequestAllGroupedBy:(NSString *)group withPredicate:(NSPredicate *)searchTerm sortedBy:(NSString *)sortTerm ascending:(BOOL)ascending
{
    return [self fetchRequestAllGroupedBy:group
                            withPredicate:searchTerm
                                 sortedBy:sortTerm
                                ascending:ascending
                                inContext:[self managedObjectContext]];
}

+ (NSFetchedResultsController *)fetchAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate *)searchTerm groupBy:(NSString *)groupingKeyPath inContext:(NSManagedObjectContext *)context
{
    NSFetchedResultsController *controller = [self fetchRequestAllGroupedBy:groupingKeyPath
                                                              withPredicate:searchTerm
                                                                   sortedBy:sortTerm
                                                                  ascending:ascending
                                                                  inContext:context];

    [self performFetch:controller];
    return controller;
}

+ (NSFetchedResultsController *)fetchAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate *)searchTerm groupBy:(NSString *)groupingKeyPath
{
    return [self fetchAllSortedBy:sortTerm
                        ascending:ascending
                    withPredicate:searchTerm
                          groupBy:groupingKeyPath
                        inContext:[self managedObjectContext]];
}

+ (NSFetchedResultsController *)fetchRequest:(NSFetchRequest *)request groupedBy:(NSString *)group inContext:(NSManagedObjectContext *)context
{
    NSString *cacheName = nil;
#ifdef STORE_USE_CACHE
    cacheName = [NSString stringWithFormat:@"ActiveRecord-Cache-%@", NSStringFromClass([self class])];
#endif
    NSFetchedResultsController *controller =
        [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                            managedObjectContext:context
                                              sectionNameKeyPath:group
                                                       cacheName:cacheName];
    [self performFetch:controller];
    return controller;
}

+ (NSFetchedResultsController *)fetchRequest:(NSFetchRequest *)request groupedBy:(NSString *)group
{
    return [self fetchRequest:request
                    groupedBy:group
                    inContext:[self managedObjectContext]];
}
#endif

#pragma mark -

+ (NSArray *)findAllWithPredicate:(NSPredicate *)searchTerm inContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [self createFetchRequestInContext:context];
    [request setPredicate:searchTerm];

    return [self executeFetchRequest:request
                           inContext:context];
}

+ (NSArray *)findAllWithPredicate:(NSPredicate *)searchTerm
{
    return [self findAllWithPredicate:searchTerm
                            inContext:[self managedObjectContext]];
}

+ (id)findFirstInContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [self createFetchRequestInContext:context];
    return [self executeFetchRequestAndReturnFirstObject:request inContext:context];
}

+ (id)findFirst
{
    return [self findFirstInContext:[self managedObjectContext]];
}

+ (id)findFirstByAttribute:(NSString *)attribute withValue:(id)searchValue inContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [self requestFirstByAttribute:attribute withValue:searchValue inContext:context];
    [request setPropertiesToFetch:[self propertiesNamed:@[ attribute ] inContext:context]];

    return [self executeFetchRequestAndReturnFirstObject:request inContext:context];
}

+ (id)findFirstByAttribute:(NSString *)attribute withValue:(id)searchValue
{
    return [self findFirstByAttribute:attribute
                            withValue:searchValue
                            inContext:[self managedObjectContext]];
}

+ (id)findFirstWithPredicate:(NSPredicate *)searchTerm inContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [self requestFirstWithPredicate:searchTerm inContext:context];

    return [self executeFetchRequestAndReturnFirstObject:request inContext:context];
}

+ (id)findFirstWithPredicate:(NSPredicate *)searchTerm
{
    return [self findFirstWithPredicate:searchTerm inContext:[self managedObjectContext]];
}

+ (id)findFirstWithPredicate:(NSPredicate *)searchterm sortedBy:(NSString *)property ascending:(BOOL)ascending inContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [self requestAllSortedBy:property ascending:ascending withPredicate:searchterm inContext:context];

    return [self executeFetchRequestAndReturnFirstObject:request inContext:context];
}

+ (id)findFirstWithPredicate:(NSPredicate *)searchterm sortedBy:(NSString *)property ascending:(BOOL)ascending
{
    return [self findFirstWithPredicate:searchterm
                               sortedBy:property
                              ascending:ascending
                              inContext:[self managedObjectContext]];
}

+ (id)findFirstWithPredicate:(NSPredicate *)searchTerm andRetrieveAttributes:(NSArray *)attributes inContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [self createFetchRequestInContext:context];
    [request setPredicate:searchTerm];
    [request setPropertiesToFetch:[self propertiesNamed:attributes inContext:context]];

    return [self executeFetchRequestAndReturnFirstObject:request inContext:context];
}

+ (id)findFirstWithPredicate:(NSPredicate *)searchTerm andRetrieveAttributes:(NSArray *)attributes
{
    return [self findFirstWithPredicate:searchTerm
                  andRetrieveAttributes:attributes
                              inContext:[self managedObjectContext]];
}


+ (id)findFirstWithPredicate:(NSPredicate *)searchTerm sortedBy:(NSString *)sortBy ascending:(BOOL)ascending inContext:(NSManagedObjectContext *)context andRetrieveAttributes:(id)attributes, ...
{
    NSFetchRequest *request = [self requestAllSortedBy:sortBy
                                             ascending:ascending
                                         withPredicate:searchTerm
                                             inContext:context];
    [request setPropertiesToFetch:[self propertiesNamed:attributes inContext:context]];

    return [self executeFetchRequestAndReturnFirstObject:request inContext:context];
}

+ (id)findFirstWithPredicate:(NSPredicate *)searchTerm sortedBy:(NSString *)sortBy ascending:(BOOL)ascending andRetrieveAttributes:(id)attributes, ...
{
    return [self findFirstWithPredicate:searchTerm
                               sortedBy:sortBy
                              ascending:ascending
                              inContext:[self managedObjectContext]
                  andRetrieveAttributes:attributes];
}

+ (NSArray *)findByAttribute:(NSString *)attribute withValue:(id)searchValue inContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [self createFetchRequestInContext:context];

    [request setPredicate:[NSPredicate predicateWithFormat:@"%K = %@", attribute, searchValue]];

    return [self executeFetchRequest:request inContext:context];
}

+ (NSArray *)findByAttribute:(NSString *)attribute withValue:(id)searchValue
{
    return [self findByAttribute:attribute
                       withValue:searchValue
                       inContext:[self managedObjectContext]];
}

+ (NSArray *)findByAttribute:(NSString *)attribute withValue:(id)searchValue andOrderBy:(NSString *)sortTerm ascending:(BOOL)ascending inContext:(NSManagedObjectContext *)context
{
    NSPredicate *searchTerm = [NSPredicate predicateWithFormat:@"%K = %@", attribute, searchValue];
    NSFetchRequest *request = [self requestAllSortedBy:sortTerm ascending:ascending withPredicate:searchTerm inContext:context];

    return [self executeFetchRequest:request];
}

+ (NSArray *)findByAttribute:(NSString *)attribute withValue:(id)searchValue andOrderBy:(NSString *)sortTerm ascending:(BOOL)ascending
{
    return [self findByAttribute:attribute
                       withValue:searchValue
                      andOrderBy:sortTerm
                       ascending:ascending
                       inContext:[self managedObjectContext]];
}

+ (id)createInContext:(NSManagedObjectContext *)context
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    if ([self respondsToSelector:@selector(insertInManagedObjectContext:)]) {
        id entity = [self performSelector:@selector(insertInManagedObjectContext:) withObject:context];
        return entity;
    } else {
        NSString *entityName = NSStringFromClass([self class]);
        return [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:context];
    }
#pragma clang diagnostic pop
}

+ (id)createEntity
{
    NSManagedObject *newEntity = [self createInContext:[self managedObjectContext]];

    return newEntity;
}

- (BOOL)deleteInContext:(NSManagedObjectContext *)context
{
    [context deleteObject:self];
    return YES;
}

- (BOOL)deleteEntity
{
    [self deleteInContext:self.managedObjectContext];
    return YES;
}

+ (BOOL)truncateAllInContext:(NSManagedObjectContext *)context
{
    NSArray *allEntities = [self findAllInContext:context];
    for (NSManagedObject *obj in allEntities) {
        [obj deleteInContext:context];
    }
    return YES;
}

+ (BOOL)truncateAll
{
    [self truncateAllInContext:[self managedObjectContext]];
    return YES;
}

+ (NSNumber *)maxValueFor:(NSString *)property
{
    NSManagedObject *obj = [[self class] findFirstByAttribute:property
                                                    withValue:[NSString stringWithFormat:@"max(%@)", property]];

    return [obj valueForKey:property];
}

+ (id)objectWithMinValueFor:(NSString *)property inContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [[self class] createFetchRequestInContext:context];

    NSPredicate *searchFor = [NSPredicate predicateWithFormat:@"SELF = %@ AND %K = min(%@)", self, property, property];
    [request setPredicate:searchFor];

    return [[self class] executeFetchRequestAndReturnFirstObject:request inContext:context];
}

+ (id)objectWithMinValueFor:(NSString *)property
{
    return [[self class] objectWithMinValueFor:property inContext:[self managedObjectContext]];
}

@end
