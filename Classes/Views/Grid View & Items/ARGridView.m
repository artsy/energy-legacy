#import "ARGridView.h"
#import "ARImageGridViewItem.h"
#import "ARGridViewCell.h"
#import "AREditableImageGridViewCell.h"
#import "ARGridViewController.h"
#import "ARArtworkContainerViewController.h"

#import "UIImage+ImmediateLoading.h"
#import "ARSelectionHandler.h"

#import "NSFetchedResultsController+Count.h"
#import "ARGridView+CoverHandling.h"

#import "ARFlatButton.h"
#import "AROptions.h"
#import "ARGridViewDataSource.h"
#import <TPKeyboardAvoiding/TPKeyboardAvoidingCollectionView.h>

const NSInteger ArtworkGridBottomMargin = 17;


@interface ARGridView () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *gridView;
@property (readwrite, nonatomic, strong) ARGridViewDataSource *dataSource;
@end


@implementation ARGridView {
    ARPopoverController *_coverPopoverController;

    UILongPressGestureRecognizer *_longPress;
    NSIndexPath *_indexPathForPopover;

    BOOL _shouldUseSquareThumbnails;
    NSManagedObjectContext *_cacheContext;
}

- (instancetype)initWithDisplayMode:(enum ARDisplayMode)initialDisplayMode
{
    self = [super initWithFrame:CGRectNull];
    if (!self) return nil;

    _displayMode = initialDisplayMode;
    _shouldUseSquareThumbnails = [self shouldUseSquareThumbnails];

    _dataSource = [[ARGridViewDataSource alloc] init];
    _dataSource.thumbnailFormat = [self thumbnailImageSize];

    self.clipsToBounds = YES;

    [self createGridView];

    return self;
}

- (void)createGridView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = [self gridViewCellSize];
    layout.minimumInteritemSpacing = 4;

    UICollectionView *collectionView = [[TPKeyboardAvoidingCollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.alwaysBounceVertical = YES;

    Class cellKlass = [self classForDisplayMode:self.displayMode];
    [collectionView registerClass:cellKlass forCellWithReuseIdentifier:NSStringFromClass(cellKlass)];

    [self addSubview:collectionView];
    self.gridView = collectionView;

    [self setIsSelectable:self.selectionHandler.isSelecting animated:NO];
    [self tintColorDidChange];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _gridView.frame = self.bounds;

    [self setupContentInset];
}

// The showing the grid view function, this is where we can't faff.

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    Class cellKlass = [self classForDisplayMode:_displayMode];
    NSString *klassID = NSStringFromClass(cellKlass);

    ARGridViewCell *cell = (id)[self.gridView dequeueReusableCellWithReuseIdentifier:klassID forIndexPath:indexPath];

    id<ARGridViewItem> item = [self.dataSource objectAtIndexPath:indexPath];
    NSAssert([item conformsToProtocol:@protocol(ARGridViewItem)], @"Grid view Item must conform to ARGridViewItem protocol");

    cell.item = item;
    cell.aspectRatio = self.shouldUseSquareThumbnails ? 1 : [self.dataSource aspectRatioForItem:item];

    NSString *imagePath = [self.dataSource imagePathForItem:item];
    NSURL *imageURL = [self.dataSource imageURLForItem:item];

    if ([[NSFileManager defaultManager] fileExistsAtPath:imagePath]) {
        cell.imagePath = imagePath;

        // image is rendered differently if it belongs to a button
        [self setImageAsyncAtPath:imagePath backupURL:imageURL forGridCell:cell asButton:[self.dataSource isButton:item]];

    } else {
        [cell setImageURL:imageURL savingLocallyAtPath:imagePath];
    }

    // Set the cell attributes per type of gridview
    switch (_displayMode) {
        case ARDisplayModeAllAlbums:
        case ARDisplayModeAllArtists:
        case ARDisplayModeAllShows:
        case ARDisplayModeArtistShows:
        case ARDisplayModeArtistAlbums:
        case ARDisplayModeAllLocations:
            cell.suppressItalics = YES;

        case ARDisplayModeShow:
        case ARDisplayModeAlbum:
        case ARDisplayModeLocation:
        case ARDisplayModeDocuments:
            cell.title = [self.dataSource gridTitleForItem:item];
            cell.subtitle = [self.dataSource gridSubtitleForItem:item];
            break;

        case ARDisplayModeInstallationShots:
        case ARDisplayModeArtist:
            // Only show the subtitle on an artist page
            // because we know who the artist is.
            cell.subtitle = [self.dataSource gridSubtitleForItem:item];
            break;
    }

    cell.indexPath = indexPath;

    // Handle selection state

    [cell setIsMultiSelectable:self.isSelectable animated:NO];

    BOOL alreadySelected = self.isSelectable && [self.selectionHandler.selectedObjects containsObject:item];
    [cell setVisuallySelected:alreadySelected animated:NO];
    [cell setSelected:alreadySelected];

    if (alreadySelected) {
        [collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    }

    [cell layoutSubviews];
    return cell;
}

- (BOOL)gridSupportsSelectingItems
{
    return (_displayMode != ARDisplayModeArtistAlbums && _displayMode != ARDisplayModeArtistShows);
}

- (Class)classForDisplayMode:(enum ARDisplayMode)displayMode
{
    switch (displayMode) {
        case ARDisplayModeAllAlbums:
        case ARDisplayModeAlbum:
            return [AREditableImageGridViewCell class];

        default:
            break;
    }

    return [ARGridViewCell class];
}

- (NSInteger)numberOfCellsPerLine
{
    BOOL isPortrait = UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation);
    NSInteger ipadCellsPerLine = isPortrait ? 3 : 4;
    return [UIDevice isPad] ? ipadCellsPerLine : 2;
}

