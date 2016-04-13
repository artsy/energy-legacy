#import <AFNetworking/AFJSONRequestOperation.h>
#import "ARAlbumEditOperation.h"
#import "AlbumUpload.h"
#import "ARRouter.h"

@interface ARAlbumEditOperation()
@property (nonatomic, strong, readonly) NSOperationQueue *networkQueue;
@end

@implementation ARAlbumEditOperation {
    BOOL _isFinished;
    BOOL _isExecuting;
}

- (instancetype)initWithAlbumUpload:(AlbumUpload *)uploadModel createModel:(BOOL)create toAdd:(NSArray <Artwork *>*)addedArtworks toRemove:(NSArray <Artwork *>*)removedArtworks
{
    self = [super init];
    if (!self) {
        return  nil;
    }

    _uploadModel = uploadModel;
    _createAlbum = create;
    _artworksToUpload = addedArtworks;
    _artworksToRemove = removedArtworks;

    return self;
}

- (void)start
{
    [self setFinished:NO];
    [self setExecuting:YES];

    _networkQueue = [[NSOperationQueue alloc] init];
    self.networkQueue.maxConcurrentOperationCount = 1;

    NSArray *operations = [self operationsToRun];
    [self.networkQueue addOperations:operations waitUntilFinished:NO];

    NSInvocationOperation *finisherOperation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(wrapup) object:nil];
    [self.networkQueue addOperation:finisherOperation];

}

- (NSArray *)operationsToRun
{
    NSMutableArray *operations = [NSMutableArray array];
    if (self.createAlbum) {
        [operations addObject:[self createAlbumOperation:self.uploadModel.album]];
    }

    [operations addObjectsFromArray:[self.artworksToUpload map:^id(Artwork *artwork) {
        return [self addArtworkOperationForAlbum:self.uploadModel.album artwork:artwork];
    }]];

    [operations addObjectsFromArray:[self.artworksToRemove map:^id(Artwork *artwork) {
        return [self removeArtworkOperationForAlbum:self.uploadModel.album artwork:artwork];
    }]];

    return operations;
}

- (NSString *)partnerID
{
    return [Partner currentPartnerID];
}

- (NSOperation *)createAlbumOperation:(Album *)album
{
    NSURLRequest *request = [ARRouter newPartnerAlbumCreateAlbumRequestWithPartnerID:self.partnerID albumName:album.name];
    return [[AFHTTPRequestOperation alloc] initWithRequest:request];
}

- (NSOperation *)addArtworkOperationForAlbum:(Album *)album artwork:(Artwork *)artwork
{
    NSURLRequest *request = [ARRouter newPartnerAlbumAddArtworkRequestWithPartnerID:self.partnerID albumID:album.publicSlug artworkID:artwork.slug];
    return [[AFHTTPRequestOperation alloc] initWithRequest:request];
}

- (NSOperation *)removeArtworkOperationForAlbum:(Album *)album artwork:(Artwork *)artwork
{
    NSURLRequest *request = [ARRouter newPartnerAlbumRemoveArtworkRequestWithPartnerID:self.partnerID albumID:album.publicSlug artworkID:artwork.slug];
    return [[AFHTTPRequestOperation alloc] initWithRequest:request];
}

- (void)wrapup
{
    [self setExecuting:NO];
    [self setFinished:YES];

    self.onCompletion();
}

/// Everything under here is annoying boilerplate you need for an NSOperation subclass

- (BOOL)isConcurrent
{
    return NO;
}

- (void)setFinished:(BOOL)isFinished
{
    if (isFinished != _isFinished) {
        [self willChangeValueForKey:@"isFinished"];
        _isFinished = isFinished;
        [self didChangeValueForKey:@"isFinished"];
    }
}

- (BOOL)isFinished
{
    return _isFinished || [self isCancelled];
}

- (void)cancel
{
    [super cancel];
    if ([self isExecuting]) {
        [self setExecuting:NO];
        [self setFinished:YES];
    }
}

- (void)setExecuting:(BOOL)isExecuting
{
    if (isExecuting != _isExecuting) {
        [self willChangeValueForKey:@"isExecuting"];
        _isExecuting = isExecuting;
        [self didChangeValueForKey:@"isExecuting"];
    }
}

- (BOOL)isExecuting
{
    return _isExecuting;
}


@end
