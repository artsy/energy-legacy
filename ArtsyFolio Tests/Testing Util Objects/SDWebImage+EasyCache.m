#import "SDWebImage+EasyCache.h"
#import "AROHHTTPNoStubAssertionBot.h"


@implementation SDWebImageManager (EasyCache)

+ (void)cacheImageNamed:(NSString *)image toCacheWithAddress:(NSString *)address;
{
    NSString *localImagePath = [[NSBundle bundleForClass:AROHHTTPNoStubAssertionBot.class] pathForResource:image ofType:@"png"];
    UIImage *imageFile = [UIImage imageWithContentsOfFile:localImagePath];

    [SDImageCache.sharedImageCache storeImage:imageFile forKey:address toDisk:NO];
}

@end
