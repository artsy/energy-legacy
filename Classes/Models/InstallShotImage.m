#import "InstallShotImage.h"
#import "NSDictionary+ObjectForKey.h"


@implementation InstallShotImage

+ (NSArray *)imageFormatsToDownload
{
    return @[ ARFeedImageSizeLargerKey, ARFeedImageSizeMediumKey ];
}

- (void)updateWithDictionary:(NSDictionary *)aDictionary
{
    [super updateWithDictionary:aDictionary];

    self.caption = [aDictionary onlyStringForKey:ARFeedCaptionKey];
}

- (NSString *)tempId
{
    return [self imagePathWithFormatName:@"large"];
}

- (NSString *)gridThumbnailPath:(NSString *)size
{
    return [self imagePathWithFormatName:size];
}

- (NSURL *)gridThumbnailURL:(NSString *)size
{
    return [self imageURLWithFormatName:size];
}

- (NSString *)gridTitle
{
    return @"";
}

- (NSString *)gridSubtitle
{
    return self.caption;
}

@end
