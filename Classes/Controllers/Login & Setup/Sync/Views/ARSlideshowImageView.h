/// A sliding image slide show view, nothing fancy.
/// Sets the internal image size to be a square centered based
/// on the smallest bounds dimension.


@interface ARSlideshowImageView : UIView

/// Starts animating immediately
- (void)start;

/// Stops animation leaving the last image on
- (void)stop;

/// Time between images, defaults to 1.5
@property (nonatomic, assign) NSTimeInterval duration;

/// Toggle animations on and off, defaults to YES
@property (nonatomic, assign) BOOL animates;

/// Adds a file path to the image queue
- (void)addImagePathToQueue:(NSString *)path;

/// Are there images in the queue already?
- (BOOL)hasImages;

/// The current image view being shown, defaults to nil
@property (readonly, copy, nonatomic) UIImageView *currentImageView;


@end
