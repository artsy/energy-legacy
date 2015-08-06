#import "ARAlbumViewController.h"
#import "ARSwitchBoard.h"
#import "ARSelectionToolbarView.h"
#import "ARImageGridViewItem.h"
#import "ARSelectionHandler.h"
#import "ARHostSelectionController.h"


@interface ARHostViewController (Private)
@property (nonatomic, strong) ARHostSelectionController *selectionController;
@end


@interface ARAlbumViewController ()

@property (readonly, nonatomic, strong) UIBarButtonItem *toggleSelectionItem;
@property (readonly, nonatomic, strong) UIBarButtonItem *removeSelectedItem;
@end


@implementation ARAlbumViewController

- (Album *)album
{
    return self.representedObject;
}

- (instancetype)initWithAlbum:(Album *)album
{
    return [super initWithRepresentedObject:album];
}

- (void)viewDidLoad
{
    self.title = [self.representedObject name] ?: @"Unnamed Album";

    _toggleSelectionItem = [[UIBarButtonItem alloc] initWithTitle:@"Select All" style:UIBarButtonItemStylePlain target:self action:@selector(toggleSelectAllTapped:)];
    _removeSelectedItem = [[UIBarButtonItem alloc] initWithTitle:@"Remove" style:UIBarButtonItemStylePlain target:self action:@selector(removeSelectedItems:)];
    [_removeSelectedItem.representedButton setEnabled:NO];

    self.selectionHandler = [[ARSelectionHandler alloc] init];
    [self observeNotification:ARGridSelectionChangedNotification onObject:self.selectionHandler withSelector:@selector(selectionChanged)];

    // Selection handler needs setting up first
    [super viewDidLoad];

    if ([self.representedObject editable].boolValue) {
        [self showBottomButtonToolbar:![UIDevice isPad] animated:NO];
        if ([UIDevice isPad]) {
            self.selectionController.addEditButton = YES;
            [self.selectionController setupDefaultToolbarItems];
        }

        self.bottomToolbar.barButtonItems = [self bottomToolbarItemsEditing:NO];
    }
}

- (void)goToAddNewWorksToAlbum
{
    [self deselectAllItems];
    [[ARSwitchBoard sharedSwitchboard] pushEditAlbumViewController:self.representedObject animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [ARAnalytics event:ARAlbumViewEvent];

    // Have we come back from showing the add artworks modal?
    if (self.currentChildController.isSelectable) {
        UIButton *cancel = self.bottomToolbar.buttons.firstObject;
        [cancel setTitle:@"DONE" forState:UIControlStateNormal];
    }
}

- (NSString *)pageID
{
    return ARAlbumPage;
}

- (void)toggleSelectMode
{
    [self toggleSelectModeAnimated:YES];
}

- (void)toggleSelectModeAnimated:(BOOL)animated
{
    [self setSelecting:!self.currentChildController.isSelectable animated:animated];
}

/// When the email artworks / add to album popovers finish

- (void)endSelecting
{
    [super endSelecting];
}

- (void)setSelecting:(BOOL)selected animated:(BOOL)animated
{
    self.topToolbar.barButtonItems = [self topToolbarItems];
    self.bottomToolbar.barButtonItems = [self bottomToolbarItemsEditing:selected];

    [self showBottomButtonToolbar:selected || ![UIDevice isPad] animated:animated];

    [self dismissPopoversAnimated:animated];
    [self.selectionHandler startSelecting:selected];

    ARGridViewController *mainVC = [self currentChildController];
    NSArray *prefixes = selected ? @[ [self createAddArtworksItem] ] : nil;
    [mainVC.gridView setPrefixedObjects:prefixes animated:animated];

    [mainVC setIsSelectable:selected animated:animated];

    [self showTopButtonToolbar:selected animated:NO];
}

- (void)removeSelectedItems:(id)sender
{
    NSSet *oldArtworks = [self.album artworks];
    NSSet *selected = self.selectionHandler.selectedObjects;
    NSArray *newArtworks = [oldArtworks select:^BOOL(id object) {
        return ![selected containsObject:object];
    }];

    self.album.artworks = [NSSet setWithArray:newArtworks];
    [self.album updateArtists];
    [self.album saveManagedObjectContextLoggingErrors];

    [self setSelecting:NO animated:NO];
    [self.currentChildController setResults:self.album.sortedArtworksFetchRequest];
    [self.currentChildController reloadData];
}

- (void)selectionChanged
{
    NSString *title = self.allItemsAreSelected ? @"Deselect All" : @"Select All";
    [self.toggleSelectionItem.representedButton setTitle:title.uppercaseString forState:UIControlStateNormal];

    BOOL hasSelectedItems = self.selectionHandler.selectedObjects.count > 0;
    [self.removeSelectedItem.representedButton setEnabled:hasSelectedItems];
}

- (NSArray *)topToolbarItems
{
    return @[ self.toggleSelectionItem, self.removeSelectedItem ];
}

- (NSArray *)bottomToolbarItemsEditing:(BOOL)editing
{
    NSString *message = (editing) ? @"Cancel" : @"Edit";
    return @[
        [[UIBarButtonItem alloc] initWithTitle:message style:UIBarButtonItemStylePlain target:self action:@selector(toggleSelectMode)]
    ];
}

- (ARImageGridViewItem *)createAddArtworksItem
{
    ARImageGridViewItem *item = [ARImageGridViewItem gridViewButton];
    [item setTarget:self action:@selector(goToAddNewWorksToAlbum)];
    item.gridTitle = @"";
    item.gridSubtitle = @"";

    NSString *name = [UIDevice isPad] ? @"PadAddArtworksButton@2x" : @"PhoneAddArtworksButton@2x";
    item.imageFilepath = [[NSBundle mainBundle] pathForResource:name ofType:@"png"];
    return item;
}

@end
