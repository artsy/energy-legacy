#import "ARManagedObject+ModelFromJSON.h"


@implementation ARManagedObject (ModelFromJSON)

+ (instancetype)stubbedModelFromJSON:(NSDictionary *)dictionary
{
    return [self modelFromJSON:dictionary inContext:[CoreDataManager stubbedManagedObjectContext]];
}

+ (instancetype)modelFromJSON:(NSDictionary *)dictionary inContext:(NSManagedObjectContext *)context
{
    id instance = [self objectInContext:context];
    [instance setSlug:[self.class folioSlug:dictionary]];
    [instance updateWithDictionary:dictionary];
    return instance;
}

@end
