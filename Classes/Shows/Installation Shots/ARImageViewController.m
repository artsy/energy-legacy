#import "ARImageViewController.h"
#import <ARTiledImageView/ARTiledImageScrollView.h>
#import "ARTiledImageDataSourceWithImage.h"
#import "InstallShotImage.h"


@interface ARImageViewController ()
@property (nonatomic, weak) ARTiledImageScrollView *view;
@property (nonatomic, strong) ARTiledImageDataSourceWithImage *dataSource;

@end


@implementation ARImageViewController
@dynamic view;

- (instancetype)initWithImage:(Image *)image
{
    self = [super init];
    if (!self) return nil;

    _image = image;

    return self;
}

- (void)loadView
{
    // Exclude Install Shots because they are never classed as having their image as being processed
    if (self.image.processingValue && ![self.image isKindOfClass:InstallShotImage.class]) {
        ARSerifLabel *processingNote = [[ARSerifLineHeightLabel alloc] initWithLineSpacing:14];

        processingNote.textColor = [UIColor artsyForegroundColor];
        processingNote.backgroundColor = [UIColor artsyBackgroundColor];
        processingNote.text = @"This image is still processing,\nplease see CMS for more information.";
        processingNote.textAlignment = NSTextAlignmentCenter;
        processingNote.numberOfLines = 0;
        [processingNote sizeToFit];
        self.view = processingNote;

    } else {
        self.dataSource = [[ARTiledImageDataSourceWithImage alloc] initWithImage:self.image];

        ARTiledImageScrollView *tiledView = [[ARTiledImageScrollView alloc] initWithFrame:self.parentViewController.view.bounds];
        tiledView.decelerationRate = UIScrollViewDecelerationRateFast;
        tiledView.showsHorizontalScrollIndicator = NO;
        tiledView.showsVerticalScrollIndicator = NO;
        tiledView.contentMode = UIViewContentModeScaleAspectFit;
        tiledView.dataSource = self.dataSource;

        NSString *detailLevel = ARFeedImageSizeLargerKey;
        if ([self.image hasLocalImageForFormat:detailLevel]) {
            tiledView.backgroundImage = [self.image imageWithFormatName:detailLevel];
        } else {
            tiledView.backgroundImageURL = [self.image imageURLWithFormatName:detailLevel];
        }

        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [tiledView addGestureRecognizer:tapGesture];
        [tapGesture requireGestureRecognizerToFail:tiledView.doubleTapGesture];

        self.view = tiledView;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    if ([self.view respondsToSelector:@selector(zoomToFit:)]) {
        [self.view zoomToFit:NO];
    }
}

- (void)tap:(UITapGestureRecognizer *)tap
{
    [[NSNotificationCenter defaultCenter] postNotificationName:ARToggleArtworkInfoNotification object:nil];
}

@end
