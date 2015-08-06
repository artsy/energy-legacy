@class Image;


@interface UIImageView (ArtsySetURL)

- (void)setupWithImage:(Image *)image format:(NSString *)format;

- (void)setupWithFilepath:(NSString *)path url:(NSURL *)url;

@end
