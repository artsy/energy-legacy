#import <Foundation/Foundation.h>

// This would be a struct if you could
// pass a collection of structs without busywork


@interface ARSortDefinition : NSObject

+ (instancetype)definitionWithName:(NSString *)name andOrder:(ARArtworkSortOrder)order;

- (instancetype)initWithName:(NSString *)name andOrder:(ARArtworkSortOrder)order;

@property (readonly, nonatomic, copy) NSString *name;
@property (readonly, nonatomic, assign) ARArtworkSortOrder order;

@end
