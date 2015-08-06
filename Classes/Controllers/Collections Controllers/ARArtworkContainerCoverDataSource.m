#import "ARArtworkContainerCoverDataSource.h"


@implementation ARArtworkContainerCoverDataSource

- (NSString *)gridThumbnailPath:(NSString *)size container:(NSObject<ARArtworkContainer> *)object
{
    Image *thumbnail = [self coverForContainer:object];
    if (thumbnail) {
        return [thumbnail imagePathWithFormatName:size];
    }
    return [[NSBundle mainBundle] pathForResource:@"GridPlaceholder" ofType:@"png"];
}

- (NSURL *)gridThumbnailURL:(NSString *)size container:(NSObject<ARArtworkContainer> *)object
{
    Image *thumbnail = [self coverForContainer:object];
    if (thumbnail) {
        return [thumbnail imageURLWithFormatName:size];
    }
    return [[NSBundle mainBundle] URLForResource:@"GridPlaceholder" withExtension:@"png"];
}

- (float)aspectRatioForContainer:(NSObject<ARArtworkContainer> *)object
{
    Image *thumb = [self coverForContainer:object];
    return thumb ? thumb.aspectRatio.floatValue : 1;
}

- (Image *)coverForContainer:(NSObject<ARArtworkContainer> *)object
{
    if ([object respondsToSelector:@selector(cover)]) {
        if ([(id)object cover]) return [(id)object cover];
    }

    if ([object collectionSize] > 0) {
        return [object firstArtwork].mainImage;
    }

    return nil;
}

@end
