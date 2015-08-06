#import "ARAlbumEditNavigationController.h"
#import "ARSelectionToolbarView.h"
#import "ARSelectionHandler.h"
#import "AREditAlbumNavigationBar.h"
#import "ARRootNavigationControllerDelegate.h"
#import "ARAlbumViewController.h"


@interface ARAlbumEditNavigationController ()
@property (nonatomic, strong) ARSelectionHandler *selectionHandler;
@property (nonatomic, strong) ARRootNavigationControllerDelegate *navDelegate;
@end


@implementation ARAlbumEditNavigationController

- (instancetype)initWithAlbum:(Album *)album
{
    NSParameterAssert(album);

    self = [super initWithNavigationBarClass:AREditAlbumNavigationBar.class toolbarClass:nil];
    if (!self) return nil;

    _album = album;

    _navDelegate = [[ARRootNavigationControllerDelegate alloc] init];
    self.delegate = _navDelegate;

    return self;
}

- (void)saveAlbum
{
    [self.selectionHandler endSelectingAlbumWithSave:YES];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)cancelEditingAlbum
{
    [self cancelEditingAlbumAnimated:YES];
}

- (void)cancelEditingAlbumAnimated:(BOOL)animated

{
    [self.selectionHandler cancelSelection];
    [self.presentingViewController dismissViewControllerAnimated:animated completion:nil];
}

- (BOOL)albumCreatedInThisSession
{
    return self.album.artworks.count == 0;
}

- (BOOL)shouldDeleteInsteadOfCancel
{
    return self.albumCreatedInThisSession || self.hasNotSelectedAnyArtworks;
}

- (BOOL)hasNotSelectedAnyArtworks
{
    return self.selectionHandler.selectedObjects.count == 0;
}

- (BOOL)initialArtworksAreASubsetOfSelected
{
    NSSet *selectedObjects = self.selectionHandler.selectedObjects;
    return [self.album.artworks isSubsetOfSet:selectedObjects];
}

- (NSArray *)buttonsForCommitingChanges
{
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelEditingAlbum)];

    if (self.selectionHandler.selectedObjects.count == 0) return @[ cancelItem ];

    NSString *addOrChangeTitle = [self initialArtworksAreASubsetOfSelected] ? @"Add" : @"Save Changes";
    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc] initWithTitle:addOrChangeTitle style:UIBarButtonItemStylePlain target:self action:@selector(saveAlbum)];
    return @[ cancelItem, saveItem ];
}

- (NSString *)descriptionOfSelectionState
{
    NSSet *selected = self.selectionHandler.selectedObjects;
    NSSet *initialWorks = self.album.artworks;

    NSMutableSet *itemsInBoth = [NSMutableSet setWithSet:selected];
    [itemsInBoth intersectSet:initialWorks];

    NSInteger itemsRemoved = initialWorks.count - itemsInBoth.count;
    NSInteger itemsAdded = selected.count - itemsInBoth.count;

    if (itemsRemoved == 0 && itemsAdded == 0) {
        return nil;

    } else if (itemsRemoved > 0 && itemsAdded > 0) {
        return [NSString stringWithFormat:@"ADD %@, REMOVE %@", @(itemsAdded), @(itemsRemoved)];

    } else if (itemsRemoved == 0) {
        return [NSString stringWithFormat:@"%@ %@ TO ADD", @(itemsAdded), itemsAdded > 1 ? @"ITEMS" : @"ITEM"];

    } else if (itemsAdded == 0) {
        return [NSString stringWithFormat:@"%@ %@ TO REMOVE", @(itemsRemoved), itemsRemoved > 1 ? @"ITEMS" : @"ITEM"];
    }

    return nil;
}

- (NSArray *)selectedArtworks
{
    NSMutableSet *newlySelectedArtworks = [NSMutableSet setWithSet:self.selectionHandler.selectedObjects];
    [newlySelectedArtworks minusSet:self.album.artworks];

    return [newlySelectedArtworks.allObjects sortBy:@keypath(Artwork.new, displayTitle)];
}


- (ARSelectionHandler *)selectionHandler
{
    return _selectionHandler ?: ARSelectionHandler.sharedHandler;
}

@end
