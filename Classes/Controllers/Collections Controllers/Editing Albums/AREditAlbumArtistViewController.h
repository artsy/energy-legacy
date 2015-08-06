#import "ARGridView.h"

@class Artist;


@interface AREditAlbumArtistViewController : UIViewController <ARGridViewDelegate>

- (instancetype)initWithArtist:(Artist *)artist;

@property (nonatomic, strong, readonly) Artist *artist;

/// Select / Deselect all items
- (void)toggleAllSelection;
- (void)selectItem:(Artwork *)artwork;
- (void)deselectAllItems;

/// Commit the selection to the album
- (void)saveChanges;

/// How many items were selected when showing this VC?
- (NSInteger)selectedInThisSessionCount;
@end
