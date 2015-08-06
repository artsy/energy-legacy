typedef NS_ENUM(NSUInteger, ARArtworkSortOrder) {
    ARArtworksSortOrderDefault,
    ARArtworksSortOrderMedium,
    ARArtworksSortOrderAlphabetic,
    ARArtworksSortOrderDate,
    ARArtworksSortOrderArtistTitle,
    ARArtworksSortOrderArtistDate,
    ARArtworksSortOrderArtistMedium,
    ARArtworksSortOrderNotFound
};

@protocol ARArtworkContainer <NSObject>

- (NSFetchRequest *)sortedArtworksFetchRequest;

- (NSFetchRequest *)artworksFetchRequestSortedBy:(ARArtworkSortOrder)order;

- (NSArray *)availableSorts;

- (NSUInteger)collectionSize;

- (NSString *)slug;

- (Artwork *)firstArtwork;
@end
