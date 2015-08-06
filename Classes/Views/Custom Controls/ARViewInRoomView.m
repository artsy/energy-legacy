#import "ARViewInRoomView.h"

#define DEBUG_VIEW_IN_ROOM 0

static NSString *RoomImageFormat = @"larger";
static float BaseScale = 413 / 144.f; // width of bench in px / width of bench in inches

static const CGFloat ShadowRadius = 4.0f;
static const CGFloat ShadowOpacity = 0.3f;

static const NSInteger NumberOfRooms = 3;

// As we have three rooms at the minute each number in the
// arrays below represents the room as it gets larger
static const CGFloat ArtworkZoomScalesForRoom[] = {1, 1.5, 2.75};

// Size limits in inches
int const ARViewInRoomXLargeRoomLimit = 341;

static CGFloat ArtworkMaxWidthForPortraitRoom[] = {85, 154, 341};
static CGFloat ArtworkMaxHeightForPortraitRoom[] = {100, 154, 341};

static CGFloat ArtworkMaxWidthForLandscapeRoom[] = {85, 201, 341};
static CGFloat ArtworkMaxHeightForLandscapeRoom[] = {85, 135, 341};


// All of the below are in PX, and go from smallest room to biggest

// The minimum distance is the closest point the artwork can come to the ground,
// from there it will scale upwards with the bottom aligned to this line
static const CGFloat ArtworkMinDistanceToBench[] = {70, 52, 38};

// The Eyeline level is the point at which we will vertically center the artwork
// unless it's too tall that it touches the minimum distance above
static const CGFloat ArtworkEyelineLevelFromBench[] = {275, 220, 110};

static const CGFloat DistanceToTopOfBenchPortrait[] = {360, 348, 342};
static const CGFloat DistanceToTopOfBenchLandscape[] = {200, 192, 178};

static const CGFloat PhoneDistanceToTopOfBenchPortrait[] = {360, 348, 342};
static const CGFloat PhoneDistanceToTopOfBenchLandscape[] = {200, 192, 178};


@interface ARViewInRoomView () {
    UILabel *debugLabel;
    UIView *debugEyelineView;
    UIView *debugMinimumArtworkView;
}

- (void)setBackgroundView;

- (BOOL)artworkFrameIsBelowMinimumDistance:(CGRect)frame;

- (CGFloat)artworkMinimumDistanceToBottom;

- (CGFloat)artworkEyelineLevel;

- (void)setupDebug;

- (void)updateDebugViews;
@end


@implementation ARViewInRoomView

@synthesize artwork;
@synthesize roomOrientation;

- (void)awakeFromNib
{
    backgroundImageView = [[UIImageView alloc] initWithFrame:self.frame];
    backgroundImageView.contentMode = UIViewContentModeBottom;
    backgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    backgroundImageView.backgroundColor = [UIColor blackColor];
    self.backgroundColor = [UIColor blackColor];
    [self addSubview:backgroundImageView];
}

- (void)setArtwork:(Artwork *)anArtwork
{
    artwork = anArtwork;
    [self setRoomSize];
    [self setBackgroundView];

    artworkImageView = [[UIImageView alloc] init];
    [artworkImageView setupWithImage:artwork.mainImage format:RoomImageFormat];

    artworkImageView.contentMode = UIViewContentModeScaleAspectFit;
    artworkImageView.backgroundColor = [UIColor clearColor];

    CALayer *layer = [artworkImageView layer];
    layer.shadowOffset = CGSizeMake(0, ShadowRadius);
    layer.shadowOpacity = ShadowOpacity;
    layer.shadowColor = [[UIColor blackColor] CGColor];
    artworkImageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin |
        UIViewAutoresizingFlexibleRightMargin;

#if DEBUG_VIEW_IN_ROOM
    [self setupDebug];
#endif

    [self addSubview:artworkImageView];
}

- (void)setRoomSize
{
    int w = [artwork.width intValue];
    int h = [artwork.height intValue];
    int d = [artwork.diameter intValue];

    BOOL iPadIsPortrait = UIInterfaceOrientationIsPortrait(roomOrientation);
    CGFloat longestEdge;
    BOOL artworkIsPortrait;
    if (d > 0) {
        artworkIsPortrait = NO;
        longestEdge = d;
    } else {
        artworkIsPortrait = w > h;
        longestEdge = (artworkIsPortrait) ? w : h;
    }

    CGFloat *maxRoomSizes;
    if (iPadIsPortrait) {
        maxRoomSizes = (artworkIsPortrait) ? ArtworkMaxWidthForPortraitRoom : ArtworkMaxHeightForPortraitRoom;
    } else {
        maxRoomSizes = (artworkIsPortrait) ? ArtworkMaxWidthForLandscapeRoom : ArtworkMaxHeightForLandscapeRoom;
    }

    for (enum ARViewInRoomRoomSize i = ARViewInRoomRoomSizeSmall; i < NumberOfRooms; i++) {
        if (longestEdge < maxRoomSizes[i]) {
            roomSize = i;
            break;
        }
    }
}

- (void)setRoomOrientation:(UIInterfaceOrientation)newOrientation
{
    roomOrientation = newOrientation;
    [self setRoomSize];
    [self setBackgroundView];
}

- (UIInterfaceOrientation)roomOrientation
{
    return roomOrientation;
}

