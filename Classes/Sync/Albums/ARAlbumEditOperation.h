@import Foundation;

@class AlbumUpload, Artwork;

@interface ARAlbumEditOperation : NSOperation

- (instancetype)initWithAlbumUpload:(AlbumUpload *)uploadModel createModel:(BOOL)create toAdd:(NSArray <Artwork *>*)addedArtworks toRemove:(NSArray <Artwork *>*)removedArtworks;

/// Use this to get IDs for objects sent back to you
@property (readwrite, nonatomic, copy) void (^onCompletion)(void);

@property (nonatomic, assign, readonly) BOOL createAlbum;
@property (nonatomic, strong, readonly) AlbumUpload *uploadModel;

@property (nonatomic, copy, readonly) NSArray <Artwork *> *artworksToUpload;
@property (nonatomic, copy, readonly) NSArray <Artwork *> *artworksToRemove;
@end
