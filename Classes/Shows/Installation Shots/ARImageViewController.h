@class InstallShotImage;


@interface ARImageViewController : UIViewController

- (instancetype)initWithImage:(Image *)image;

@property (nonatomic, strong, readonly) Image *image;

/// The index in the current set of artworks
@property (nonatomic, assign) NSInteger index;


@end
