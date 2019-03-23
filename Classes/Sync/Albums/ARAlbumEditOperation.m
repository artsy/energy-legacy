#import <AFNetworking/AFJSONRequestOperation.h>
#import "ARAlbumEditOperation.h"
#import "AlbumEdit.h"
#import "ARRouter.h"


@interface ARAlbumEditOperation ()
@property (nonatomic, strong, readonly) NSOperationQueue *networkQueue;
@end


@implementation ARAlbumEditOperation {
    BOOL _isFinished;
    BOOL _isExecuting;
}

- (instancetype)initWithAlbum:(Album *)album createModel:(BOOL)create toAdd:(NSSet<Artwork *> *)addedArtworks toRemove:(NSSet<Artwork *> *)removedArtworks
{
    self = [super init];
    if (!self) {
        return nil;
    }

    _album = album;
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

    if (self.createAlbum) {
        // NOTE: This changes the slug for an album, I didn't think it was a good idea
        // for Folio to try and generate the same ID as CMS. So, this operation
        // is done synchronously before the other operations are ran.

        // This is done on a BG thread anyway, so it's OK.
        [self.networkQueue addOperations:@[[self createAlbumOperation:self.album]] waitUntilFinished:YES];
    }

    NSArray *operations = [self artworkOperationsToRun];
    [self.networkQueue addOperations:operations waitUntilFinished:NO];

    NSInvocationOperation *finisherOperation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(wrapup) object:nil];
    [self.networkQueue addOperation:finisherOperation];
}

- (NSArray *)artworkOperationsToRun
{
    NSMutableArray *operations = [NSMutableArray array];

    [operations addObjectsFromArray:[self.artworksToUpload map:^id(Artwork *artwork) {
        return [self addArtworkOperationForAlbum:self.album artwork:artwork];
    }]];

    [operations addObjectsFromArray:[self.artworksToRemove map:^id(Artwork *artwork) {
        return [self removeArtworkOperationForAlbum:self.album artwork:artwork];
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
    AFJSONRequestOperation *createAlbum = [[AFJSONRequestOperation alloc] initWithRequest:request];

    /// Let the website generate a consistent slug for all generated albums
    [createAlbum setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.album.slug = responseObject[ARFeedIDKey];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

    }];

    return createAlbum;
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
