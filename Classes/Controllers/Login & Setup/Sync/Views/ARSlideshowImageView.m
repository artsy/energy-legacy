#import "ARSlideshowImageView.h"


@interface ARSlideshowImageView ()
@property (readonly, copy, nonatomic) NSMutableArray *imageQueue;
@end


@implementation ARSlideshowImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;

    [self setup];

    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setup];
}

- (void)setup
{
    self.clipsToBounds = NO;
    _duration = 1.5;
    _animates = YES;
}

- (void)start
{
    [self checkImageQueue];
}

- (void)stop
{
    [self.class cancelPreviousPerformRequestsWithTarget:self selector:@selector(checkImageQueue) object:nil];
}

- (BOOL)hasImages
{
    return self.imageQueue.count > 0;
}

- (void)checkImageQueue
{
    if (self.imageQueue.count) {
        NSString *next = self.imageQueue[0];
        UIImageView *old = self.currentImageView;

        [self.imageQueue removeObject:next];
        [self showImage:next];

        [UIView animateIf:self.animates duration:ARAnimationDuration:^{
            CGRect frame = old.frame;
            frame.origin.x = -frame.size.width - 20;
            old.frame = frame;
            old.alpha = 0;

        } completion:^(BOOL finished) {
            [old removeFromSuperview];
        }];
    }

    [self performSelector:@selector(checkImageQueue) withObject:self afterDelay:self.duration];
}

- (void)showImage:(NSString *)fileName
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:fileName]];

    CGSize outerBoundsSize = self.superview.bounds.size;
    CGFloat shortestDimension = MIN(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));

    __block CGRect frame = imageView.frame;
    frame.size = CGSizeMake(shortestDimension, shortestDimension);
    frame.origin.x = outerBoundsSize.width + 20;
    frame.origin.y = 0;

    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.frame = frame;
    imageView.alpha = 0;

    [self addSubview:imageView];
    _currentImageView = imageView;

    CGFloat velocity = [UIDevice isPad] ? 0.4 : 0.2;
    [UIView animateSpringIf:self.animates duration:ARAnimationLongDuration delay:0 damping:0.7 velocity:velocity:^{

        frame.origin.x = (CGRectGetWidth(self.bounds) / 2) - (CGRectGetWidth(imageView.bounds) / 2);
        imageView.frame = frame;
        imageView.alpha = 1;
    }];
}

- (void)addImagePathToQueue:(NSString *)path
{
    if (!_imageQueue) {
        _imageQueue = [NSMutableArray array];
    }

    [_imageQueue addObject:path];
}

@end
