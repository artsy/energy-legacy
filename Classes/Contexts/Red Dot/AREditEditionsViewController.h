#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class ARPopoverController;


@interface AREditEditionsViewController : UITableViewController

@property (readonly) Artwork *artwork;

- (instancetype)initWithArtwork:(Artwork *)artwork popover:(ARPopoverController *)popover;

@end

NS_ASSUME_NONNULL_END
