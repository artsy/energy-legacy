#import "ARSync.h"
#import "ARSyncDeleter.h"
#import "ARSlugResolver.h"
#import "ARSyncPlugins.h"
#import "ARSyncOperations.h"
#import "SyncLog.h"
#import "ARSyncLogger.h"


@interface ARSync ()

@property (readwrite, nonatomic, strong) NSMutableArray *operationQueues;
@property (readwrite, nonatomic, strong) DRBOperationTree *rootOperation;

@property (readwrite, nonatomic, getter=isSyncing) BOOL syncing;
@property (readwrite, nonatomic, strong) ARTileArchiveDownloader *tileDownloader;

@end


@implementation ARSync

- (void)sync
{
    self.syncing = YES;
    __weak typeof(self) weakSelf = self;

    [self performSync:^{
        weakSelf.syncing = NO;
        [weakSelf.delegate syncDidFinish:self];
    }];
}

- (void)performSync:(void (^)())completion
{
    ARSyncLog(@"Sync started");

    self.operationQueues = [NSMutableArray array];
    self.rootOperation = self.rootOperation ?: [self createSyncOperationTree];

    NSArray *plugins = [self createPlugins];
    [self runBeforeSyncPlugins:plugins];
    [self.progress start];

    NSString *partnerSlug = [Partner currentPartnerID];
    [self.rootOperation enqueueOperationsForObject:partnerSlug completion:^{
        [self.tileDownloader writeSlugs];

        [self runAfterSyncPlugins:plugins];
        [self save];

        // Cleanup the tree so it's recreated next sync
        self.rootOperation = nil;
        if (completion) completion();
    }];
}

- (void)runBeforeSyncPlugins:(NSArray *)plugins
{
    [plugins each:^(id<ARSyncPlugin> plugin) {
        if ([plugin respondsToSelector:@selector(syncDidStart:)]) {
            [plugin syncDidStart:self];
        }
    }];
}

- (void)runAfterSyncPlugins:(NSArray *)plugins
{
    [plugins each:^(id<ARSyncPlugin> plugin) {
        if ([plugin respondsToSelector:@selector(syncDidFinish:)]) {
            [plugin syncDidFinish:self];
        }
    }];
}

- (void)save
{
    NSError *error = nil;
    if (![self.config.managedObjectContext save:&error]) {
        ARSyncLog(@"Error Saving MOC: %@", error.localizedDescription);

        NSArray *detailedErrors = [error userInfo][NSDetailedErrorsKey];
        if (detailedErrors != nil && [detailedErrors count] > 0) {
            for (NSError *detailedError in detailedErrors) {
                ARSyncLog(@"Error Saving MOC: %@", detailedError.localizedDescription);
            }
        }
    }
}

