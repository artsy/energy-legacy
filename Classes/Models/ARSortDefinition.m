#import "ARSortDefinition.h"


@implementation ARSortDefinition

+ (instancetype)definitionWithName:(NSString *)name andOrder:(ARArtworkSortOrder)order
{
    return [[self alloc] initWithName:name andOrder:order];
}

- (instancetype)initWithName:(NSString *)name andOrder:(ARArtworkSortOrder)order
{
    if (self = [super init]) {
        _name = name;
        _order = order;
    }
    return self;
}
@end
