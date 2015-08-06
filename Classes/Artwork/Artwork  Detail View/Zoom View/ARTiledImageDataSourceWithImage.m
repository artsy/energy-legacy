#import "ARTiledImageDataSourceWithImage.h"


@implementation ARTiledImageDataSourceWithImage

- (instancetype)initWithImage:(Image *)image
{
    self = [super init];
    if (!self) return nil;

    _image = image;

    self.tileFormat = @"jpg";

    if (self.image.tileBaseUrl) {
        self.tileBaseURL = [NSURL URLWithString:self.image.tileBaseUrl];
        self.tileSize = image.tileSize.floatValue;
        self.maxTiledHeight = self.image.maxTiledHeight.floatValue;
        self.maxTiledWidth = self.image.maxTiledWidth.floatValue;
        self.maxTileLevel = self.image.maxLevel;

    } else {
        self.maxTiledHeight = self.image.originalHeight.floatValue;
        self.maxTiledWidth = self.image.originalWidth.floatValue;

        // These are some standard numbers for tiles
        self.maxTileLevel = 13;
        self.tileSize = 512;
    }

    self.minTileLevel = 11;

    return self;
}

- (UIImage *)tiledImageView:(ARTiledImageView *)imageView imageTileForLevel:(NSInteger)level x:(NSInteger)x y:(NSInteger)y
{
    return [self.image imageTileForLevel:level atX:x andY:y];
}

- (void)tiledImageView:(ARTiledImageView *)imageView didDownloadTiledImage:(UIImage *)image atURL:(NSURL *)url
{
    NSCharacterSet *charactersToRemove = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
    NSArray *urlParts = [url.absoluteString componentsSeparatedByCharactersInSet:charactersToRemove];

    if (urlParts.count != 16) {
        [super tiledImageView:imageView didDownloadTiledImage:image atURL:url];
        return;
    }

    NSInteger x = [urlParts[urlParts.count - 1] integerValue];
    NSInteger y = [urlParts[urlParts.count - 2] integerValue];
    NSInteger level = [urlParts[urlParts.count - 3] integerValue];

    NSString *filepath = [self.image imagePathForTileForLevel:level atX:x andY:y];
    [UIImageJPEGRepresentation(image, 1.0) writeToFile:filepath atomically:YES];
}

@end
