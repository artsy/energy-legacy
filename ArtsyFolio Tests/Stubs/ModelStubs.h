

@interface Artwork (Stubs)

+ (Artwork *)stubbedArtworkWithImages:(BOOL)hasImages inContext:(NSManagedObjectContext *)context;

@end


@interface Artist (Stubs)

+ (Artist *)stubbedArtistWithPublishedArtworks:(BOOL)isPublished inContext:(NSManagedObjectContext *)context;

@end


@interface Album (Stubs)

+ (Album *)stubbedAlbumWithPublishedArtworks:(BOOL)isPublished inContext:(NSManagedObjectContext *)context;

@end
