#import "ARThumbnailImageSelectionView.h"
#import "UIImageView+ArtsySetURL.h"

static CGFloat ThumbnailMargin = 8;
static CGFloat ThumbnailSize = 58;
static CGFloat TickMargin = 4;
static CGFloat TickHeight = 20;

static NSString *SelectedImageString = @"Tick";


@interface ARThumbnailImageSelectionView ()
@property (nonatomic, readonly) NSMutableArray *selectedIndexValues;
@end


@implementation ARThumbnailImageSelectionView

- (void)awakeFromNib
{
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
        UIImageView *button = [[UIImageView alloc] initWithFrame:CGRectMake(xOffset, ThumbnailMargin, ThumbnailSize, ThumbnailSize)];
        [button setupWithImage:image format:ARFeedImageSizeSquareKey];
        button.tag = [self.images indexOfObject:image];
        button.userInteractionEnabled = YES;

        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
        [button addGestureRecognizer:tapGesture];
        [self addSubview:button];

        NSNumber *indexNumber = @([self.images indexOfObject:image]);
        if ([self.selectedIndexValues indexOfObject:indexNumber] != NSNotFound) {
            [self addTickToButton:button animated:NO];
        }

        xOffset += ThumbnailMargin + ThumbnailSize;
    }

    self.contentSize = CGSizeMake(xOffset, ThumbnailMargin * 2 + ThumbnailSize);
}

- (void)setImages:(NSArray *)images
{
    _images = images.copy;
    _selectedIndexValues = [NSMutableArray array];
    [self setNeedsLayout];
}

static NSInteger SelectedButtonTag = 2323;

- (void)imageTapped:(UITapGestureRecognizer *)sender
{
    UIView *button = sender.view;
    BOOL wasSelected = NO;
    for (NSInteger i = [self.selectedIndexValues count] - 1; i >= 0; i--) {
        NSNumber *number = self.selectedIndexValues[i];
        if ([number intValue] == button.tag) {
            wasSelected = YES;
            [self.selectedIndexValues removeObject:number];
            [self removeTickFromButton:button animate:YES];
        }
    }

    if (!wasSelected) {
        NSNumber *tag = @(button.tag);
        [self.selectedIndexValues addObject:tag];
        [self addTickToButton:button animated:YES];
    }
}

- (void)addTickToButton:(UIView *)button animated:(BOOL)animate
{
    UIImageView *selectedImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:SelectedImageString]];
    selectedImageView.tag = SelectedButtonTag;
    selectedImageView.frame = CGRectMake(CGRectGetWidth(button.frame) - TickHeight - TickMargin, CGRectGetHeight(button.frame) - TickHeight - TickMargin, TickHeight, TickHeight);
    selectedImageView.alpha = 0;
    [button addSubview:selectedImageView];

    [UIView animateIf:animate duration:ARAnimationDuration:^{
        selectedImageView.alpha = 1;
    }];
}

- (void)removeTickFromButton:(UIView *)button animate:(BOOL)animate
{
    UIView *tick = [button viewWithTag:SelectedButtonTag];

    [UIView animateIf:animate duration:ARAnimationQuickDuration:^{
        tick.alpha = 0;
    } completion:^(BOOL finished) {
        [tick removeFromSuperview];
    }];
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

- (NSIndexSet *)selectedIndexes
{
    NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
    [self.selectedIndexValues each:^(NSNumber *index) {
        [indexSet addIndex:index.unsignedIntValue];
    }];
    return [[NSIndexSet alloc] initWithIndexSet:indexSet];
}

- (void)selectAll
{
    _selectedIndexValues = [NSMutableArray array];
    for (NSInteger i = [_images count] - 1; i >= 0; i--) {
        [self.selectedIndexValues addObject:@(i)];
    }
    [self setNeedsLayout];
}

@end
