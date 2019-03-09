@protocol ARGridViewItem <NSObject>

/// Used by an Artwork specifically
- (NSAttributedString *)attributedGridSubtitle;

@required
/// Used as key for caching titles/subtitles/images
- (NSString *)tempId;

/// The avant garde text
- (NSString *)gridTitle;
/// The italic underlaying text
- (NSString *)gridSubtitle;

/// For local access of the image from a path etc
- (NSString *)gridThumbnailPath:(NSString *)size;
/// For remote access of an image
- (NSURL *)gridThumbnailURL:(NSString *)size;

/// To ensure the thumbnail is the right size
- (float)aspectRatio;

/// Used for routing
- (NSString *)slug;

@end
