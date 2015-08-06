#import "ARTabbedViewController.h"


@interface ARAlbumViewController : ARTabbedViewController

- (instancetype)initWithAlbum:(Album *)album;

- (void)toggleSelectMode;
- (void)setSelecting:(BOOL)selected animated:(BOOL)animated;

- (void)removeSelectedItems:(id)sender;

@end
