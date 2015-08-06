#import <Foundation/Foundation.h>

/// Centralises the logic aorund potential sort orders
/// for artwork containers


@interface ARSortOrderHost : NSObject

/// Default sorts available for artwork containers without including an Artist
+ (NSArray *)defaultSortsWithoutArtist;

/// Default sorsts for an artwork container
+ (NSArray *)defaultSorts;

/// Descriptors when you cannot use an Artist, e.g. if you are an artist
+ (NSArray *)sortDescriptorsWithoutArtistWithOrder:(ARArtworkSortOrder)order;

/// Descriptors including artists, e.g. Shows/Locations/Albums
+ (NSArray *)sortDescriptorstWithOrder:(ARArtworkSortOrder)order;

@end
