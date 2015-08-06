@class Image;


@interface ARImageFormat : NSObject

+ (ARImageFormat *)imageFormatWithImage:(Image *)image format:(NSString *)format;

@property (nonatomic, strong) Image *image;
@property (nonatomic, strong) NSString *format;
@property (nonatomic, readonly) NSURL *URL;
@property (nonatomic, readonly) NSString *path;
@property (nonatomic, readonly, assign) BOOL isLarge;

@end
