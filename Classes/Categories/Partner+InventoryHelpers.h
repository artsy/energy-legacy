


@interface Partner (InventoryHelpers)

/// Does the partner have any published works?
- (BOOL)hasPublishedWorks;

/// Dos the partner have any unpublished works?
- (BOOL)hasUnpublishedWorks;

/// Does the partner have any works for sale?
- (BOOL)hasForSaleWorks;

/// Does the partner have works that aren't for sale for any reason?
- (BOOL)hasNotForSaleWorks;

/// Does the partner have sold works? (this is not necessarily the opposite of For Sale)
- (BOOL)hasSoldWorks;

/// Does the partner have any works with prices?
- (BOOL)hasWorksWithPrice;

/// Does the partner have any sold works with prices?
- (BOOL)hasSoldWorksWithPrices;

/// Does the partner have any confidential notes associated with their artworks?
- (BOOL)hasConfidentialNotes;

@end
