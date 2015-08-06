#import "ARArtworkMetadataView.h"
#import "ARArtworkMetadataStack.h"


@interface ARArtworkMetadataView ()

@end


@implementation ARArtworkMetadataView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;

    _maxAllowedInputs = 4;
    _maximumAmountOfLines = 2;
    self.backgroundColor = [[UIColor artsyBackgroundColor] colorWithAlphaComponent:0.5];
    self.accessibilityTraits = UIAccessibilityTraitButton;
    self.accessibilityIdentifier = @"Artwork Metadata";

    return self;
}

- (void)didMoveToSuperview
{
    // iOS8 calls this when a view is leaving the superview sometimes
    if (self.superview) {
        [self alignLeading:@"0" trailing:@"0" toView:self.superview];
        [self alignBottomEdgeWithView:self.superview predicate:@"0"];
    }
}

- (void)setStrings:(NSArray *)strings
{
    strings = [strings reject:^BOOL(id object) {
        return object == NSNull.null;
    }];

    strings = [strings subarrayWithRange:NSMakeRange(0, MIN(strings.count, self.maxAllowedInputs))];

    [self.subviews.copy makeObjectsPerformSelector:@selector(removeFromSuperview)];

    ARArtworkMetadataStack *stackView = [[ARArtworkMetadataStack alloc] init];
    stackView.textAlignment = NSTextAlignmentLeft;
    [self addSubview:stackView];
    [stackView setStrings:strings];

    [stackView alignTopEdgeWithView:self predicate:@"0"];
    [stackView alignBottomEdgeWithView:self predicate:@"0"];

    [stackView alignLeadingEdgeWithView:self predicate:@"20"];

    if (!self.needsIndicator) {
        [stackView alignTrailingEdgeWithView:self predicate:@"-18"];

    } else {
        UIImage *arrowImage = [[UIImage imageNamed:@"AdditionalInfoArrow"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:arrowImage];
        imageView.tintColor = [UIColor artsyForegroundColor];

        [imageView setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisVertical];
        [imageView setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
        [self addSubview:imageView];

        [imageView alignCenterYWithView:self predicate:@"0"];

        if (self.additionalImages > 0) {
            UIPageControl *pageControl = [[UIPageControl alloc] init];
            pageControl.numberOfPages = self.additionalImages;
            pageControl.currentPage = -1;
            pageControl.pageIndicatorTintColor = [UIColor artsyForegroundColor];
            pageControl.currentPageIndicatorTintColor = [UIColor artsyForegroundColor];
            pageControl.userInteractionEnabled = NO;

            [self addSubview:pageControl];

            [pageControl alignCenterXWithView:imageView predicate:@"0"];
            [pageControl constrainTopSpaceToView:imageView predicate:@"-8"];
        }

        [imageView alignTrailingEdgeWithView:self predicate:@"-18"];
        [stackView alignAttribute:NSLayoutAttributeTrailing toAttribute:NSLayoutAttributeLeading ofView:imageView predicate:@"-10"];
    }
}

@end
