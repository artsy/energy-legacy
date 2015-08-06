#import "PartnerOption.h"
#import "NSDictionary+ObjectForKey.h"


@implementation PartnerOption

+ (NSSet *)optionsWithDictionary:(NSDictionary *)dictionary inContext:(NSManagedObjectContext *)context
{
    if (!dictionary) return nil;

    return [NSSet setWithArray:[[dictionary.allKeys select:^BOOL(id object) {
        return [dictionary[object] isKindOfClass:NSString.class] ||
               [dictionary[object] isKindOfClass:NSNumber.class];

    }] map:^(NSString *object) {
        PartnerOption *option = [PartnerOption createInContext:context];
        option.key = object;
        option.value = [dictionary onlyStringForKey:object] ?: [[dictionary onlyNumberForKey:object] stringValue];
        return option;
    }]];
}

@end
