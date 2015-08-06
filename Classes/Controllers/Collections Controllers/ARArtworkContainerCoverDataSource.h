#import "ARArtworkContainer.h"

/// Handles the logic around showing a cover for an artwork container object
/// to the gridview with correct fallbacks


@interface ARArtworkContainerCoverDataSource : NSObject

/// File path for thumbnail of Grid View Item
- (NSString *)gridThumbnailPath:(NSString *)size container:(NSObject<ARArtworkContainer> *)object;

/// External URL for thumbnail of Grid View Item
- (NSURL *)gridThumbnailURL:(NSString *)size container:(NSObject<ARArtworkContainer> *)object;

/// Aspect ratio for the grid view item
- (float)aspectRatioForContainer:(NSObject<ARArtworkContainer> *)object;

@end