- (DRBOperationTree *)createSyncOperationTree
{
    NSManagedObjectContext *context = self.config.managedObjectContext;

    NSOperationQueue *artworksOperationQueue = [[NSOperationQueue alloc] init];
    artworksOperationQueue.maxConcurrentOperationCount = 5;
    [self.operationQueues addObject:artworksOperationQueue];

    NSOperationQueue *requestOperationQueue = [[NSOperationQueue alloc] init];
    requestOperationQueue.maxConcurrentOperationCount = 5;
    [self.operationQueues addObject:requestOperationQueue];

    NSOperationQueue *imageOperationQueue = [[NSOperationQueue alloc] init];
    imageOperationQueue.maxConcurrentOperationCount = 10;
    [self.operationQueues addObject:imageOperationQueue];

    // nodes
    DRBOperationTree *partnerNode = [[DRBOperationTree alloc] initWithOperationQueue:requestOperationQueue];
    DRBOperationTree *userNode = [[DRBOperationTree alloc] initWithOperationQueue:requestOperationQueue];
    DRBOperationTree *estimateNode = [[DRBOperationTree alloc] initWithOperationQueue:requestOperationQueue];
    DRBOperationTree *artworkNode = [[DRBOperationTree alloc] initWithOperationQueue:artworksOperationQueue];
    DRBOperationTree *imageNode = [[DRBOperationTree alloc] initWithOperationQueue:requestOperationQueue];
    DRBOperationTree *imageThumbnailNode = [[DRBOperationTree alloc] initWithOperationQueue:imageOperationQueue];
    DRBOperationTree *tileDownloaderNode = [[DRBOperationTree alloc] initWithOperationQueue:requestOperationQueue];
    DRBOperationTree *tileUnzipperNode = [[DRBOperationTree alloc] initWithOperationQueue:imageOperationQueue];

    DRBOperationTree *showNode = [[DRBOperationTree alloc] initWithOperationQueue:requestOperationQueue];
    DRBOperationTree *showDocumentsNode = [[DRBOperationTree alloc] initWithOperationQueue:requestOperationQueue];
    DRBOperationTree *showArtworksNode = [[DRBOperationTree alloc] initWithOperationQueue:requestOperationQueue];
    DRBOperationTree *showInstallationShotsNode = [[DRBOperationTree alloc] initWithOperationQueue:requestOperationQueue];
    DRBOperationTree *showCoversNode = [[DRBOperationTree alloc] initWithOperationQueue:requestOperationQueue];

    DRBOperationTree *documentFileNode = [[DRBOperationTree alloc] initWithOperationQueue:requestOperationQueue];
    DRBOperationTree *documentThumbnailNode = [[DRBOperationTree alloc] initWithOperationQueue:imageOperationQueue];

    DRBOperationTree *artistNode = [[DRBOperationTree alloc] initWithOperationQueue:requestOperationQueue];
    DRBOperationTree *artistDocumentsNode = [[DRBOperationTree alloc] initWithOperationQueue:requestOperationQueue];

    DRBOperationTree *albumNode = [[DRBOperationTree alloc] initWithOperationQueue:requestOperationQueue];
    DRBOperationTree *albumArtworksNode = [[DRBOperationTree alloc] initWithOperationQueue:requestOperationQueue];

    DRBOperationTree *locationNode = [[DRBOperationTree alloc] initWithOperationQueue:requestOperationQueue];
    DRBOperationTree *locationArtworksNode = [[DRBOperationTree alloc] initWithOperationQueue:requestOperationQueue];

    DRBOperationTree *partnerUpdateNode = [[DRBOperationTree alloc] initWithOperationQueue:requestOperationQueue];

    // connect nodes to providers

    // top level
    partnerNode.provider = [[ARPartnerFullMetadataDownloader alloc] initWithContext:context];

    estimateNode.provider = [[AREstimateDownloader alloc] initWithProgress:self.progress];
    artworkNode.provider = [[ARArtworkDownloader alloc] initWithContext:context deleter:self.config.deleter];
    userNode.provider = [[ARUserMetadataDownloader alloc] initWithContext:context];

    // images
    imageNode.provider = [[ARImageDownloader alloc] initWithProgress:self.progress];
    imageThumbnailNode.provider = [[ARImageThumbnailCreator alloc] init];

    self.tileDownloader = [[ARTileArchiveDownloader alloc] initWithProgress:self.progress];
    tileDownloaderNode.provider = self.tileDownloader;
    tileUnzipperNode.provider = [[ARTileUnzipper alloc] init];

    // shows
    showNode.provider = [[ARShowDownloader alloc] initWithContext:context deleter:self.config.deleter];
    showArtworksNode.provider = [[ARShowArtworksDownloader alloc] init];
    showInstallationShotsNode.provider = [[ARShowInstallationShotsDownloader alloc] initWithContext:context deleter:self.config.deleter];
    showCoversNode.provider = [[ARShowCoverShotDownloader alloc] initWithContext:context deleter:self.config.deleter];

    // documents
    showDocumentsNode.provider = [[ARShowDocumentDownloader alloc] initWithContext:context deleter:self.config.deleter];
    documentFileNode.provider = [[ARDocumentFileDownloader alloc] initWithProgress:self.progress];
    documentThumbnailNode.provider = [[ARDocumentThumbnailCreator alloc] init];

    // artists
    artistNode.provider = [[ARArtistDownloader alloc] initWithContext:context deleter:self.config.deleter];
    artistDocumentsNode.provider = [[ARArtistDocumentDownloader alloc] initWithContext:context deleter:self.config.deleter];

    // Albums
    albumNode.provider = [[ARAlbumDownloader alloc] initWithContext:context deleter:self.config.deleter];
    albumArtworksNode.provider = [[ARAlbumArtworksDownloader alloc] init];

    // Location
    locationNode.provider = [[ARLocationDownloader alloc] initWithContext:context deleter:self.config.deleter];
    locationArtworksNode.provider = [[ARLocationArtworksDownloader alloc] init];

    // Metadata updating
    partnerUpdateNode.provider = [[ARPartnerMetadataUploader alloc] initWithContext:context];

    // connect nodes to nodes

    // artworks and images
    [partnerNode addChild:estimateNode];
    [partnerNode addChild:artworkNode];
    [partnerNode addChild:userNode];
    [artworkNode addChild:imageNode];

    [imageNode addChild:imageThumbnailNode];

    [artworkNode addChild:tileDownloaderNode];
    [tileDownloaderNode addChild:tileUnzipperNode];

    // shows
    [partnerNode addChild:showNode];
    [showNode addChild:showArtworksNode];
    [showNode addChild:showDocumentsNode];
    [showNode addChild:showInstallationShotsNode];
    [showNode addChild:showCoversNode];
    [showCoversNode addChild:imageNode];
    [showInstallationShotsNode addChild:imageNode];


    // show documents
    [showDocumentsNode addChild:documentFileNode];
    [documentFileNode addChild:documentThumbnailNode];

    // artist docs
    [partnerNode addChild:artistNode];
    [artistNode addChild:artistDocumentsNode];
    [artistDocumentsNode addChild:documentFileNode];

    // Album
    [partnerNode addChild:albumNode];
    [albumNode addChild:albumArtworksNode];

    // Locations
    [partnerNode addChild:locationNode];
    [locationNode addChild:locationArtworksNode];

    // Misc metadata
    [partnerNode addChild:partnerUpdateNode];

    return partnerNode;
}

