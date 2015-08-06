@protocol ARGridViewItem <NSObject>

@required
- (NSString *)tempId;

- (NSString *)gridTitle;
- (NSString *)gridSubtitle;

- (NSString *)gridThumbnailPath:(NSString *)size;
- (NSURL *)gridThumbnailURL:(NSString *)size;

- (float)aspectRatio;

- (NSString *)slug;

@end
