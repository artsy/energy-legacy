#import "ARModernArtworkInfoViewController.h"
#import <ORStackView/ORStackView.h>
#import <ORStackView/ORStackScrollView.h>
#import "ARModernArtworkMetadataViewController.h"
#import "UIViewController+SimpleChildren.h"
#import "ARArtworkInfoAdditionalMetadataView.h"


@interface ARModernArtworkInfoViewController ()
@property (nonatomic, readonly, strong) Artwork *artwork;
@property (nonatomic, readonly, strong) ORStackScrollView *contentView;
@end


@implementation ARModernArtworkInfoViewController

- (instancetype)initWithArtwork:(Artwork *)artwork
{
    self = [super init];
    if (!self) return nil;

    _artwork = artwork;

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    ORStackScrollView *stackScrollView = [[ORStackScrollView alloc] init];

    stackScrollView.backgroundColor = [UIColor artsyBackgroundColor];
    stackScrollView.stackView.backgroundColor = [UIColor artsyBackgroundColor];
    stackScrollView.stackView.bottomMarginHeight = 20;
    stackScrollView.alwaysBounceVertical = YES;

    _contentView = stackScrollView;
    [self.view addSubview:stackScrollView];

    UIImageView *imageView = [self returnImageView];
    [self.view addSubview:imageView];

    [imageView alignTop:@"0" leading:@"0" bottom:nil trailing:@"0" toView:self.view];
    [imageView constrainHeight:@"64"];

    [stackScrollView constrainTopSpaceToView:imageView predicate:@"0"];
    [stackScrollView alignLeading:@"0" trailing:@"0" toView:self.view];
    [stackScrollView alignBottomEdgeWithView:self.view predicate:@"0"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateWithArtwork:self.artwork];
}

- (void)updateWithArtwork:(Artwork *)artwork
{
    UIView *wrapper = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 64)];

    ARModernArtworkMetadataViewController *info = [[ARModernArtworkMetadataViewController alloc] init];
    info.constrainedVerticalSpace = NO;
    info.constrainedHorizontalSpace = ![UIDevice isPad];
    info.hideIndicator = YES;

    [self ar_addModernChildViewController:info intoView:wrapper];
    info.artwork = artwork;

    [wrapper constrainHeightToView:info.view predicate:@"0"];
    [self.contentView.stackView addSubview:wrapper withTopMargin:@"20" sideMargin:@"0"];

    UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    separator.backgroundColor = [[UIColor artsyForegroundColor] colorWithAlphaComponent:0.5];
    [self.contentView.stackView addSubview:separator withTopMargin:@"10" sideMargin:@"40"];
    [separator constrainHeight:@"1"];

    ARArtworkInfoAdditionalMetadataView *metadata = nil;
    BOOL split = [UIDevice isPad];
    CGFloat width = CGRectGetWidth(self.view.bounds) - 40;

    metadata = [[ARArtworkInfoAdditionalMetadataView alloc] initWithArtwork:artwork preferredWidth:width split:split];
    [self.contentView.stackView addSubview:metadata withTopMargin:@"20" sideMargin:@"40"];

    [[artwork.sortedImages select:^BOOL(Image *image) {
        return image != artwork.mainImage;

    }] each:^(Image *image) {

        UIImageView *imageView = [self imageViewForImage:image];
        [self.contentView.stackView addSubview:imageView withTopMargin:@"20" sideMargin:@"40"];
        NSLayoutConstraint *aspectRatioConstraint = [self aspectRatioConstraintForImageView:imageView image:image];
        [imageView addConstraint:aspectRatioConstraint];
    }];
}

- (NSLayoutConstraint *)aspectRatioConstraintForImageView:(UIImageView *)imageView image:(Image *)image
{
    CGFloat ratio = (image.maxTiledHeight.floatValue / image.maxTiledWidth.floatValue);
    return [NSLayoutConstraint constraintWithItem:imageView
                                        attribute:NSLayoutAttributeHeight
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:imageView
                                        attribute:NSLayoutAttributeWidth
                                       multiplier:ratio
                                         constant:0];
}

- (UIImageView *)imageViewForImage:(Image *)image
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    [imageView setupWithImage:image format:ARFeedImageSizeLargerKey];
    return imageView;
}

- (UIImageView *)returnImageView
{
    UIImage *arrowImage = [[UIImage imageNamed:@"AdditionalInfoArrow"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:arrowImage];
    imageView.contentMode = UIViewContentModeCenter;
    imageView.tintColor = [UIColor artsyForegroundColor];
    imageView.backgroundColor = [UIColor artsyBackgroundColor];
    imageView.transform = CGAffineTransformRotate(CGAffineTransformIdentity, M_PI);
    imageView.userInteractionEnabled = YES;

    UITapGestureRecognizer *returnTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(callDismiss:)];
    [imageView addGestureRecognizer:returnTapGesture];

    UISwipeGestureRecognizer *returnSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(callDismiss:)];
    returnSwipeGesture.direction = UISwipeGestureRecognizerDirectionUp;
    [imageView addGestureRecognizer:returnSwipeGesture];

    return imageView;
}

- (void)callDismiss:(UITapGestureRecognizer *)gesture
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
