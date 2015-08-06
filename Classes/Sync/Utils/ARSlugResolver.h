

@interface ARSlugResolver : NSObject


/// Takes the `artworkSlugs` from a class, and looks up each artwork
/// via the slug and then sets the relationship with found objects

- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext *)context;

/// Calls all "resolve slug" methods
- (void)resolveAllSlugs;

/// Loops through all Albums, hooking up the required artworks
- (void)resolveSlugsForAlbums;

/// Loops through all Shows, hooking up the required artworks
- (void)resolveSlugsForShows;

/// Loops through all Locations, hooking up the required artworks
- (void)resolveSlugsForLocations;

@end
