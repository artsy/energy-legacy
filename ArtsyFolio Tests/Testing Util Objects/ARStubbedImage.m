#import "ARStubbedImage.h"


@implementation ARStubbedImage

@synthesize stubbedImageFilePath;

- (instancetype)initWithEntity:(NSEntityDescription *)entity insertIntoManagedObjectContext:(NSManagedObjectContext *)context
{
    self = [super initWithEntity:entity insertIntoManagedObjectContext:context];
    if (!self) return nil;

    self.stubbedImageFilePath = @"";

    return self;
}

- (BOOL)needsTiles
{
    return YES;
}

- (BOOL)hasTiles
{
    return YES;
}

- (UIImage *)imageWithFormatName:(NSString *)formatName
{
    return [UIImage imageWithContentsOfFile:self.stubbedImageFilePath];
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
    return self.stubbedImageFilePath;
}

- (NSURL *)imageURLWithFormatName:(NSString *)formatName
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@.jpg", self.stubbedImageFilePath]];
}


#pragma mark -
#pragma mark Image tiles: fetching, urls, paths

- (NSURL *)urlForTileArchive
{
    return [NSURL URLWithString:[self.baseURL stringByAppendingPathComponent:@"tiles.zip"]];
}

- (UIImage *)imageTileForLevel:(NSInteger)level atX:(NSInteger)x andY:(NSInteger)y
{
    return [self imageWithFormatName:nil];
}

- (NSURL *)imageURLForTileForLevel:(NSInteger)level atX:(NSInteger)x andY:(NSInteger)y
{
    return [self imageURLWithFormatName:nil];
}

- (NSString *)imagePathForTileForLevel:(NSInteger)level atX:(NSInteger)x andY:(NSInteger)y
{
    return [self imagePathWithFormatName:nil];
}

@end
