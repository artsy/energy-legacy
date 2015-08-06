#import "NSArray+ObjectsOfClass.h"


@implementation NSArray (ObjectsOfClass)

- (NSArray *)arrayWithOnlyObjectsOfClass:(Class)klass
{
    NSPredicate *classPredicate = [NSPredicate predicateWithFormat:@"self isKindOfClass: %@", klass];
    return [self filteredArrayUsingPredicate:classPredicate];
}

@end


@implementation NSSet (ObjectsOfClass)

- (NSSet *)setWithOnlyObjectsOfClass:(Class)klass
{
    NSPredicate *classPredicate = [NSPredicate predicateWithFormat:@"self isKindOfClass: %@", klass];
    return [self filteredSetUsingPredicate:classPredicate];
}

@end
