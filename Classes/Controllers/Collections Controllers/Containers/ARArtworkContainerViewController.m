#import "ARArtworkContainerViewController.h"
#import "ARGridViewController+ForSubclasses.h"
#import "AlbumEdit.h"


@interface ARArtworkContainerViewController ()

@property (readonly, nonatomic, strong) ARManagedObject<ARArtworkContainer> *currentArtworkContainer;

@end


@implementation ARArtworkContainerViewController
@dynamic currentArtworkContainer;

- (instancetype)initWithArtworkContainer:(ARManagedObject<ARArtworkContainer> *)container
{
    enum ARDisplayMode mode = ARDisplayModeArtist;

    if ([container isKindOfClass:Artist.class]) {
        mode = ARDisplayModeArtist;
    } else if ([container isKindOfClass:Show.class]) {
        mode = ARDisplayModeShow;
    } else if ([container isKindOfClass:Album.class]) {
        mode = ARDisplayModeAlbum;
    }

    if (self = [super initWithDisplayMode:mode]) {
        _currentArtworkContainer = container;
        _representedObject = container;
    }
    return self;
}

- (void)reloadContent
{
    self.results = [self.currentArtworkContainer sortedArtworksFetchRequest];
    [self reloadData];
}

- (NSString *)pageID
{
    switch (self.displayMode) {
        case ARDisplayModeArtist:
            return ARArtistPage;

        case ARDisplayModeShow:
            return ARShowPage;

        case ARDisplayModeAlbum:
            return ARAlbumPage;

        default:
            return @"other";
    }
}

- (void)removeArtworkFromAlbum:(id<ARGridViewItem>)item completion:(dispatch_block_t)completion
{
    __weak __typeof(self) weakSelf = self;
    [self removeArtworkCoreDataEntryForGridViewItem:item completion:^{
        [weakSelf reloadData];
        [weakSelf endSelecting];

        if (completion) {
            completion();
        }
    }];
}

- (void)removeArtworkCoreDataEntryForGridViewItem:(id<ARGridViewItem>)item completion:(dispatch_block_t)completion
{
    Album *album = (Album *)_representedObject;
    Artwork *artwork = (Artwork *)item;

    [album removeArtworksObject:artwork];
    [album updateArtists];

    // Ensure this gets done remotely
    AlbumEdit *edit = [[AlbumEdit alloc] initWithContext:[album managedObjectContext]];
    edit.removedArtworks = [NSSet setWithObject:artwork];

    [album saveManagedObjectContextLoggingErrors];

    if (completion) {
        completion();
    }
}

- (BOOL)isHostingShow
{
    return [_representedObject isKindOfClass:Show.class];
}

- (BOOL)isHostingLocation
{
    return [_representedObject isKindOfClass:Location.class];
}

- (BOOL)isHostingEditableAlbum
{
    if ([_representedObject isKindOfClass:[Album class]]) {
        Album *album = (Album *)self.representedObject;
        return [album.editable boolValue];
    }
    return NO;
}

@end