- (void)setBackgroundView
{
    NSString *orientation;
    if (UIInterfaceOrientationIsLandscape(roomOrientation)) {
        orientation = @"Landscape";
    } else {
        orientation = @"Portrait";
    }

    NSString *imageAddress;
    switch (roomSize) {
        case ARViewInRoomRoomSizeSmall:
            imageAddress = [NSString stringWithFormat:@"RoomWood%@1x.jpg", orientation];
            break;
        case ARViewInRoomRoomSizeLarge:
            imageAddress = [NSString stringWithFormat:@"RoomWood%@2x.jpg", orientation];
            break;
        case ARViewInRoomRoomSizeXLarge:
            imageAddress = [NSString stringWithFormat:@"RoomWood%@3x.jpg", orientation];
            break;
        default:
            break;
    }
    UIImage *image = [UIImage imageNamed:imageAddress];
    backgroundImageView.image = image;
}

- (void)layoutSubviews
{
    float scale = BaseScale;
    float modifier = ArtworkZoomScalesForRoom[roomSize];
    scale /= modifier;
    float artworkWidth = [artwork.width floatValue];
    float artworkHeight = [artwork.height floatValue];
    float artworkDiameter = [artwork.diameter floatValue];
    float scaledWidth;
    float scaledHeight;
    if (artworkDiameter > 0) {
        scaledWidth = scaledHeight = floorf(artworkDiameter * scale);
    } else {
        scaledWidth = floorf(artworkWidth * scale);
        scaledHeight = floorf(artworkHeight * scale);
    }

    if (artworkImageView) {
        CGRect frame = artworkImageView.frame;
        frame.size.width = scaledWidth;
        frame.size.height = scaledHeight;
        frame.origin.x = floorf((CGRectGetWidth(self.bounds) - scaledWidth) * .5f);
        frame.origin.y = floorf(CGRectGetHeight(self.bounds) - [self artworkEyelineLevel] - (scaledHeight * .5f));

        if (frame.origin.y < 0 || [self artworkFrameIsBelowMinimumDistance:frame]) {
            frame.origin.y = CGRectGetHeight(self.bounds) - [self artworkMinimumDistanceToBottom] - scaledHeight;
        }

#if DEBUG_VIEW_IN_ROOM
        [self updateDebugViews];
#endif

        artworkImageView.frame = frame;
    }

    /// HACK
    if (![UIDevice isPad]) {
        artworkImageView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.6, 0.6);
        backgroundImageView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.6, 0.6);

        artworkImageView.center = CGPointMake(artworkImageView.center.x, artworkImageView.center.y + 160);
        backgroundImageView.center = CGPointMake(backgroundImageView.center.x, backgroundImageView.center.y + 120);
    }
}

- (BOOL)artworkFrameIsBelowMinimumDistance:(CGRect)frame
{
    return (CGRectGetMaxY(frame) > CGRectGetHeight(self.bounds) - [self artworkMinimumDistanceToBottom]);
}

- (CGFloat)artworkMinimumDistanceToBottom
{
    return [self distanceToTopOfBench] + ArtworkMinDistanceToBench[roomSize];
}

- (CGFloat)artworkEyelineLevel
{
    return [self distanceToTopOfBench] + ArtworkEyelineLevelFromBench[roomSize];
}

- (CGFloat)distanceToTopOfBench
{
    BOOL isPortrait = UIInterfaceOrientationIsPortrait(roomOrientation);
    if (isPortrait) {
        return ([UIDevice isPad]) ? DistanceToTopOfBenchPortrait[roomSize] : PhoneDistanceToTopOfBenchPortrait[roomSize];
    }
    return ([UIDevice isPad]) ? DistanceToTopOfBenchLandscape[roomSize] : PhoneDistanceToTopOfBenchLandscape[roomSize];
}

+ (BOOL)canShowArtwork:(Artwork *)artwork
{
    int w = [artwork.width intValue];
    int h = [artwork.height intValue];
    int theMax = MAX(w, h);
    BOOL hasDimensions = ((w > 0) && (h > 0));
    BOOL hasDepthOrDiameter = artwork.depth.boolValue || artwork.diameter.boolValue;

    return hasDimensions && !hasDepthOrDiameter && theMax <= ARViewInRoomXLargeRoomLimit;
}

#pragma mark -
#pragma mark Visual Debugging tools

- (void)setupDebug
{
    debugLabel = [[UILabel alloc] init];
    debugLabel.frame = self.bounds;
    debugLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:debugLabel];

    CGRect line = self.frame;
    line.size.height = 1;

    debugEyelineView = [[UIView alloc] initWithFrame:line];
    debugEyelineView.backgroundColor = [UIColor redColor];
    [self addSubview:debugEyelineView];

    debugMinimumArtworkView = [[UIView alloc] initWithFrame:line];
    debugMinimumArtworkView.backgroundColor = [UIColor greenColor];
    [self addSubview:debugMinimumArtworkView];
}

- (void)updateDebugViews
{
    CGRect newframe = debugMinimumArtworkView.frame;

    newframe.origin.y = CGRectGetHeight(self.bounds) - [self artworkMinimumDistanceToBottom];
    debugMinimumArtworkView.frame = newframe;

    newframe.origin.y = CGRectGetHeight(self.bounds) - [self artworkEyelineLevel];
    debugEyelineView.frame = newframe;

    debugLabel.text = [NSString stringWithFormat:@"%@ - room %@", artwork.dimensions, @(roomSize)];

    artworkImageView.backgroundColor = [UIColor blueColor];
}

@end
