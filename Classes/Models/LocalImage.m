#import "LocalImage.h"


@implementation LocalImage

@synthesize imageFilePath;

- (NSString *)tempId
{
    return self.imageFilePath;
}

- (NSString *)gridThumbnailPath:(NSString *)size
{
    return self.imageFilePath;
}

- (NSURL *)gridThumbnailURL:(NSString *)size
{
    return nil;
}

- (NSURL *)imageURLWithFormatName:(NSString *)formatName
{
    return nil;
}

- (NSString *)slug
{
    return self.imageFilePath;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"LocalImage : For %@", self.artwork.title];
}


@end