- (void)setupContentInset
{
    NSInteger numberOfCellsPerLine = [self numberOfCellsPerLine];

    CGFloat contentWidth = numberOfCellsPerLine * [self gridViewCellSize].width;
    CGFloat marginWidth = (numberOfCellsPerLine - 1) * 14;

    CGFloat inset = floorf((self.frame.size.width - contentWidth - marginWidth) / 2);
    self.gridView.contentInset = UIEdgeInsetsMake(0, inset, ArtworkGridBottomMargin, inset);
}

- (CGSize)gridViewCellSize
{
    BOOL isPortrait = UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation);

    BOOL extended = self.displayMode == ARDisplayModeAllShows || self.displayMode == ARDisplayModeArtistShows;
    CGFloat height;
    if ([UIDevice isPad]) {
        height = extended ? 314 : 296;
    } else {
        CGFloat totalHeight = CGRectGetHeight([UIScreen mainScreen].bounds);
        height = totalHeight / 3.2;
        height = extended ? height += 20 : height;
    }

    NSInteger cellsPerLine = [self numberOfCellsPerLine];

    CGFloat screenWidth = CGRectGetWidth([UIScreen mainScreen].bounds);
    CGFloat width = (screenWidth / cellsPerLine) - (40 / cellsPerLine);
    return CGSizeMake(roundf(width), height);
}

#pragma mark -
#pragma mark Grid View Data Source

- (void)setPrefixedObjects:(NSArray *)prefixedObjects
{
    [self setPrefixedObjects:prefixedObjects animated:YES];
}

- (void)setPrefixedObjects:(NSArray *)prefixedObjects animated:(BOOL)animated
{
    NSInteger oldPrefixCount = self.dataSource.prefixedObjects.count;

    self.dataSource.prefixedObjects = prefixedObjects;
    _prefixedObjects = prefixedObjects;
    if (animated) {
        if (prefixedObjects) {
            NSArray *indexes = [self indexPathsForFirstXElements:self.prefixedObjects.count];
            [self.gridView insertItemsAtIndexPaths:indexes];

        } else {
            NSArray *indexes = [self indexPathsForFirstXElements:oldPrefixCount];
            [self.gridView deleteItemsAtIndexPaths:indexes];
        }
    } else {
        [self.gridView reloadData];
    }
}

