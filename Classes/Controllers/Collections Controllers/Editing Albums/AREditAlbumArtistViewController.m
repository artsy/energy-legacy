#import "AREditAlbumArtistViewController.h"
#import "ARSelectionHandler.h"
#import <ORStackView/ORStackView.h>
#import "ARSelectionToolbarView.h"
#import "ARAlbumEditNavigationController.h"
#import "ARBorderedSerifLabel.h"
#import "ARThumbnailImageScrollView.h"


@interface AREditAlbumArtistViewController ()
@property (nonatomic, strong) NSMutableSet *selectedInThisSession;
@property (nonatomic, strong) UIBarButtonItem *addButton;
@property (nonatomic, strong) UIBarButtonItem *toggleSelectionButton;
@property (nonatomic, strong) ARGridView *gridView;
@property (nonatomic, strong) ARSelectionHandler *selectionHandler;

@property (readonly, nonatomic, strong) ARBorderedSerifLabel *phoneTitleLabel;
@property (readonly, nonatomic, strong) NSLayoutConstraint *phoneTitleLabelHeightConstraint;

@property (readonly, nonatomic, strong) ARSelectionToolbarView *bottomToolbar;
@property (readonly, nonatomic, strong) UILabel *bottomSelectionStateLabel;

@end


@implementation AREditAlbumArtistViewController

- (instancetype)initWithArtist:(Artist *)artist
{
    self = [super init];
    if (!self) return nil;

    _artist = artist;
    _selectedInThisSession = [NSMutableSet set];

    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    if ([UIDevice isPad]) {
        self.toggleSelectionButton = [UIBarButtonItem toolbarButtonWithTitle:@"Select All" target:self action:@selector(toggleAllSelection)];
        self.navigationItem.rightBarButtonItems = @[ self.toggleSelectionButton ];
    }

    self.title = [self defaultMessage];
    [self selectionStateChangedAnimated:NO];
}

