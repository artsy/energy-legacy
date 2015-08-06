#import "ARArtworkMetadataExtendedView.h"
#import "ARArtworkMetadataStack.h"
#import "ARArtworkMetadataView.h"


@implementation ARArtworkMetadataExtendedView

- (void)didMoveToSuperview
{
    self.backgroundColor = [[UIColor artsyBackgroundColor] colorWithAlphaComponent:0.5];

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

    [self.subviews.copy makeObjectsPerformSelector:@selector(removeFromSuperview)];

    if (strings.count < 4) {
        [self setupSingleColumnForStrings:strings];
    } else {
        [self setupDoubleColumnForStrings:strings];
    }
}

static CGFloat ARNoLimit = 0;

- (void)setupSingleColumnForStrings:(NSArray *)strings
{
    ARArtworkMetadataView *metadataView = [[ARArtworkMetadataView alloc] initWithFrame:self.bounds];
    [self addSubview:metadataView];
    [self alignTopEdgeWithView:metadataView predicate:@"0"];

    metadataView.backgroundColor = [UIColor clearColor];
    metadataView.maxAllowedInputs = 3;
    metadataView.additionalImages = self.additionalImages;
    metadataView.needsIndicator = self.needsIndicator;
    metadataView.maximumAmountOfLines = self.constrainedVerticalSpace ? 2 : ARNoLimit;
    [metadataView setStrings:strings];
}

- (void)setupDoubleColumnForStrings:(NSArray *)strings
{
    NSArray *firstHalf = [strings subarrayWithRange:NSMakeRange(0, 3)];
    NSArray *lastHalf = [strings subarrayWithRange:NSMakeRange(3, strings.count - 3)];

    ARArtworkMetadataStack *leftStackView = [[ARArtworkMetadataStack alloc] init];
    leftStackView.textAlignment = NSTextAlignmentLeft;
    leftStackView.maximumAmountOfLines = self.constrainedVerticalSpace ? 2 : ARNoLimit;

    [self addSubview:leftStackView];
    [leftStackView setStrings:firstHalf];

    [leftStackView alignTopEdgeWithView:self predicate:@"0"];
    [leftStackView alignBottomEdgeWithView:self predicate:@"0"];
    [leftStackView alignLeadingEdgeWithView:self predicate:@"20"];

    ARArtworkMetadataStack *rightStackView = [[ARArtworkMetadataStack alloc] init];
    rightStackView.textAlignment = NSTextAlignmentRight;
    rightStackView.maximumAmountOfLines = self.constrainedVerticalSpace ? 2 : ARNoLimit;

    [self addSubview:rightStackView];
    [rightStackView setStrings:lastHalf];

    [rightStackView alignTopEdgeWithView:self predicate:@"0"];
    [rightStackView alignBottomEdgeWithView:self predicate:@"0"];
    [rightStackView alignTrailingEdgeWithView:self predicate:@"-20"];

    if (!self.needsIndicator) {
        [leftStackView constrainWidthToView:self predicate:@"==*.45@1000"];
        [rightStackView constrainWidthToView:self predicate:@"==*.45@1000"];

    } else {
        UIImage *arrowImage = [[UIImage imageNamed:@"AdditionalInfoArrow"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:arrowImage];
        imageView.tintColor = [UIColor artsyForegroundColor];
        [imageView setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisVertical];
        [imageView setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
        [self addSubview:imageView];

        if (self.additionalImages > 0) {
            UIPageControl *pageControl = [[UIPageControl alloc] init];
            pageControl.numberOfPages = self.additionalImages;
            pageControl.currentPage = -1;
            pageControl.pageIndicatorTintColor = [UIColor artsyForegroundColor];
            pageControl.currentPageIndicatorTintColor = [UIColor artsyForegroundColor];
            pageControl.userInteractionEnabled = NO;

            [self addSubview:pageControl];

            [pageControl alignCenterXWithView:imageView predicate:@"0"];
            [pageControl constrainTopSpaceToView:imageView predicate:@"-4"];
        }

        [imageView alignCenterWithView:self];
        [leftStackView alignAttribute:NSLayoutAttributeTrailing toAttribute:NSLayoutAttributeLeading ofView:imageView predicate:@"-10@1000"];
        [rightStackView alignAttribute:NSLayoutAttributeLeading toAttribute:NSLayoutAttributeTrailing ofView:imageView predicate:@"10@1000"];
    }
}

@end
