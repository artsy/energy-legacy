#import "ARThumbnail.h"


@implementation ARThumbnail

+ (ARThumbnail *)thumbnailWithImage:(Image *)image format:(NSString *)format
{
    ARThumbnail *thumbnail = [[ARThumbnail alloc] init];
    thumbnail.image = image;
    thumbnail.format = format;
    return thumbnail;
}

@end
