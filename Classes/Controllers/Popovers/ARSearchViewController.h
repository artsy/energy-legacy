#import "ARUnderlinedSwitchView.h"

@class ARSearchViewController, ARPopoverController, ARBrowseProvider;

@protocol ARSearchViewControllerDelegate <NSObject>
@required
- (void)searchViewController:(ARSearchViewController *)aController didSelectAlbum:(Album *)album;
- (void)searchViewController:(ARSearchViewController *)aController didSelectArtist:(Artist *)artist;
- (void)searchViewController:(ARSearchViewController *)aController didSelectArtwork:(Artwork *)artwork;
- (void)searchViewController:(ARSearchViewController *)aController didSelectShow:(Show *)show;
- (void)searchViewController:(ARSearchViewController *)aController didSelectLocation:(Location *)location;
@end


@interface ARSearchViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchDisplayDelegate, UISearchBarDelegate, ARSwitchViewDelegate>

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, weak) id<ARSearchViewControllerDelegate> delegate;
@property (nonatomic, weak) id selectedItem;
@property (nonatomic, assign) enum ARDisplayMode displayMode;

/// Provides the data for the model browsing aspect of the SearchVC
@property (nonatomic, readonly) ARBrowseProvider *browseProvider;

@property (weak) ARPopoverController *hostController;

+ (ARSearchViewController *)sharedController;

/// Reloads the search or browse view
- (void)reloadSearchResults;

/// Queries the managed object context for a string
- (void)performSearchForText:(NSString *)query;

/// Search results
- (NSArray *)searchResults;

/// Resets the UI from a search
- (void)reset;
@end
