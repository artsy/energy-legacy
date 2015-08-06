

@interface ARImageTile : NSObject

+ (NSArray *)tilesForImage:(Image *)image;

- (BOOL)exists;

@property (nonatomic, strong) Image *image;
@property (nonatomic, strong, readonly) NSURL *URL;
@property (nonatomic, strong, readonly) NSString *path;
@property (atomic, assign) NSUInteger level;
@property (atomic, assign) NSUInteger x;
@property (atomic, assign) NSUInteger y;

@end
