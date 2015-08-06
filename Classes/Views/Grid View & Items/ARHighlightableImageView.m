#import "ARHighlightableImageView.h"
#import "UIImageView+ImageFrame.h"


@interface ARHighlightableImageView ()
@property (readonly, nonatomic, weak) UIImageView *badgeImageView;
@property (readonly, nonatomic, assign) CGSize insets;
@end


@implementation ARHighlightableImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;

    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.opaque = YES;
    imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:imageView];

    _imageView = imageView;
    self.backgroundColor = [UIColor artsyBackgroundColor];

    _insets = CGSizeZero;

    return self;
}

- (void)setContentMode:(UIViewContentMode)contentMode
{
    [super setContentMode:contentMode];
    self.imageView.contentMode = contentMode;
}

- (UIImage *)image
{
    return self.imageView.image;
}

- (void)setImageBackgroundColor:(UIColor *)imageBackgroundColor
{
    self.imageView.backgroundColor = imageBackgroundColor;
}

- (void)setImage:(UIImage *)image
{
    self.imageView.image = image;
    self.imageView.backgroundColor = [UIColor artsyBackgroundColor];
    [self updateBadgePosition];
}

- (void)setAspectRatio:(CGFloat)aspectRatio
{
    _aspectRatio = aspectRatio;
    [self setContentInsetX:self.insets.width insetY:self.insets.height animated:NO];
}

- (void)setContentInsetX:(CGFloat)insetX insetY:(CGFloat)insetY animated:(BOOL)animated
{
    [UIView animateIf:animated duration:ARAnimationQuickDuration:^{
        _insets = CGSizeMake(insetX, insetY);
        CGRect outerRect = CGRectInset(self.bounds, insetX, insetY);
        CGFloat aspectRatio = self.aspectRatio;
        
        // Long
        if (aspectRatio > 1) {
            CGFloat newHeight = outerRect.size.height / aspectRatio;
            self.imageView.frame = CGRectMake(CGRectGetMinX(outerRect),
                                              CGRectGetMinY(outerRect) + (outerRect.size.height / 2) - (newHeight / 2),
                                              CGRectGetWidth(outerRect),
                                              newHeight);
            // Tall
        } else if (aspectRatio < 1) {
            CGFloat newWidth = outerRect.size.width * aspectRatio;
            self.imageView.frame = CGRectMake(CGRectGetMinX(outerRect) + (outerRect.size.width / 2) - (newWidth / 2),
                                              CGRectGetMinY(outerRect),
                                              newWidth,
                                              CGRectGetHeight(outerRect));
        } else {
            self.imageView.frame = outerRect;
        }
    }];
}

- (void)addBadge:(UIImage *)image animated:(BOOL)animated
{
    if (!self.badgeImageView) {
        UIImageView *badgeImageView = [[UIImageView alloc] initWithImage:image];
        self.badgeImageView.hidden = YES;
        [self.imageView addSubview:badgeImageView];
        _badgeImageView = badgeImageView;
    }

    [self updateBadgePosition];
}

- (void)updateBadgePosition
{
    if (!self.imageView.image) return;

    CGRect newFrame = self.imageView.frameForImage;
    self.badgeImageView.center = (CGPoint){CGRectGetMaxX(newFrame), CGRectGetMaxY(newFrame)};
    self.badgeImageView.hidden = NO;
}

- (void)removeBadgeAnimated:(BOOL)animate
{
    [self.badgeImageView removeFromSuperviewAndFadeOutWithDuration:ARAnimationQuickDuration if:animate];
}

@end
