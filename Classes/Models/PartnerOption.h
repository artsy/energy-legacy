#import "_PartnerOption.h"

@class _SubscriptionPlan;


@interface PartnerOption : _PartnerOption

+ (NSSet *)optionsWithDictionary:(NSDictionary *)dictionary inContext:(NSManagedObjectContext *)context;

@end
