#import "ARManagedObject.h"


@interface ARManagedObject (ModelFromJSON)

+ (instancetype)stubbedModelFromJSON:(NSDictionary *)dictionary;
+ (instancetype)modelFromJSON:(NSDictionary *)dictionary inContext:(NSManagedObjectContext *)context;

@end
