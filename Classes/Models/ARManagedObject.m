#import "NSDictionary+ObjectForKey.h"
#import "ARFeedTranslator.h"


@implementation ARManagedObjectID
@end


@implementation ARManagedObject
@dynamic slug;

- (void)updateWithDictionary:(NSDictionary *)aDictionary
{
    // no op
}

+ (NSString *)folioSlug:(NSDictionary *)dictionary
{
    if ([dictionary onlyStringForKey:ARFeedIDKey] || [dictionary onlyStringForKey:ARFeedSlugKey]) {
        NSString *anId = [dictionary onlyStringForKey:ARFeedIDKey];
        if (!anId) {
            anId = [dictionary onlyStringForKey:ARFeedSlugKey];
        }
        return anId;
    }
    return nil;
}

- (NSString *)tempId
{
    return [[[self objectID] URIRepresentation] absoluteString];
}

+ (instancetype)addOrUpdateWithDictionary:(NSDictionary *)dictionary inContext:(NSManagedObjectContext *)context saving:(BOOL)saving
{
    if (!dictionary) return nil;
    return (id)[ARFeedTranslator addOrUpdateObject:dictionary withEntityName:NSStringFromClass(self) inContext:context saving:saving];
}

+ (NSSet *)addOrUpdateWithDictionaries:(NSArray *)dictionaries inContext:(NSManagedObjectContext *)context saving:(BOOL)saving
{
    if (!dictionaries) return nil;
    return [NSSet setWithArray:(id)[ARFeedTranslator addOrUpdateObjects:dictionaries withEntityName:NSStringFromClass(self) inContext:context saving:saving]];
}

- (BOOL)saveManagedObjectContextLoggingErrors
{
    NSError *error = nil;

    if (![self.managedObjectContext save:&error] && error) {
        NSArray *detailedErrors = [error userInfo][NSDetailedErrorsKey];
        if (detailedErrors != nil && [detailedErrors count] > 0) {
            for (NSError *detailedError in detailedErrors) {
                [ARAnalytics event:@"Error: Failed to save to data store" withProperties:@{ @"error" : detailedError.userInfo }];
            }
        } else if (error.localizedDescription) {
            [ARAnalytics event:@"Error: Failed to save to data store" withProperties:@{ @"error" : error.localizedDescription }];
        }
        return NO;
    }

    return YES;
}

@end
