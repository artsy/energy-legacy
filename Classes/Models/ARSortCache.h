#import <Foundation/Foundation.h>


@interface ARSortCache : NSObject
+ (enum ARArtworkSortOrder)sortOrderForObjectWithSlug:(NSString *)slug;

+ (void)setOrder:(enum ARArtworkSortOrder)order forObjectWithSlug:(NSString *)slug;

@end
