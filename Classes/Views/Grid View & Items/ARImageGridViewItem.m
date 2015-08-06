#import "ARImageGridViewItem.h"


@interface ARImageGridViewItem ()
@property (readwrite, nonatomic, weak) id target;
@property (readwrite, nonatomic, assign) SEL action;
@end


@implementation ARImageGridViewItem

- (instancetype)init
{
    self = [super init];
    if (!self) return self;

    _gridTitle = @"TITLE";
    _gridSubtitle = @"SUBTITLE";
    _aspectRatio = 1;
    _imageFilepath = [[NSBundle mainBundle] pathForResource:@"ArtsyMobileIcon@2x" ofType:@"png"];

    return self;
}

+ (instancetype)gridViewButton
{
    ARImageGridViewItem *button = [[self alloc] init];
    [button setIsButton:YES];
    return button;
}

- (void)setIsButton:(BOOL)isButton
{
    _isButton = isButton;
}

- (void)setTarget:(id)target action:(SEL)action
{
    self.target = target;
    self.action = action;
}

- (void)performActionEvent
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

    [self.target performSelector:self.action];

#pragma clang diagnostic pop
}

- (NSString *)tempId
{
    return self.imageFilepath;
}

- (NSString *)gridThumbnailPath:(NSString *)size
{
    return self.imageFilepath;
}

- (NSURL *)gridThumbnailURL:(NSString *)size
{
    return [NSURL fileURLWithPath:self.imageFilepath];
}

- (NSString *)slug
{
    if (self.isButton) {
        return @"grid_view_button";
    }
    return self.gridTitle;
}

@end
