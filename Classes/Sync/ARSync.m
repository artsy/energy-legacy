#import "ARSync.h"
#import "ARDeleter.h"
#import "ARSlugResolver.h"
#import "ARSyncOperations.h"
#import "NSFileManager+SkipBackup.h"
#import "ARFileUtils.h"
#import <AFNetworking/AFNetworking.h>
#import "SyncLog.h"

#if __has_include(<CoreSpotlight/CoreSpotlight.h>)
#import "ARSpotlightExporter.h"
#import <CoreSpotlight/CoreSpotlight.h>
#endif


@interface ARSync ()
@property (readwrite, nonatomic, strong) NSMutableArray *operationQueues;

@property (readwrite, nonatomic, strong) DRBOperationTree *rootOperation;
@property (readwrite, nonatomic, strong) NSUserDefaults *defaults;
@property (readwrite, nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@property (readwrite, nonatomic, getter=isSyncing) BOOL syncing;
@property (readwrite, nonatomic, getter=applicationHasBackgrounded) BOOL applicationHasGoneIntoTheBackground;

@property (readwrite, nonatomic, strong) ARDeleter *deleter;
@property (readwrite, nonatomic, strong) ARSlugResolver *resolver;

@property (readwrite, nonatomic, strong) ARTileArchiveDownloader *tileDownloader;
@property (readwrite, nonatomic, strong) UIApplication *sharedApplication;

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

    [self performAnalyticsBefore];
    self.operationQueues = [NSMutableArray array];
    self.managedObjectContext = _managedObjectContext ?: [self createPrivateManagedObjectContext];

    self.resolver = [[ARSlugResolver alloc] initWithManagedObjectContext:self.managedObjectContext];
    self.deleter = [[ARDeleter alloc] initWithManagedObjectContext:self.managedObjectContext];
    self.sharedApplication.idleTimerDisabled = YES;

    [self markObjectsForDeletion:self.deleter];

    self.rootOperation = self.rootOperation ?: [self createSyncOperationTree];
    DRBOperationTree *rootNode = self.rootOperation;

    // sync metadata
    [self.progress start];

    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter postNotificationName:ARSyncStartedNotification object:nil];
    [notificationCenter addObserver:self selector:@selector(applicationWillResignActive:) name:ARApplicationDidGoIntoBackground object:nil];

    NSString *partnerSlug = [Partner currentPartnerID];

    [rootNode enqueueOperationsForObject:partnerSlug completion:^{
        [self.tileDownloader writeSlugs];
        [self.resolver resolveAllSlugs];

        if ([self shouldDeleteUnfoundObjects]) {
            [self.deleter deleteObjects];
        }

        [self save];
        [self performAnalyticsAfter];

        [self updateDefaultsForSync];

        // Cleanup the tree so it's recreated next sync
        self.rootOperation = nil;

        [self ensureNoLocalBackups];
        [self syncSpotlightIndex];

        if (completion) completion();
        self.sharedApplication.idleTimerDisabled = NO;

        [notificationCenter postNotificationName:ARSyncFinishedNotification object:nil];
        [notificationCenter removeObserver:self name:ARApplicationDidGoIntoBackground object:nil];
    }];
}

- (void)save
{
    SyncLog *newSyncLog = [SyncLog createInContext:self.managedObjectContext];
    newSyncLog.dateStarted = NSDate.date;

    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
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
    NSManagedObjectContext *context = self.managedObjectContext;

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
    artworkNode.provider = [[ARArtworkDownloader alloc] initWithContext:context deleter:self.deleter];
    userNode.provider = [[ARUserMetadataDownloader alloc] initWithContext:context];

    // images
    imageNode.provider = [[ARImageDownloader alloc] initWithProgress:self.progress];
    imageThumbnailNode.provider = [[ARImageThumbnailCreator alloc] init];

    self.tileDownloader = [[ARTileArchiveDownloader alloc] initWithProgress:self.progress];
    tileDownloaderNode.provider = self.tileDownloader;
    tileUnzipperNode.provider = [[ARTileUnzipper alloc] init];

    // shows
    showNode.provider = [[ARShowDownloader alloc] initWithContext:context deleter:self.deleter];
    showArtworksNode.provider = [[ARShowArtworksDownloader alloc] init];
    showInstallationShotsNode.provider = [[ARShowInstallationShotsDownloader alloc] initWithContext:context deleter:self.deleter];
    showCoversNode.provider = [[ARShowCoverShotDownloader alloc] initWithContext:context deleter:self.deleter];

    // documents
    showDocumentsNode.provider = [[ARShowDocumentDownloader alloc] initWithContext:context deleter:self.deleter];
    documentFileNode.provider = [[ARDocumentFileDownloader alloc] initWithProgress:self.progress];
    documentThumbnailNode.provider = [[ARDocumentThumbnailCreator alloc] init];

    // artists
    artistNode.provider = [[ARArtistDownloader alloc] initWithContext:context deleter:self.deleter];
    artistDocumentsNode.provider = [[ARArtistDocumentDownloader alloc] initWithContext:context deleter:self.deleter];

    // Albums
    albumNode.provider = [[ARAlbumDownloader alloc] initWithContext:context deleter:self.deleter];
    albumArtworksNode.provider = [[ARAlbumArtworksDownloader alloc] init];

    // Location
    locationNode.provider = [[ARLocationDownloader alloc] initWithContext:context deleter:self.deleter];
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
    NSManagedObjectContext *context = self.managedObjectContext;

    NSOperationQueue *requestOperationQueue = [[NSOperationQueue alloc] init];

    // create partner node + provider
    DRBOperationTree *partnerNode = [[DRBOperationTree alloc] initWithOperationQueue:requestOperationQueue];
    partnerNode.provider = [[ARPartnerFullMetadataDownloader alloc] initWithContext:context];

    return partnerNode;
}

