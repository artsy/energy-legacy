#import <DRBOperationTree/DRBOperationTree.h>

@class ARSyncProgress;


@interface ARTileArchiveDownloader : NSObject <DRBOperationProvider>
- (instancetype)initWithProgress:(ARSyncProgress *)progress;

- (void)writeSlugs;

- (NSSet *)imagesWithTiles:(NSSet *)images downloadedSlugs:(NSSet *)downloadedSlugs;
@end