- (DRBOperationTree *)createPartnerMetadataTree
{
    NSManagedObjectContext *context = self.config.managedObjectContext;

    NSOperationQueue *requestOperationQueue = [[NSOperationQueue alloc] init];

    // create partner node + provider
    DRBOperationTree *partnerNode = [[DRBOperationTree alloc] initWithOperationQueue:requestOperationQueue];
    partnerNode.provider = [[ARPartnerFullMetadataDownloader alloc] initWithContext:context];

    return partnerNode;
}

- (NSArray<id<ARSyncPlugin>> *)createPlugins
{
    /// The background check and the deleter are plugins
    /// the deleter comes from the config, it's a bit of juggling
    /// but worth it because we can then have all the sync step
    /// configuration objects bound together.

    ARSyncBackgroundedCheck *backgroundCheck = [[ARSyncBackgroundedCheck alloc] init];
    self.config.deleter.backgroundCheck = backgroundCheck;

    NSMutableArray *plugins = [@[

        [[ARSyncAnalytics alloc] init],
        [[ARSlugResolver alloc] init],
        [[ARSyncDefaults alloc] init],
        [[ARSyncInsomniac alloc] init],
        [[ARSyncRemoveiCloudAttributes alloc] init],
        backgroundCheck,
        self.config.deleter,
        [[ARSyncNotification alloc] init],
        [[ARSyncLogger alloc] init],
    ] mutableCopy];

    if (NSClassFromString(@"CSSearchableIndex")) {
        CSSearchableIndex *index = [CSSearchableIndex defaultSearchableIndex];
        ARSpotlightExporter *exporter = [[ARSpotlightExporter alloc] initWithIndex:index];
        [plugins addObject:exporter];
    }

    return plugins;
}

- (void)setPaused:(BOOL)paused
{
    if (!self.isSyncing) return;
    [self.operationQueues makeObjectsPerformSelector:@selector(setSuspended:) withObject:paused ? @YES : @NO];
}

- (void)cancel
{
    [self.operationQueues makeObjectsPerformSelector:@selector(cancelAllOperations)];
}

- (unsigned long long)estimatedNumBytesToDownload
{
    Partner *partner = [Partner currentPartnerInContext:self.config.managedObjectContext];

    // Whilst never being perfect, this came reasonably above
    // on energy test partner. real 151MB estimated 195MB

    const CGFloat SizePerArtworkMB = 2.5;
    const CGFloat SizePerDocumentMB = 2.5;

    unsigned long long totalBytesToDownload = SizePerArtworkMB * partner.artworksCount.integerValue;
    totalBytesToDownload += SizePerDocumentMB * partner.showDocumentsCount.integerValue;
    totalBytesToDownload += SizePerDocumentMB * partner.artistDocumentsCount.integerValue;

    // MB to bytes
    totalBytesToDownload *= 1048576;
    return totalBytesToDownload;
}

- (NSManagedObjectContext *)createPrivateManagedObjectContext
{
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    context.persistentStoreCoordinator = [CoreDataManager persistentStoreCoordinator];
    context.undoManager = nil;
    return context;
}

@end
