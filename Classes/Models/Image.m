#import "ARFileUtils.h"
#import "NSDictionary+ObjectForKey.h"
#import "ARRouter.h"

NSString *const ImageDirectoryName = @"images";
NSString *const ImageFileExtension = @"jpg";
static NSArray *_imageFormatsToDownload;


@implementation Image
{
    NSMutableDictionary *images;
    NSString *slug;
    int maxLevel;
}

@dynamic isMainImage;

+ (NSArray *)imageFormatsToDownload
{
    return @[ ARFeedImageSizeLargerKey, ARFeedImageSizeMediumKey, ARFeedImageSizeSquareKey ];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"Image : For %@", self.artwork.title];
}

- (void)updateWithDictionary:(NSDictionary *)json
{
    // If normalized isn't in image_versions, the image hasn't
    // been processed yet, so there's no tiles, no tile info, no
    // a lot of things we need, so we bail

    NSObject *normalisedVersion = [[json objectForKeyNotNull:ARFeedImageVersionsKey] find:^BOOL(NSString *version) {
        return [version isEqualToString:@"normalized"];
    }];

    self.processing = @(normalisedVersion == nil);

    if ([json objectForKeyNotNull:ARFeedArtworkIDKey]) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"slug == %@", [json objectForKeyNotNull:ARFeedArtworkIDKey]];
        Artwork *artworkForImage = [Artwork findFirstWithPredicate:predicate inContext:self.managedObjectContext];
        if (artworkForImage) {
            self.artwork = artworkForImage;
        }
    }

    if (nil == self.position) {
        NSInteger count = [self.artwork.images count];
        self.position = @(count - 1);
    }

    if ([[json objectForKeyNotNull:ARFeedImageIsMainImageKey] boolValue]) {
        self.artwork.mainImage = self;
    }

    self.tileSize = [json objectForKeyNotNull:ARFeedTileSizeKey];
    self.tileFormat = [json objectForKeyNotNull:ARFeedTileFormatKey];
    self.tileBaseUrl = [json objectForKeyNotNull:ARFeedTileBaseUrlKey];
    self.tileOverlap = [json objectForKeyNotNull:ARFeedTileOverlapKey];
    self.position = [json onlyNumberForKey:ARFeedImagePositionKey];

    self.aspectRatio = [json objectForKeyNotNull:ARFeedImageAspectRatioKey];
    self.originalWidth = [json objectForKeyNotNull:ARFeedImageOriginalWidthKey];
    self.originalHeight = [json objectForKeyNotNull:ARFeedImageOriginalHeightKey];
    self.maxTiledHeight = [json objectForKeyNotNull:ARFeedMaxTiledHeightKey];
    self.maxTiledWidth = [json objectForKeyNotNull:ARFeedMaxTiledWidthKey];

    // Do not trust the aspectRatio returned by Gravity, see #258
    if (!self.aspectRatio) {
        CGFloat width = self.maxTiledWidthValue ?: self.originalWidthValue;
        CGFloat height = self.maxTiledHeightValue ?: self.originalHeightValue;

        if (width && height) {
            self.aspectRatio = @(height / width);
        }
    }

    NSString *imageSource = [json objectForKeyNotNull:ARFeedImageSourceKey];
    if (imageSource) {
        NSURL *imageURL = [ARRouter fullURLForImage:imageSource];
        self.baseURL = [[imageURL URLByDeletingLastPathComponent] absoluteString];
    }
}

#pragma -
#pragma Normal images : fetching, paths and URLs

- (UIImage *)imageWithFormatName:(NSString *)formatName
{
    NSString *address = [self imagePathWithFormatName:formatName];
    return [self imageFromAddress:address withFormat:formatName];
}

- (UIImage *)imageFromAddress:(NSString *)address withFormat:(NSString *)format
{
    UIImage *anImage = nil;
    if ([[NSFileManager defaultManager] fileExistsAtPath:address]) {
        anImage = [[UIImage alloc] initWithContentsOfFile:address];
    } else {
        // corrupt file! remove from filesystem so we can re-download it
        [[NSFileManager defaultManager] removeItemAtPath:address error:nil];
    }
    return anImage;
}

