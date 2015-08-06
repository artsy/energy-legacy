

@interface ARModernEmailArtworksViewControllerDataSource : NSObject

/// Sorts all related show documents
- (NSArray *)sortedArrayOfRelatedShowDocumentContainersForArtworks:(NSArray *)artworks documents:(NSArray *)documents;

/// Gets all the related show documents for Artworks or Documents
- (NSArray *)arrayOfRelatedShowDocumentContainersForArtworks:(NSArray *)artworks documents:(NSArray *)documents;

/// Checks to see if you need to show an artwork info section
- (BOOL)shouldShowArtworkInfoSection:(NSArray *)artworks;

/// Checks for there being 1 artwork, and whether it has additional images
- (BOOL)artworksShouldShowAdditionalImages:(NSArray *)artworks;

/// Checks if any artworks have a price
- (BOOL)artworksShouldShowPrice:(NSArray *)artworks;

/// Are there backend prices that are different from display_prices in the artworks
- (BOOL)artworksShouldShowBackendPrice:(NSArray *)artworks;

/// Checks if any artworks have supplementary info
- (BOOL)artworksShouldShowSupplementaryInfo:(NSArray *)artworks;

/// Checks if any artworks have an Inventory ID
- (BOOL)artworksShouldShowInventoryID:(NSArray *)artworks;

/// Checks if all artworks are in one show, and that that show has installation shots
/// takes a context, like a show or an album that is prioritised for installation shots
- (BOOL)artworksShouldShowInstallShots:(NSArray *)artworks context:(ARManagedObject *)context;

/// Returns the installation shots for a collection of artworks
/// takes a context, like a show or an album that is prioritised for installation shots
- (NSArray *)installationShotsForArtworks:(NSArray *)artworks context:(ARManagedObject *)context;

@end
