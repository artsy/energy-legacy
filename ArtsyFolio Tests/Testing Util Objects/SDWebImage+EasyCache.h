#import <SDWebImage/SDWebImageManager.h>


@interface SDWebImageManager (EasyCache)

+ (void)cacheImageNamed:(NSString *)image toCacheWithAddress:(NSString *)address;

@end