- (void)setPaused:(BOOL)paused
{
    if (!self.isSyncing) return;

    // This may not strictly true, but it's very possible that this has happened.
    _applicationHasGoneIntoTheBackground = YES;

    [self.operationQueues makeObjectsPerformSelector:@selector(setSuspended:) withObject:paused ? @YES : nil];
}

- (void)cancel
{
    [self.operationQueues makeObjectsPerformSelector:@selector(cancelAllOperations)];
}

- (void)applicationWillResignActive:(NSNotification *)notification
{
    _applicationHasGoneIntoTheBackground = YES;
}

- (BOOL)shouldDeleteUnfoundObjects
{
    return self.applicationHasGoneIntoTheBackground == NO;
}

- (unsigned long long)estimatedNumBytesToDownload
{
    Partner *partner = [Partner currentPartnerInContext:self.managedObjectContext];

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

- (void)markObjectsForDeletion:(ARDeleter *)deleter
{
    [@[ [Artwork class], [Artist class], [Image class], [Document class], [Show class], [Location class] ] each:^(Class klass) {
        [deleter markAllObjectsInClassForDeletion:klass];
    }];

    // Local albums & all albums should be skipped by the deleter
    [[Album downloadedAlbumsInContext:self.managedObjectContext] each:^(Album *album) {
        [deleter markObjectForDeletion:album];
    }];
}

- (void)updateDefaultsForSync
{
    [self.defaults setBool:YES forKey:ARFinishedFirstSync];
    [self.defaults setObject:NSDate.date forKey:ARLastSyncDate];
    [self.defaults setBool:NO forKey:ARRecommendSync];

    NSString *appVersion = [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];
    [self.defaults setObject:appVersion forKey:ARAppSyncVersion];

    [self.defaults synchronize];
}

- (void)ensureNoLocalBackups
{
    NSString *userDocuments = [ARFileUtils userDocumentsDirectoryPath];
    [[NSFileManager defaultManager] backgroundAddSkipBackupAttributeToDirectoryAtPath:userDocuments];
}

- (void)performAnalyticsBefore
{
    BOOL completedSyncBefore = [self.defaults boolForKey:ARFinishedFirstSync];
    [self.defaults setBool:YES forKey:ARSyncingIsInProgress];

    [ARAnalytics event:@"sync_started" withProperties:@{
        @"initial_sync" : @(completedSyncBefore)
    }];
}

- (void)performAnalyticsAfter
{
    [self.defaults setBool:NO forKey:ARSyncingIsInProgress];

    CGFloat seconds = roundf([[NSDate date] timeIntervalSinceDate:self.progress.startDate]);
    BOOL completedSyncBefore = [self.defaults boolForKey:ARFinishedFirstSync];

    [ARAnalytics event:@"sync_finished" withProperties:@{
        @"seconds" : @(seconds),
        @"initial" : @(completedSyncBefore)
    }];
}

- (void)syncSpotlightIndex
{
#if __has_include(<CoreSpotlight/CoreSpotlight.h>)
    if (!NSClassFromString(@"CSSearchableIndex")) return;

    CSSearchableIndex *index = [CSSearchableIndex defaultSearchableIndex];
    ARSpotlightExporter *exporter = [[ARSpotlightExporter alloc] initWithManagedObjectContext:self.managedObjectContext index:index];
    [exporter updateCache];
#endif
}

- (NSManagedObjectContext *)createPrivateManagedObjectContext
{
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    context.persistentStoreCoordinator = [CoreDataManager persistentStoreCoordinator];
    context.undoManager = nil;
    return context;
}

- (NSManagedObjectContext *)managedObjectContext
{
    return _managedObjectContext ?: [CoreDataManager mainManagedObjectContext];
}

- (NSUserDefaults *)defaults
{
    return _defaults ?: [NSUserDefaults standardUserDefaults];
}

- (UIApplication *)sharedApplication
{
    return _sharedApplication ?: [UIApplication sharedApplication];
}

@end
