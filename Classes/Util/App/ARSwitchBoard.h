@class Document, ARAlbumEditNavigationController, ARManagedObject, JLRoutes;


@interface ARSwitchBoard : NSObject

/// A default switchboard that uses the main managed object context, and the ARNavigation rootController
+ (ARSwitchBoard *)sharedSwitchboard;

/// Init
- (instancetype)initWithNavigationController:(UINavigationController *)controller context:(NSManagedObjectContext *)context;

/// Routing object
- (JLRoutes *)router;

/// Adds an ArtistVC to the nav controller
- (void)pushArtistViewController:(Artist *)artist animated:(BOOL)animates;

/// Sets up the navigation controller stack to be the RootVC then a ArtistVC
- (void)jumpToArtistViewController:(Artist *)artist animated:(BOOL)animates;

/// Adds a ShowViewController to the nav controller
- (void)pushShowViewController:(Show *)show animated:(BOOL)animates;

/// Sets up the navigation controller stack to be the RootVC then a ShowVC
- (void)jumpToShowViewController:(Show *)show animated:(BOOL)animates;

/// Adds a Location controller to the nav
- (void)pushLocationView:(Location *)location animated:(BOOL)animates;

/// Adds an Edit Album VC to the navigation controller
- (ARAlbumEditNavigationController *)pushEditAlbumViewController:(Album *)album animated:(BOOL)animates;

/// Adds an AlbumVC to the navigation controller
- (void)pushAlbumViewController:(Album *)album animated:(BOOL)animates;

/// Sets up the navigation controller stack to be the RootVC then an AlbumVC
- (void)jumpToAlbumViewController:(Album *)album animated:(BOOL)animates;

/// Adds a set of views for documents to the navigation controller
- (void)pushDocumentSet:(NSArray<Document *> *)documents index:(NSInteger)index animated:(BOOL)animates;

/// Adds a set of views for paging though Images to the navigation controller
- (void)pushImageViews:(NSArray *)images index:(NSInteger)index animated:(BOOL)animates;

/// Sets up the navigation controller stack to be the RootVC then an ArtistVC then a ArtworkVC
- (void)jumpToArtworkViewController:(Artwork *)artwork context:(NSManagedObjectContext *)context;

/// Pushes an ArtworkVC to the nav controller at a specific index in the paging view.
- (void)pushArtworkViewControllerWithArtworks:(NSFetchedResultsController *)artworks atIndex:(NSInteger)index representedObject:(ARManagedObject *)representedObject;

//-- Really only useful for Developer speed --//

/// Sets up the navigation controller stack to be the RootVC then an ArtistVC then a ArtworkVC for an artwork is said ID
- (void)jumpToArtworkViewControllerWithArtworkName:(NSString *)artworkID inContext:(NSManagedObjectContext *)context;

/// Sets up the navigation controller stack to be the RootVC then an a ShowVC with said ID
- (void)jumpToShowViewControllerWithShowName:(NSString *)showName inContext:(NSManagedObjectContext *)context;

/// Jump to a specific location view controller
- (void)jumpToLocationViewController:(Location *)location animated:(BOOL)animates;

@end
