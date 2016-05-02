// Overview: This is basically the superclass for any grid viewcontroller

#import <MacTypes.h>
#import "ARGridViewController.h"
#import "ARGridViewController+ForSubclasses.h"
#import "ARImageGridViewItem.h"
#import "ARNavigationController.h"
#import "ARSelectionHandler.h"
#import "ARSwitchBoard.h"
#import "ARGridViewDataSource.h"


@implementation ARGridViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    _gridView.delegate = nil;
    [_gridView removeFromSuperview];
}

- (instancetype)initWithDisplayMode:(enum ARDisplayMode)initialDisplayMode
{
    self = [super init];
    if (!self) return nil;

    _displayMode = initialDisplayMode;

    return self;
}

#pragma mark -
#pragma mark View Handling

- (void)loadView
{
    _gridView = [[ARGridView alloc] initWithDisplayMode:_displayMode];
    _gridView.cacheContext = self.managedObjectContext;
    _gridView.selectionHandler = self.selectionHandler;
    _gridView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _gridView.delegate = self;

    self.view = _gridView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [@[ ARUserDidChangeGridFilteringSettingsNotification, ARSyncFinishedNotification, ARAlbumDataChanged ] each:^(NSString *note) {
        [self observeNotification:note globallyWithSelector:@selector(artworkReloadNotification:)];
    }];

    [self reloadContent];
}

- (void)artworkReloadNotification:(NSNotification *)aNotification
{
    ar_dispatch_main_queue(^{
        [self reloadContent];
    });
}

- (void)reloadData
{
    [_gridView setResults:_results];
}

#pragma mark ARGridView Delegate methods

- (void)gridViewDidScroll:(ARGridView *)gridView
{
    [self.gridViewScrollDelegate gridViewController:self didHaveGridScroll:gridView];
}

- (BOOL)gridView:(ARGridView *)gridView canSelectItem:(id<ARGridViewItem>)item atIndex:(NSInteger)index
{
    // If we're in editing album names do nothing
    if (self.isEditing) return [item isKindOfClass:ARImageGridViewItem.class];

    // Stop allowing selections of collections
    BOOL isInSelectionMode = self.selectionHandler.isSelecting;
    BOOL isDisplayingACollection = ![self isShowingSelectableItems];
    return !(isDisplayingACollection && isInSelectionMode);
}

- (void)gridView:(ARGridView *)gridView didSelectItem:(id<ARGridViewItem>)item atIndex:(NSInteger)index
{
    if ([item isKindOfClass:ARImageGridViewItem.class]) {
        [(ARImageGridViewItem *)item performActionEvent];
        return;
    }

    // If we're in a selection state and showing artworks / docs we
    // want to toggle selection, not go to ArtworkDetailVC

    BOOL isInSelectionMode = self.selectionHandler.isSelecting;
    if (isInSelectionMode && [self isShowingSelectableItems]) {
        [self.selectionHandler selectObject:item];
        return;
    }
    ARSwitchBoard *switchboard = [ARSwitchBoard sharedSwitchboard];
    switch (_displayMode) {
        case ARDisplayModeAllArtists: {
            [switchboard pushArtistViewController:(Artist *)item animated:YES];
            break;
        }

        case ARDisplayModeAllAlbums:
        case ARDisplayModeArtistAlbums: {
            [switchboard pushAlbumViewController:(Album *)item animated:YES];
            break;
        }

        case ARDisplayModeAllShows:
        case ARDisplayModeArtistShows: {
            [switchboard pushShowViewController:(Show *)item animated:YES];
            break;
        }

        case ARDisplayModeAllLocations:
            [switchboard pushLocationView:(Location *)item animated:YES];
            break;

        case ARDisplayModeDocuments: {
            NSArray *documents = [self.managedObjectContext executeFetchRequest:self.results error:nil];
            [switchboard pushDocumentSet:documents index:[documents indexOfObject:(Document *)item] animated:YES];
            break;
        }

        case ARDisplayModeInstallationShots: {
            NSArray *images = [self.managedObjectContext executeFetchRequest:self.results error:nil];
            [switchboard pushImageViews:images index:[images indexOfObject:item] animated:YES];
            break;
        }

        default: {
            [ARAnalytics event:ARSelectArtworkEvent withProperties:@{ @"from" : [self pageID] }];
            [switchboard pushArtworkViewControllerWithArtworks:_gridView.dataSource.resultsController atIndex:index representedObject:self.representedObject];
        }
    }
}

- (void)gridView:(ARGridView *)gridView didDeselectItem:(id<ARGridViewItem>)item atIndex:(NSInteger)index
{
    if ([item conformsToProtocol:@protocol(ARMultipleSelectionItem)]) {
        [self.selectionHandler deselectObject:item];
    }
}

- (void)setCover:(Image *)cover
{
    if ([self.representedObject respondsToSelector:@selector(setCover:)]) {
        [self.representedObject performSelector:@selector(setCover:) withObject:cover];
        [self.representedObject saveManagedObjectContextLoggingErrors];

        [ARAnalytics event:ARSetCoverEvent withProperties:@{ @"from" : [self nameOfRepresentedObject] }];
    }
}

