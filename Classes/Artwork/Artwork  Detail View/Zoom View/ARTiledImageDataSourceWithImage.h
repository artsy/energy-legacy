#import "ARTiledImageView.h"
#import "ARWebTiledImageDataSource.h"


@interface ARTiledImageDataSourceWithImage : ARWebTiledImageDataSource

- (instancetype)initWithImage:(Image *)image;

@property (nonatomic, strong, readonly) Image *image;

@end
