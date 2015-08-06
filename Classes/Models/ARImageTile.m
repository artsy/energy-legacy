#import "ARImageTile.h"


@implementation ARImageTile

+ (NSArray *)tilesForImage:(Image *)image
{
    NSUInteger w = [image.maxTiledWidth unsignedIntegerValue];
    NSUInteger h = [image.maxTiledHeight unsignedIntegerValue];
    NSUInteger tileSize = [image.tileSize unsignedIntegerValue];
    NSUInteger highest = image.maxLevel;
    NSUInteger rows, columns;
    CGFloat scale = 1.f;

    NSMutableArray *tiles = [NSMutableArray array];
    for (NSUInteger level = highest; level >= ARTiledZoomMinLevel; level--) {
        rows = ceil(h * scale / tileSize);
        columns = ceil(w * scale / tileSize);
        for (NSUInteger i = 0; i < columns; i++) {
            for (NSUInteger j = 0; j < rows; j++) {
                ARImageTile *tile = [[ARImageTile alloc] init];
                tile.image = image;
                tile.level = level;
                tile.x = i;
                tile.y = j;
                [tiles addObject:tile];
            }
        }
        scale *= .5f;
    }
    return tiles;
}

- (NSURL *)URL
{
    return [self.image imageURLForTileForLevel:self.level atX:self.x andY:self.y];
}

- (NSString *)path
{
    return [self.image imagePathForTileForLevel:self.level atX:self.x andY:self.y];
}

- (BOOL)exists
{
    return [[NSFileManager defaultManager] fileExistsAtPath:self.path];
}

@end