- (NSArray *)indexPathsForFirstXElements:(NSInteger)count
{
    NSMutableArray *paths = [NSMutableArray array];
    for (int i = 0; i < count; i++) {
        [paths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
    }
    return paths.copy;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.numberOfItems;
}

#pragma mark -
#pragma mark Grid View Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_delegate gridViewDidScroll:self];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = indexPath.row;
    id<ARGridViewItem> item = [self.dataSource objectAtIndexPath:indexPath];

    if (![self.delegate gridView:self canSelectItem:item atIndex:index]) {
        return;
    }

    if (!self.isSelectable) {
        [self.delegate gridView:self didSelectItem:item atIndex:index];

    } else {
        ARGridViewCell *cell = (id)[self.gridView cellForItemAtIndexPath:indexPath];
        [self.delegate gridView:self didSelectItem:item atIndex:index];

        BOOL isNotSelectable = [item isKindOfClass:ARImageGridViewItem.class];
        if (isNotSelectable) return;

        [cell setVisuallySelected:YES animated:YES];

        if (self.selectionHandler.isSelecting) {
            [self.selectionHandler selectObject:item];
        }
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ARGridViewCell *cell = (id)[self.gridView cellForItemAtIndexPath:indexPath];
    [cell setVisuallySelected:NO animated:YES];

    id<ARGridViewItem> item = [self.dataSource objectAtIndexPath:indexPath];
    [_delegate gridView:self didDeselectItem:item atIndex:indexPath.row];
}

- (void)setImageAsyncAtPath:(NSString *)imageAddress backupURL:(NSURL *)backupURL forGridCell:(ARGridViewCell *)cell asButton:(BOOL)asButton
{
    ar_dispatch_async(^{

        // don't load if it's on a different cell
        if (![cell.imagePath isEqual:imageAddress]) return ;

        UIImage *thumbnail;

        // image must have its rendering mode set at time of initialization - ensures buttons are compatible with white Folio
        if (asButton) {
            thumbnail = [[UIImage imageImmediateLoadWithContentsOfFile:imageAddress] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        }
        else {
            thumbnail = [[UIImage alloc] initImmediateLoadWithContentsOfFile:imageAddress];
        }

        ar_dispatch_main_queue(^{

            // Double check that during the decoding the cell's not been re-used

            if ([cell.imagePath isEqual:imageAddress] && thumbnail) {
                [cell setImage:thumbnail];

            // If we can't convert the image to a UIImage, let's just kill it and re-download.

            } else if (!thumbnail) {

                [[NSFileManager defaultManager] removeItemAtPath:imageAddress error:nil];
                [cell setImageURL:backupURL savingLocallyAtPath:imageAddress];
            }
        });
    });
}

- (void)setCover:(ARFlatButton *)sender
{
    [sender setBackgroundColor:[UIColor artsyPurple] forState:UIControlStateNormal];
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    id<ARGridViewItem> item = [self.dataSource objectAtIndexPath:_indexPathForPopover];
    [_delegate setCover:item];
    [self performSelector:@selector(dismissCoverPopover) withObject:nil afterDelay:0.25];
}

- (void)dismissCoverPopover
{
    [_coverPopoverController dismissPopoverAnimated:YES];
}

#pragma mark -
#pragma mark Popover delegate methods

- (BOOL)popoverControllerShouldDismissPopover:(ARPopoverController *)popoverController
{
    return YES;
}

- (void)popoverControllerDidDismissPopover:(ARPopoverController *)popoverController
{
    if (popoverController == _coverPopoverController) {
        [UIView animateWithDuration:ARAnimationDuration animations:^{
            for (ARGridViewCell *cell in [_gridView visibleCells]) {
                cell.alpha = 1;
            }
        }];
    }
}

#pragma mark Setters

- (void)setDisplayMode:(enum ARDisplayMode)displayMode
{
    _displayMode = displayMode;

    UICollectionViewFlowLayout *layout = (id)_gridView.collectionViewLayout;
    layout.itemSize = [self gridViewCellSize];
}

- (void)setDelegate:(id<ARGridViewDelegate>)delegate
{
    _delegate = delegate;

    BOOL canHaveCover = [_delegate isKindOfClass:ARArtworkContainerViewController.class];
    if (canHaveCover) {
        _longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressed:)];
        _longPress.minimumPressDuration = 0.5f;

        [self addGestureRecognizer:_longPress];
    }
}

