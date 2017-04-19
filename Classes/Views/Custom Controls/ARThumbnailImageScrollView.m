#import "ARThumbnailImageScrollView.h"
#import "UIImageView+ArtsySetURL.h"

static CGFloat ThumbnailMargin = 8;
static CGFloat ThumbnailSize = 40;
static CGFloat yOffset = 15;


@implementation ARThumbnailImageScrollView

- (void)awakeFromNib
{
    [super awakeFromNib];
    CGRect newFrame = self.frame;
    newFrame.size.height = ThumbnailSize + ThumbnailMargin * 2;
    self.frame = newFrame;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;

    self.backgroundColor = [UIColor whiteColor];
    return self;
}

- (void)setNeedsLayout
{
    [super setNeedsLayout];

    CGFloat xOffset = ThumbnailMargin;
    [self.subviews.reverseObjectEnumerator.allObjects makeObjectsPerformSelector:@selector(removeFromSuperview)];

    for (Image *image in self.images) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(xOffset, yOffset, ThumbnailSize, ThumbnailSize)];
        [imageView setupWithImage:image format:ARFeedImageSizeSquareKey];
        imageView.tag = [self.images indexOfObject:image];

        [self addSubview:imageView];

        xOffset += ThumbnailMargin + ThumbnailSize;
    }

    self.contentSize = CGSizeMake(xOffset, ThumbnailMargin * 2 + ThumbnailSize);
}

- (void)setImages:(NSArray *)images
{
    _images = images.copy;
    [self setNeedsLayout];
}

- (void)drawRect:(CGRect)rect
{
    if (!_borderColor) {
        [super drawRect:rect];
    } else {
        CGContextRef context = UIGraphicsGetCurrentContext();
        [[UIColor whiteColor] setFill];
        CGContextFillRect(context, rect);

        CGContextSetLineWidth(context, [[UIScreen mainScreen] scale] * 4);
        CGContextSetStrokeColorWithColor(context, _borderColor.CGColor);
        CGContextAddRect(context, rect);
        CGContextStrokePath(context);
    }
}

- (void)setBorderColor:(UIColor *)borderColor
{
    _borderColor = borderColor;
    [self setNeedsDisplay];
}

@end
