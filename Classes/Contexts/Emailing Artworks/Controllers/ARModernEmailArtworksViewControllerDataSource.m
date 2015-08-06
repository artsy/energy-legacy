

@interface NSArray (ORAnyExtends)

- (BOOL)anyObjectsMatch:(BOOL (^)(id object))block;

@end


@implementation NSArray (ORAnyExtends)

- (BOOL)anyObjectsMatch:(BOOL (^)(id object))block
{
    for (id object in self) {
        if (block(object)) {
            return YES;
        }
    }
    return NO;
}

@end

#import "ARModernEmailArtworksViewControllerDataSource.h"


@implementation ARModernEmailArtworksViewControllerDataSource

- (NSArray *)sortedArrayOfRelatedShowDocumentContainersForArtworks:(NSArray *)artworks documents:(NSArray *)documents
{
    NSArray *allDocuments = [self arrayOfRelatedShowDocumentContainersForArtworks:artworks documents:documents];
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@keypath(Artist.new, name) ascending:YES selector:@selector(caseInsensitiveCompare:)];
    return [allDocuments sortedArrayUsingDescriptors:@[ descriptor ]];
}

- (NSArray *)arrayOfRelatedShowDocumentContainersForArtworks:(NSArray *)artworks documents:(NSArray *)documents
{
    // If it's got artworks get containers related to the artworks,
    // otherwise get all the containers for the documents.

    NSArray *results;
    if (artworks.count) {
        results = [[artworks map:^id(Artwork *artwork) {
            NSMutableArray *allContainers = [NSMutableArray array];

            [allContainers addObjectsFromArray:[artwork.shows select:^BOOL(Show *show) {
                return show.sortedDocuments.count > 0;
            }]];

            if (artwork.artist.sortedDocuments.count) {
                [allContainers addObject:artwork.artist];
            }

            return allContainers;
        }] flatten];

    } else {
        NSMutableArray *allContainers = [NSMutableArray array];
        for (Document *document in documents) {
            if (document.show) {
                [allContainers addObject:document.show];
            }
            if (document.artist) {
                [allContainers addObject:document.artist];
            }
        }
        results = allContainers;
    }

    return [NSSet setWithArray:results].allObjects;
}

- (BOOL)shouldShowArtworkInfoSection:(NSArray *)artworks
{
    /// Ordered by most likely to happen
    if ([self artworksShouldShowSupplementaryInfo:artworks]) return YES;
    if ([self artworksShouldShowInventoryID:artworks]) return YES;
    return NO;
}

- (BOOL)artworksShouldShowAdditionalImages:(NSArray *)artworks
{
    return artworks.count == 1 && [artworks.firstObject images].count > 1;
}

- (BOOL)artworksShouldShowPrice:(NSArray *)artworks
{
    return [artworks anyObjectsMatch:^BOOL(Artwork *artwork) {
        return artwork.displayPrice && artwork.displayPrice.length > 1;
    }];
}

- (BOOL)artworksShouldShowBackendPrice:(NSArray *)artworks
{
    return [artworks anyObjectsMatch:^BOOL(Artwork *artwork) {
        return  artwork.backendPrice &&
                artwork.backendPrice.length > 1 &&
               ![artwork.backendPrice isEqualToString:artwork.displayPrice];
    }];
}

- (BOOL)artworksShouldShowSupplementaryInfo:(NSArray *)artworks
{
    return [artworks anyObjectsMatch:^BOOL(Artwork *artwork) {
        return artwork.hasSupplementaryInfo;
    }];
}

- (BOOL)artworksShouldShowInventoryID:(NSArray *)artworks
{
    return [artworks anyObjectsMatch:^BOOL(Artwork *artwork) {
        return artwork.inventoryID.length;
    }];
}

- (BOOL)artworksShouldShowInstallShots:(NSArray *)artworks context:(ARManagedObject *)context
{
    return [self installationShotsForArtworks:artworks context:context].count > 0;
}

- (NSArray *)installationShotsForArtworks:(NSArray *)artworks context:(ARManagedObject *)context
{
    if ([context isKindOfClass:Show.class]) {
        NSArray *images = [[(Show *)context installationImages] allObjects];
        return images.count ? images : nil;
    }

    // All shows, as an array, flattened, then only ones with installation shots

    NSArray *shows = [[[artworks map:^id(Artwork *artwork) {
        return artwork.shows.allObjects;

    }] flatten] select:^BOOL(Show *show) {
        return [show installationImages].count > 0;
    }];

    NSSet *uniqueShows = [NSSet setWithArray:shows];
    if (uniqueShows.count > 1) return nil;
    return [[shows.firstObject installationImages] allObjects];
}

@end
