#import "ARImageFormat.h"


@implementation ARImageFormat

+ (ARImageFormat *)imageFormatWithImage:(Image *)image format:(NSString *)format
{
    ARImageFormat *imageFormat = [[ARImageFormat alloc] init];
    imageFormat.image = image;
    imageFormat.format = format;
    return imageFormat;
}

- (NSURL *)URL
{
    return [_image imageURLWithFormatName:_format];
}

- (NSString *)path
{
    return [_image imagePathWithFormatName:_format];
}

- (BOOL)isLarge
{
    NSString *suffix = [NSString stringWithFormat:@"%@.%@", ARFeedImageSizeLargerKey, ImageFileExtension];
    NSString *path = [self path];
    return [path rangeOfString:suffix].location == [path length] - [suffix length];
}

@end