- (NSString *)imagePathWithFormatName:(NSString *)formatName
{
    NSString *imageName = [[NSString alloc] initWithFormat:@"%@_%@", self.slug, formatName];
    return [ARFileUtils filePathWithFolder:ImageDirectoryName
                                  filename:imageName
                                 extension:ImageFileExtension];
}

- (NSURL *)imageURLWithFormatName:(NSString *)formatName
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@.jpg", self.baseURL, formatName]];
}

#pragma mark -
#pragma mark Image tiles: fetching, urls, paths

- (NSURL *)urlForTileArchive
{
    return [NSURL URLWithString:[self.baseURL stringByAppendingPathComponent:@"tiles.zip"]];
}

- (UIImage *)imageTileForLevel:(NSInteger)level atX:(NSInteger)x andY:(NSInteger)y
{
    NSString *address = [self imagePathForTileForLevel:level atX:x andY:y];
    //we're using imageWithContentsOfFile because unlike imageNamed, it doesn't cache
    UIImage *img = [UIImage imageWithContentsOfFile:address];
    return img;
}

- (NSURL *)imageURLForTileForLevel:(NSInteger)level atX:(NSInteger)x andY:(NSInteger)y
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@_%@.%@",
                                                           self.tileBaseUrl, @(level), @(x), @(y), self.tileFormat]];
}

- (NSString *)imagePathForTileForLevel:(NSInteger)level atX:(NSInteger)x andY:(NSInteger)y
{
    NSString *imageName = [[NSString alloc] initWithFormat:@"%@_tile_%@_%@_%@", self.slug, @(level), @(x), @(y)];
    NSString *path = [ARFileUtils filePathWithFolder:ImageDirectoryName
                                            filename:imageName
                                           extension:ImageFileExtension];
    return path;
}

- (BOOL)needsTiles
{
    return (self.maxLevel >= ARTiledZoomMinLevel) && [self.maxTiledWidth intValue] && [self.maxTiledHeight intValue];
}

- (BOOL)hasTiles
{
    // 11 is the 100% zoom, so is found in every image we have tiles for
    NSString *localPathForTopLeft = [self imagePathForTileForLevel:11 atX:0 andY:0];
    return [[NSFileManager defaultManager] fileExistsAtPath:localPathForTopLeft];
}

- (BOOL)hasLocalImageForFormat:(NSString *)format
{
    NSString *path = [self imagePathWithFormatName:ARFeedImageSizeLargerKey];
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
}

- (CGSize)sizeForWidth:(float)width
{
    float w = self.maxTiledWidth.floatValue || self.originalWidth.floatValue;
    float h = self.maxTiledHeight.floatValue || self.originalHeight.floatValue;
    if (!(w && h)) {
        return CGSizeMake(width, width);
    }
    float scale = width / w;
    return CGSizeMake(width, h * scale);
}

- (CGSize)sizeForHeight:(float)height
{
    float w = self.maxTiledWidth.floatValue || self.originalWidth.floatValue;
    float h = self.maxTiledHeight.floatValue || self.originalHeight.floatValue;
    if (!(w && h)) {
        return CGSizeMake(height, height);
    }
    float scale = height / h;
    return CGSizeMake(w * scale, height);
}

- (NSInteger)maxLevel
{
    if (maxLevel <= 0) {
        NSInteger w = [self.maxTiledWidth intValue];
        NSInteger h = [self.maxTiledHeight intValue];
        maxLevel = ceil(log(MAX(w, h)) / log(2));
    }
    return MAX(maxLevel, 0);
}

- (void)deleteImage
{
    int w = [self.maxTiledWidth intValue];
    int h = [self.maxTiledHeight intValue];
    int tileSize = [self.tileSize intValue];
    NSInteger highest = self.maxLevel;
    int rows, columns;
    float scale = 1.f;

    for (NSInteger level = highest; level >= ARTiledZoomMinLevel; level--) {
        rows = ceil(h * scale / tileSize);
        columns = ceil(w * scale / tileSize);
        for (int i = 0; i < columns; i++) {
            for (int j = 0; j < rows; j++) {
                NSString *path = [self imagePathForTileForLevel:level atX:i andY:j];
                if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
                }
            }
        }
        scale *= .5f;
    }

    for (NSString *format in [self.class imageFormatsToDownload]) {
        NSString *path = [self imagePathWithFormatName:format];
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
            [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
        }
    }

    [self deleteEntity];
}

@end
