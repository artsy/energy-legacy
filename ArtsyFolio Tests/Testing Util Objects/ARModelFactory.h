// This is really just some stubs before FactoryGentlemen gets NSManagedObject support


@interface ARModelFactory : NSObject

+ (Artwork *)fullArtworkInContext:(NSManagedObjectContext *)context;
+ (Artwork *)partiallyFilledArtworkInContext:(NSManagedObjectContext *)context;
+ (Artwork *)fullArtworkWithEditionsInContext:(NSManagedObjectContext *)context;

+ (Artist *)filledArtistInContext:(NSManagedObjectContext *)context;

+ (void)addLocalImagesToArtwork:(Artwork *)artwork;
+ (Image *)imageWithKnownRemoteResourcesInContext:(NSManagedObjectContext *)context;

+ (User *)createCurrentUserInContext:(NSManagedObjectContext *)context;
@end