- (void)viewDidLoad
{
    ARGridView *gridView = [[ARGridView alloc] initWithDisplayMode:ARDisplayModeArtist];
    [gridView setIsSelectable:YES animated:NO];

    gridView.cacheContext = self.artist.managedObjectContext;
    [gridView setResults:self.artist.sortedArtworksFetchRequest];

    gridView.delegate = self;

    [self.view addSubview:gridView];
    gridView.frame = self.view.bounds;
    _gridView = gridView;

    _phoneTitleLabel = [[ARBorderedSerifLabel alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
    [self.view addSubview:_phoneTitleLabel];
    _phoneTitleLabelHeightConstraint = [[self.phoneTitleLabel constrainHeight:@"0"] firstObject];

    _bottomToolbar = [self createBottomToolbar];
    [self.view addSubview:self.bottomToolbar];

    if ([UIDevice isPad]) {
        _bottomSelectionStateLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 30, 300, 20)];
        _bottomSelectionStateLabel.textColor = [UIColor artsyForegroundColor];
        _bottomSelectionStateLabel.backgroundColor = [UIColor artsyBackgroundColor];
        _bottomSelectionStateLabel.font = [UIFont serifFontWithSize:ARFontSerifSmall];
    }

    [self.phoneTitleLabel alignTop:@"0" leading:@"0" bottom:nil trailing:@"0" toView:self.view];
    [gridView constrainTopSpaceToView:self.phoneTitleLabel predicate:@"0"];
    [gridView alignLeading:@"0" trailing:@"0" toView:self.view];

    [self.bottomToolbar constrainTopSpaceToView:gridView predicate:@"0"];
    [self.bottomToolbar alignTop:nil leading:@"0" bottom:@"0" trailing:@"0" toView:self.view];

    [super viewDidLoad];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (UIRectEdge)edgesForExtendedLayout
{
    return UIRectEdgeNone;
}

- (NSInteger)selectedInThisSessionCount
{
    return self.selectedInThisSession.count;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return [UIDevice isPad];
}

#pragma mark Nav buttons

- (void)toggleAllSelection
{
    if (self.allItemsAreSelected) {
        [self.gridView deselectAllItems];
    } else {
        [self.gridView selectAllItems];
    }
}

- (void)selectionStateChanged
{
    [self selectionStateChangedAnimated:NO];
}

- (void)selectionStateChangedAnimated:(BOOL)animated
{
    NSString *state = [(ARAlbumEditNavigationController *)self.navigationController descriptionOfSelectionState];
    self.phoneTitleLabel.label.text = state;

    [self showSubtitleView:(![UIDevice isPad] && state != nil)animated:animated];

    NSString *title = self.allItemsAreSelected ? @"Deselect All" : @"Select All";
    [self.toggleSelectionButton.representedButton setTitle:title.uppercaseString forState:UIControlStateNormal];

    [self.toggleSelectionButton.representedButton sizeToFit];
    [self.addButton.representedButton sizeToFit];
    [self updateBottomMenu];
}

- (void)showSubtitleView:(BOOL)show animated:(BOOL)animated
{
    [UIView animateIf:animated duration:ARAnimationDuration:^{
        self.phoneTitleLabelHeightConstraint.constant = show ? 46 : 0;
        self.phoneTitleLabel.label.alpha = show ? 1 : 0;
        [self.view setNeedsLayout];
        [self.view layoutIfNeeded];
    }];
}

- (NSString *)defaultMessage
{
    NSArray *alreadySelectedItems = [[ARSelectionHandler sharedHandler] selectedObjects].allObjects;
    NSArray *artistArtworks = [self.artist.managedObjectContext executeFetchRequest:self.artist.sortedArtworksFetchRequest error:nil];

    BOOL SelectedObjects = [alreadySelectedItems select:^BOOL(id object) {
        return [artistArtworks containsObject:object];
    }].count > 0;

    if (SelectedObjects) {
        return @"Select Items to Change";
    } else {
        return @"Select Items to Add";
    }
}

- (BOOL)allItemsAreSelected
{
    NSError *error = nil;
    NSFetchRequest *request = self.artist.sortedArtworksFetchRequest;
    NSUInteger count = [self.artist.managedObjectContext countForFetchRequest:request error:&error];
    if (error) {
        NSLog(@"Error getting a count for fetch request %@", request);
        count = 0;
    }
    return self.gridView.selectedItems.count == count;
}

- (void)saveChanges
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ARGridViewDelegate

- (BOOL)gridView:(ARGridView *)gridView canSelectItem:(id<ARGridViewItem>)anItem atIndex:(NSInteger)index
{
    return YES;
}

- (void)gridViewDidScroll:(ARGridView *)gridView
{
}

- (void)gridView:(ARGridView *)gridView didSelectItem:(Artwork *)artwork atIndex:(NSInteger)index
{
    [[ARSelectionHandler sharedHandler] selectObject:artwork];
    [self.selectedInThisSession addObject:artwork];
    [self selectionStateChangedAnimated:YES];
}

- (void)gridView:(ARGridView *)gridView didDeselectItem:(Artwork *)artwork atIndex:(NSInteger)index
{
    [[ARSelectionHandler sharedHandler] deselectObject:artwork];
    [self.selectedInThisSession removeObject:artwork];
    [self selectionStateChangedAnimated:YES];
}

- (void)selectItem:(Artwork *)artwork
{
    [[ARSelectionHandler sharedHandler] selectObject:artwork];
    [self.selectedInThisSession addObject:artwork];
    [self selectionStateChangedAnimated:YES];
}

- (void)deselectAllItems
{
    [self.gridView deselectAllItems];
}

- (void)setCover:(id<ARGridViewItem>)cover
{
}

- (ARSelectionHandler *)selectionHandler
{
    return _selectionHandler ?: [ARSelectionHandler sharedHandler];
}

- (void)popViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (ARSelectionToolbarView *)createBottomToolbar
{
    ARSelectionToolbarView *bottomToolbar = [[ARSelectionToolbarView alloc] initWithFrame:CGRectZero];
    bottomToolbar.horizontallyConstrained = ![UIDevice isPad];
    bottomToolbar.backgroundColor = [UIColor artsyBackgroundColor];
    bottomToolbar.attatchedToBottom = YES;
    return bottomToolbar;
}

- (void)updateBottomMenu
{
    ARAlbumEditNavigationController *nav = (id)self.navigationController;

    NSArray *buttons = [nav buttonsForCommitingChanges];
    self.bottomToolbar.barButtonItems = buttons;
    NSString *selectionState = [nav descriptionOfSelectionState];
    if ([UIDevice isPad] && selectionState) {
        _bottomSelectionStateLabel.text = selectionState;
        [self.bottomToolbar addSubview:_bottomSelectionStateLabel];

        NSArray *artworks = [nav selectedArtworks];
        NSArray *artworkImages = [[artworks map:^id(id object) {
            return [object mainImage];
        }] compact];

        if (artworkImages.count > 0) {
            ARThumbnailImageScrollView *thumbnailView = [self thumbnailViewForImages:artworkImages];
            thumbnailView.backgroundColor = [UIColor artsyBackgroundColor];
            [self.bottomToolbar addSubview:thumbnailView];
        }
    }
}

- (ARThumbnailImageScrollView *)thumbnailViewForImages:(NSArray *)images
{
    CGRect frame = CGRectMake(175, 4, 307, 75);

    ARThumbnailImageScrollView *thumbnailView = [[ARThumbnailImageScrollView alloc] initWithFrame:frame];
    thumbnailView.images = images;
    return thumbnailView;
}


@end
