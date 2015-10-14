#import <Artsy+UIFonts/UIFont+ArtsyFonts.h>
#import "AREditAlbumViewController.h"
#import "ARNavigationController.h"
#import "ARSelectionHandler.h"
#import "AREditAlbumArtistViewController.h"
#import "ARAddArtworksTableViewCell.h"
#import "ARSelectionToolbarView.h"
#import "ARAlbumEditNavigationController.h"
#import "ARBorderedSerifLabel.h"
#import "ARThumbnailImageScrollView.h"


@interface AREditAlbumViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, assign) NSInteger initialArtworksCount;
@property (nonatomic, strong) NSFetchedResultsController *allArtistsFetchController;
@property (nonatomic, strong) ARSelectionHandler *selectionHandler;

@property (readonly, nonatomic, strong) ARSelectionToolbarView *bottomToolbar;
@property (readonly, nonatomic, strong) UILabel *bottomSelectionStateLabel;

@property (readonly, nonatomic, strong) ARBorderedSerifLabel *phoneTitleLabel;
@property (readonly, nonatomic, strong) NSLayoutConstraint *phoneTitleLabelHeightConstraint;

@end


@implementation AREditAlbumViewController

- (instancetype)initWithAlbum:(Album *)album
{
    NSParameterAssert(album);

    self = [super init];
    if (!self) return nil;

    _album = album;
    self.edgesForExtendedLayout = UIRectEdgeNone;

    NSFetchRequest *fetchRequest = [Artist allArtistsFetchRequestInContext:_album.managedObjectContext defaults:self.defaults];
    _allArtistsFetchController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                     managedObjectContext:_album.managedObjectContext
                                                                       sectionNameKeyPath:nil
                                                                                cacheName:nil];
    [_allArtistsFetchController performFetch:nil];

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor artsyBackgroundColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];

    if ([UIDevice isPad]) {
        _bottomSelectionStateLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 30, 140, 20)];
        _bottomSelectionStateLabel.textColor = [UIColor artsyForegroundColor];
        _bottomSelectionStateLabel.textAlignment = NSTextAlignmentLeft;
        _bottomSelectionStateLabel.backgroundColor = [UIColor artsyBackgroundColor];
        _bottomSelectionStateLabel.font = [UIFont serifFontWithSize:ARFontSerifSmall];
    }

    _phoneTitleLabel = [[ARBorderedSerifLabel alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
    [self.view addSubview:_phoneTitleLabel];
    _phoneTitleLabelHeightConstraint = [[self.phoneTitleLabel constrainHeight:@"50"] firstObject];

    [self.phoneTitleLabel alignTop:@"0" leading:@"0" bottom:nil trailing:@"0" toView:self.view];
    [self.tableView constrainTopSpaceToView:self.phoneTitleLabel predicate:@"0"];

    [self.tableView alignTop:nil leading:@"0" bottom:nil trailing:@"0" toView:self.view];

    _bottomToolbar = [self createBottomToolbar];
    [self.view addSubview:self.bottomToolbar];

    [self.bottomToolbar constrainTopSpaceToView:self.tableView predicate:@"0"];
    [self.bottomToolbar alignTop:nil leading:@"0" bottom:@"0" trailing:@"0" toView:self.view];

    // This will ensure the grid view is in selection mode
    [self.selectionHandler startSelectingForAlbum:self.album];
    _initialArtworksCount = self.selectionHandler.selectedObjects.count;

    self.view.backgroundColor = [UIColor artsyBackgroundColor];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 20, 0, 20);
    self.tableView.separatorColor = [UIColor artsySingleLineGrey];

    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:animated];

    [self updateTitle];
    [self updateBottomMenu];
    [self updateSubtitleAnimated:NO];

    [super viewWillAppear:animated];
}

- (void)updateTitle
{
    NSInteger selectedObjectsCount = self.selectionHandler.selectedObjects.count;
    NSInteger delta = selectedObjectsCount - self.initialArtworksCount;

    NSString *title = nil;
    if (delta == 0 && self.initialArtworksCount == 0) {
        title = [NSString stringWithFormat:@"Add Items To '%@'", self.album.name];
    } else {
        title = [NSString stringWithFormat:@"Edit '%@'", self.album.name];
    }

    self.title = title;
}

- (void)updateSubtitleAnimated:(BOOL)animated
{
    NSString *state = [(ARAlbumEditNavigationController *)self.navigationController descriptionOfSelectionState];
    self.phoneTitleLabel.label.text = state;
    [self showSubtitleView:(![UIDevice isPad] && state != nil)animated:animated];
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

- (void)updateBottomMenu
{
    NSArray *buttons = [(ARAlbumEditNavigationController *)self.navigationController buttonsForCommitingChanges];
    self.bottomToolbar.barButtonItems = buttons;
    NSString *selectionState = [self getSelectionState];
    if ([UIDevice isPad] && selectionState) {
        _bottomSelectionStateLabel.text = selectionState;
        [self.bottomToolbar addSubview:_bottomSelectionStateLabel];

        NSArray *artworks = [(ARAlbumEditNavigationController *)self.navigationController selectedArtworks];
        NSArray *artworkImages = [artworks valueForKeyPath:@"mainImage"];

        if (artworkImages.count > 0) {
            ARThumbnailImageScrollView *thumbnailView = [self thumbnailViewForImages:artworkImages];
            thumbnailView.backgroundColor = [UIColor artsyBackgroundColor];
            [self.bottomToolbar addSubview:thumbnailView];
        }
    }
}

- (NSString *)getSelectionState
{
    return [(ARAlbumEditNavigationController *)self.navigationController descriptionOfSelectionState];
}

- (void)setTitle:(NSString *)title
{
    [super setTitle:title.uppercaseString];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (ARThumbnailImageScrollView *)thumbnailViewForImages:(NSArray *)images
{
    CGRect frame = CGRectMake(175, 4, 307, 75);

    ARThumbnailImageScrollView *thumbnailView = [[ARThumbnailImageScrollView alloc] initWithFrame:frame];
    thumbnailView.images = images;
    return thumbnailView;
}


#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Artist *artist = [self.allArtistsFetchController objectAtIndexPath:indexPath];
    AREditAlbumArtistViewController *artistVC = [[AREditAlbumArtistViewController alloc] initWithArtist:artist];
    [self.navigationController pushViewController:artistVC animated:YES];
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return self.allArtistsFetchController.fetchedObjects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    ARAddArtworksTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EditAlbumArtistCell"];
    if (!cell) {
        cell = [[ARAddArtworksTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"EditAlbumArtistCell"];
    }

    Artist *artist = [self.allArtistsFetchController objectAtIndexPath:indexPath];
    [cell setupWithArtist:artist];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 76;
}

- (ARSelectionToolbarView *)createBottomToolbar
{
    ARSelectionToolbarView *bottomToolbar = [[ARSelectionToolbarView alloc] initWithFrame:CGRectZero];
    bottomToolbar.horizontallyConstrained = ![UIDevice isPad];
    bottomToolbar.backgroundColor = [UIColor artsyBackgroundColor];
    bottomToolbar.attatchedToBottom = YES;
    return bottomToolbar;
}

- (ARSelectionHandler *)selectionHandler
{
    return _selectionHandler ?: ARSelectionHandler.sharedHandler;
}

- (NSUserDefaults *)defaults
{
    return _defaults ?: NSUserDefaults.standardUserDefaults;
}

@end