- (BOOL)isShowingSelectableItems
{
    switch (self.displayMode) {
        case ARDisplayModeAllAlbums:
        case ARDisplayModeAllShows:
        case ARDisplayModeAllArtists:
        case ARDisplayModeArtistShows:
        case ARDisplayModeArtistAlbums:
        case ARDisplayModeInstallationShots:
        default:
            return NO;

        case ARDisplayModeAlbum:
        case ARDisplayModeShow:
        case ARDisplayModeArtist:
        case ARDisplayModeDocuments:
            return YES;
    }
}

#pragma mark properties

- (void)setResults:(NSFetchRequest *)results animated:(BOOL)animated
{
    if (!self.results || !animated) {
        [self setResults:results];
        return;
    }

    @weakify(self);
    [UIView animateWithDuration:.25 animations:^{
        @strongify(self);
        self.gridView.alpha = 0;

    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.25 animations:^{
            @strongify(self);
            [self setResults:results];
            self.gridView.alpha = 1;
        }];
    }];
}

- (void)setResults:(NSFetchRequest *)results
{
    _results = results;
    [_gridView setResults:results];
}

- (void)setIsEditing:(BOOL)newIsEditing
{
    [self setIsEditing:newIsEditing animated:YES];
}

- (void)setIsEditing:(BOOL)newIsEditing animated:(BOOL)animate
{
    _isEditing = newIsEditing;
    [self.gridView setEditing:newIsEditing animated:animate];

    if (newIsEditing) {
        [ARAnalytics event:ARAlbumsEditEvent];
    }
}

- (void)setIsSelectable:(BOOL)isSelectable animated:(BOOL)animate
{
    _isSelectable = isSelectable;
    [self.gridView setIsSelectable:isSelectable animated:animate];
}

- (void)setRepresentedObject:(ARManagedObject *)representedObject
{
    _representedObject = representedObject;

    if (_representedObject) {
        [ARSearchViewController sharedController].selectedItem = _representedObject;
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return [touch.view isKindOfClass:[UINavigationBar class]];
}

- (NSDictionary *)dictionaryForAnalytics
{
    switch (_displayMode) {
        case ARDisplayModeAllAlbums:
            return @{ @"Root" : @"All Albums" };

        case ARDisplayModeAllArtists:
            return @{ @"Root" : @"All Artists" };

        case ARDisplayModeAllShows:
            return @{ @"Root" : @"All Shows" };

        default:
            ;
    }
    return @{ @"Key" : @"Unknown" };
}

- (NSString *)nameOfRepresentedObject
{
    if ([self.representedObject respondsToSelector:@selector(presentableName)]) {
        return [self.representedObject performSelector:@selector(presentableName)];
    }

    if ([self.representedObject respondsToSelector:@selector(title)]) {
        return [self.representedObject performSelector:@selector(title)];
    }

    if ([self.representedObject respondsToSelector:@selector(name)]) {
        return [self.representedObject performSelector:@selector(name)];
    }
    return @"Unknown Represented Object";
}

- (void)selectAllItems
{
    [self.gridView selectAllItems];
}

- (void)deselectAllItems
{
    [self.gridView deselectAllItems];
}

- (BOOL)allItemsAreSelected
{
    NSError *error;
    NSUInteger count = [self.managedObjectContext countForFetchRequest:self.results error:&error];
    if (error) {
        NSLog(@"Error getting a count for fetch request %@", self.results);
        count = 0;
    }

    NSInteger selectedCount = [self.selectionHandler selectedObjects].count;
    return selectedCount == count;
}

- (void)reloadContent
{
    switch (_displayMode) {
        case ARDisplayModeAllAlbums:
            _results = [Album allAlbumsFetchRequestInContext:self.managedObjectContext];
            break;

        case ARDisplayModeAllShows:
            _results = [Show allShowsFetchRequestInContext:self.managedObjectContext];
            _results.sortDescriptors = [Show sortDescriptorsForDates];
            break;

        case ARDisplayModeAllArtists:
            _results = [Artist allArtistsFetchRequestInContext:self.managedObjectContext];
            break;

        case ARDisplayModeAllLocations:
            _results = [Location allLocationsFetchRequestInContext:self.managedObjectContext defaults:self.userDefaults];
            break;

        case ARDisplayModeDocuments:
            _results = [_currentDocumentContainer sortedDocumentsFetchRequestInContext:self.managedObjectContext];
            break;

        case ARDisplayModeArtistAlbums:
        case ARDisplayModeArtistShows:
        case ARDisplayModeArtist:
        case ARDisplayModeInstallationShots:
            //we're ok here, everything got set up by the tab view
            break;
        default:
            NSLog(@"Unsupported display mode: %@", @(_displayMode));
            break;
    }

    [self reloadData];
}

- (NSUserDefaults *)userDefaults
{
    return _userDefaults ?: [NSUserDefaults standardUserDefaults];
}

- (NSManagedObjectContext *)managedObjectContext
{
    return _managedObjectContext ?: [CoreDataManager mainManagedObjectContext];
}

- (ARSelectionHandler *)selectionHandler
{
    return _selectionHandler ?: [ARSelectionHandler sharedHandler];
}

#pragma mark -
#pragma mark Methods to be Overwritten


- (NSString *)pageID
{
    return @"Other";
}

- (void)startSelecting
{
}

- (void)endSelecting
{
}

- (void)addActionButton
{
}

- (void)emailArtworks:(id)sender
{
}

@end
