#import "ARManagedObject.h"
#import "_Image.h"

#define AR_TILED_ZOOM_MIN_LEVEL 11

extern NSString *const ImageDirectoryName;
extern NSString *const ImageFileExtension;

@class Artwork;


@interface Image : _Image

// kept around for migrations
@property (nonatomic, strong) NSNumber *isMainImage;

+ (NSArray *)imageFormatsToDownload;

- (NSString *)imagePathWithFormatName:(NSString *)formatName;

- (NSURL *)imageURLWithFormatName:(NSString *)formatName;

- (UIImage *)imageWithFormatName:(NSString *)formatName;

- (NSURL *)urlForTileArchive;

- (NSString *)imagePathForTileForLevel:(NSInteger)level atX:(NSInteger)x andY:(NSInteger)y;

- (NSURL *)imageURLForTileForLevel:(NSInteger)level atX:(NSInteger)x andY:(NSInteger)y;

- (UIImage *)imageTileForLevel:(NSInteger)level atX:(NSInteger)x andY:(NSInteger)y;

- (BOOL)hasLocalImageForFormat:(NSString *)format;

- (BOOL)needsTiles;

- (BOOL)hasTiles;

- (void)updateWithDictionary:(NSDictionary *)aDictionary;

- (UIImage *)imageFromAddress:(NSString *)address withFormat:(NSString *)format;

- (CGSize)sizeForWidth:(float)width;

- (CGSize)sizeForHeight:(float)height;

- (NSInteger)maxLevel;

- (void)deleteImage;
@end