- (void)setResults:(NSFetchRequest *)fetchRequest
{
    [self.dataSource setResults:fetchRequest];
    [_gridView reloadData];
}

- (void)setContentOffset:(CGPoint)contentOffset
{
    _gridView.contentOffset = contentOffset;
}

- (CGPoint)contentOffset
{
    return _gridView.contentOffset;
}

- (void)setIsSelectable:(BOOL)selectable animated:(BOOL)animate
{
    _isSelectable = selectable;
    self.gridView.allowsMultipleSelection = self.isSelectable;

    for (ARGridViewCell *cell in self.gridView.visibleCells) {
        [cell setIsMultiSelectable:selectable animated:animate];
    }
}

- (BOOL)shouldUseSquareThumbnails
{
    switch (_displayMode) {
        case ARDisplayModeAllArtists:
        case ARDisplayModeAllAlbums:
        case ARDisplayModeAllShows:
        case ARDisplayModeArtistShows:
        case ARDisplayModeArtistAlbums:
        case ARDisplayModeInstallationShots:
            return YES;

        default:
            return NO;
    }
}

- (NSString *)thumbnailImageSize
{
    return (_shouldUseSquareThumbnails) ? ARFeedImageSizeSquareKey : ARFeedImageSizeMediumKey;
}

- (void)setEditing:(BOOL)isEditing
{
    [self setEditing:isEditing animated:YES];
}

- (void)setEditing:(BOOL)isEditing animated:(BOOL)animated
{
    _editing = isEditing;

    UIEdgeInsets insets = self.gridView.contentInset;
    CGFloat editingHeight = [UIDevice isPad] ? 72 : 20;
    insets.top = self.editing ? editingHeight : 0;
    [self.gridView setContentInset:insets];

    for (AREditableImageGridViewCell *cell in [_gridView visibleCells]) {
        [cell setEditing:self.editing animated:animated];
    }

    if (!isEditing) {
        for (NSIndexPath *path in [self.gridView indexPathsForSelectedItems].copy) {
            // no animating
            [self.gridView deselectItemAtIndexPath:path animated:NO];
        }
    }
}

- (void)selectAllItems
{
    [self.gridView.visibleCells each:^(ARGridViewCell *cell) {
        NSIndexPath *path = [self.gridView indexPathForCell:cell];
        id object = [self.dataSource objectAtIndexPath:path];

        BOOL supportsVisualSelection = ![object isKindOfClass:ARImageGridViewItem.class];
        [cell setVisuallySelected:supportsVisualSelection animated:YES];
    }];

    [self.selectionHandler selectObjects:[NSSet setWithArray:self.dataSource.allObjects]];
}

- (void)deselectAllItems
{
    [self.gridView.visibleCells each:^(ARGridViewCell *cell) {
        [cell setVisuallySelected:NO animated:YES];
    }];

    [self.selectionHandler deselectAllObjects];
}

- (NSArray *)selectedItems
{
    return [self.selectionHandler.selectedObjects select:^BOOL(id object) {
        return [self.dataSource.resultsController.fetchedObjects containsObject:object];
    }];
}

- (void)tintColorDidChange
{
    [super tintColorDidChange];

    BOOL whiteFolio = [AROptions boolForOption:AROptionsUseWhiteFolio];
    _gridView.indicatorStyle = whiteFolio ? UIScrollViewIndicatorStyleBlack : UIScrollViewIndicatorStyleWhite;
    _gridView.backgroundColor = [UIColor artsyBackgroundColor];
}

- (void)setCacheContext:(NSManagedObjectContext *)cacheContext
{
    _cacheContext = cacheContext;
    self.dataSource.cacheContext = cacheContext;
}

- (ARSelectionHandler *)selectionHandler
{
    return _selectionHandler ?: [ARSelectionHandler sharedHandler];
}

@end
