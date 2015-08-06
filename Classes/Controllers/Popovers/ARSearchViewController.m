#import "ARSearchViewController.h"
#import "ARGridViewController.h"
#import "ARTableHeaderView.h"
#import "ARTableViewCell.h"
#import "ARSearchBar.h"
#import "ARBrowseProvider.h"
#import "ARPopoverController.h"

static NSString *CellIdentifier = @"Search Result List Cell";


@interface SearchResult : NSObject
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *slug;
@property (nonatomic, strong) NSString *entityClass;
@end


@implementation SearchResult

@end


@interface ARSearchViewController () {
    IBOutlet UITableView *_browseTableView;
    IBOutlet ARSearchBar *_searchBar;
    IBOutlet UISearchDisplayController *_searchDisplayController;
    IBOutlet UILabel *_searchPlaceholderLabel;

    IBOutlet ARUnderLinedSwitchView *_modeSwitch;
    ARBrowseDisplayMode _selectionState;

    NSOperationQueue *_searchOperationQueue;

    NSString *_searchString;
    NSMutableArray *_searchResults;
    NSMutableArray *_sectionHeaders;
    NSMutableArray *_numberOfSearchResultsPerSection;
}

@end


@implementation ARSearchViewController

+ (ARSearchViewController *)sharedController
{
    static ARSearchViewController *_sharedController = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedController = [[self alloc] init];
    });

    return _sharedController;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    _browseTableView.delegate = nil;
    [_searchOperationQueue cancelAllOperations];
}

- (instancetype)init
{
    self = [super init];
    if (!self) return nil;

    _sectionHeaders = [[NSMutableArray alloc] init];
    _numberOfSearchResultsPerSection = [[NSMutableArray alloc] init];
    _browseProvider = [[ARBrowseProvider alloc] init];

    _browseTableView.separatorInset = UIEdgeInsetsZero;

    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.browseProvider.managedObjectContext = self.managedObjectContext;

    _browseTableView.accessibilityLabel = @"SearchTableView";
    _selectionState = ARBrowseDisplayModeArtists;

    [self setupSwitchNavigation];
    _searchPlaceholderLabel.font = [UIFont serifFontWithSize:ARFontSerif];
}

- (void)viewWillAppear:(BOOL)animated
{
    NSInteger selectionState = _selectionState;
    if (![self partnerIsGallery] && selectionState > 0) {
        selectionState--;
    }

    [_modeSwitch setSelectedIndex:selectionState animated:NO];
    [super viewWillAppear:animated];
    [self.browseProvider refreshWithTableView:_browseTableView];

    _browseTableView.delegate = self.browseProvider;
    _browseTableView.dataSource = self.browseProvider;

    [_browseTableView reloadData];

    // Must be done here to ensure search bar has been completely setup before creating its button
    [_searchBar setupCancelButton];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [_searchBar cancelSearchField];
    [_browseTableView reloadData];

    [super viewWillDisappear:animated];
}

#pragma mark -
#pragma mark Switch Navigation

- (void)setupSwitchNavigation
{
    _modeSwitch.accessibilityLabel = @"Search Switch";
    _modeSwitch.style = ARSwitchViewStyleWhiteSmallSansSerif;
    _modeSwitch.delegate = self;

    NSString *artists = NSLocalizedString(@"Artists", @"Artist Collective Noun");
    NSString *shows = NSLocalizedString(@"Shows", @"Show Collective Noun");
    NSString *locations = NSLocalizedString(@"Locations", @"Location Collective Noun");
    NSString *albums = NSLocalizedString(@"Albums", @"Album Collective Noun");

    NSString *centerTitle = [self partnerIsGallery] ? shows : locations;
    [_modeSwitch setTitles:@[ artists, centerTitle, albums ]];

    [_modeSwitch setSelectedIndex:_selectionState animated:NO];
}

- (BOOL)partnerIsGallery
{
    Partner *partner = [Partner currentPartnerInContext:self.managedObjectContext];
    switch (partner.type) {
        case ARPartnerTypeGallery:
            return YES;

        case ARPartnerTypeCollector:
            return NO;
    }
}

- (void)switchView:(ARUnderLinedSwitchView *)switchView didSelectIndex:(NSInteger)index animated:(BOOL)animated
{
    switch ([self displayModeForIndex:index]) {
        case ARBrowseDisplayModeArtists:
            [self artistTapped:self];
            break;
        case ARBrowseDisplayModeShows:
            [self showTapped:self];
            break;
        case ARBrowseDisplayModeLocations:
            [self locationsTapped:self];
            break;
        case ARBrowseDisplayModeAlbums:
            [self albumTapped:self];
            break;
    }
}

- (ARBrowseDisplayMode)displayModeForIndex:(NSInteger)index
{
    // Because we use an enum to represent the current view mode
    // we need to manipulate the index depnding on if it is
    // a partner or not, as we cannot hide a tab in the switchboard

    if (![self partnerIsGallery] && index > 0) {
        index++;
    }

    if ([self partnerIsGallery] && index == 2) {
        index++;
    }
    return index;
}

- (CGSize)preferredContentSize
{
    return CGSizeMake(320, 600);
}

- (void)setSelectedItem:(id)selectedItem
{
    if (_selectedItem != selectedItem) {
        _selectedItem = selectedItem;
        self.browseProvider.selectedItem = selectedItem;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView
{
    return [_sectionHeaders count];
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
    return [(NSNumber *)_numberOfSearchResultsPerSection[section] intValue];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat sectionHeaderHeight = 0;
    if ([_sectionHeaders count]) {
        sectionHeaderHeight = [ARTableHeaderView heightOfCell];
    }
    return sectionHeaderHeight;
}

- (UIView *)tableView:(UITableView *)aTableView viewForHeaderInSection:(NSInteger)section
{
    if (section < [_sectionHeaders count]) {
        CGRect frame = CGRectMake(0, 0, CGRectGetWidth(aTableView.frame), [ARTableHeaderView heightOfCell]);
        return [[ARTableHeaderView alloc] initWithFrame:frame title:_sectionHeaders[section] style:ARTableHeaderViewStyleDark];
    } else {
        return [[UIView alloc] initWithFrame:CGRectNull];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ARTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (indexPath.row < [_searchResults count]) {
        NSUInteger position = [self positionAtIndexPath:indexPath];
        if (position < [_searchResults count]) {
            SearchResult *result = _searchResults[position];
            NSString *titleString = result.title;
            cell.textLabel.text = titleString;
        }
    }

    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.useSerifFont = YES;
    return cell;
}

- (NSUInteger)positionAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger position = 0;
    for (int i = 0; i < indexPath.section; i++) {
        if (i < [_numberOfSearchResultsPerSection count]) {
            position += [_numberOfSearchResultsPerSection[i] unsignedIntValue];
        }
    }
    position += indexPath.row;
    return position;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *header = @"";
    if (section < [_sectionHeaders count]) {
        header = _sectionHeaders[section];
    }
    return [header uppercaseString];
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ARPopoverController *oldHost = _hostController;
    NSUInteger position = [self positionAtIndexPath:indexPath];
    if (position < [_searchResults count]) {
        SearchResult *result = _searchResults[position];
        NSManagedObjectContext *context = self.managedObjectContext;
        Class klass = NSClassFromString(result.entityClass);
        id object = [klass findFirstByAttribute:@"slug" withValue:result.slug inContext:context];

        if ([object isKindOfClass:[Artwork class]]) {
            [_delegate searchViewController:self didSelectArtwork:object];
        } else if ([object isKindOfClass:[Album class]]) {
            [_delegate searchViewController:self didSelectAlbum:object];
        } else if ([object isKindOfClass:[Artist class]]) {
            [_delegate searchViewController:self didSelectArtist:object];
        } else if ([object isKindOfClass:[Show class]]) {
            [_delegate searchViewController:self didSelectShow:object];
        } else if ([object isKindOfClass:[Location class]]) {
            [_delegate searchViewController:self didSelectLocation:object];
        }
    }

    // If we've moved ViewControllers
    if (oldHost != _hostController) {
        [oldHost dismissPopoverAnimated:YES];
    }
}

- (IBAction)locationsTapped:(id)sender
{
    [ARAnalytics event:ARSearchTabEvent withProperties:@{ @"tab" : @"location" }];
    _selectionState = ARBrowseDisplayModeLocations;
    self.browseProvider.currentDisplayMode = ARBrowseDisplayModeLocations;
    [_sectionHeaders removeAllObjects];
    [_browseTableView reloadData];
}


- (IBAction)showTapped:(id)sender
{
    [ARAnalytics event:ARSearchTabEvent withProperties:@{ @"tab" : @"show" }];
    _selectionState = ARBrowseDisplayModeShows;
    self.browseProvider.currentDisplayMode = ARBrowseDisplayModeShows;
    [_sectionHeaders removeAllObjects];
    [_browseTableView reloadData];
}

- (IBAction)artistTapped:(id)sender
{
    [ARAnalytics event:ARSearchTabEvent withProperties:@{ @"tab" : @"artist" }];
    _selectionState = ARBrowseDisplayModeArtists;
    self.browseProvider.currentDisplayMode = ARBrowseDisplayModeArtists;

    [_sectionHeaders removeAllObjects];
    [_browseTableView reloadData];
}

- (IBAction)albumTapped:(id)sender
{
    [ARAnalytics event:ARSearchTabEvent withProperties:@{ @"tab" : @"album" }];
    _selectionState = ARBrowseDisplayModeAlbums;
    self.browseProvider.currentDisplayMode = ARBrowseDisplayModeAlbums;

    [_sectionHeaders removeAllObjects];
    [_browseTableView reloadData];
}

// Our custom search view needs to know when to show / hide the cancel button

- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
    controller.searchResultsTableView.separatorInset = UIEdgeInsetsZero;
    [_searchBar showCancelButton:YES];

    [ARAnalytics event:ARSearchFieldFocusedEvent];
    [UIView animateWithDuration:0.2 animations:^{
        _searchPlaceholderLabel.alpha = 0;
    }];
}

- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller
{
    [_searchBar showCancelButton:NO];

    [UIView animateWithDuration:0.2 animations:^{
        _searchPlaceholderLabel.alpha = 1;
    }];
}


#pragma mark - UISearchDisplayDelegate methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)query
{
    if (!_searchDisplayController) {
        _searchDisplayController = controller;
    }
    [_searchDisplayController.searchResultsTableView registerClass:[ARTableViewCell class] forCellReuseIdentifier:CellIdentifier];

    BOOL result = NO;
    [_searchOperationQueue cancelAllOperations];
    if (!_searchOperationQueue) {
        _searchOperationQueue = [[NSOperationQueue alloc] init];
    }

    _searchString = query;
    if ([query length] > 0) {
        NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self
                                                                                selector:@selector(performSearchForText:)
                                                                                  object:query];
        [_searchOperationQueue addOperation:operation];
    } else {
        @synchronized(_searchResults)
        {
            _searchResults = nil;
        }
        result = YES;
    }
    return result;
}

- (void)performSearchForText:(NSString *)query
{
    if (_searchString && query != _searchString) return;

    NSManagedObjectContext *context = self.managedObjectContext;
    NSMutableArray *newSearchResults = [NSMutableArray array];

    // MAKE SURE the next three arrays have the same number of items: logic below depends on this
    NSArray *entityNames = @[ @"Artist", @"Album", @"Artwork", @"Show", @"Location" ];
    NSArray *entitySearchKeys = @[ @"name", @"name", @"title", @"name", @"name" ];
    NSArray *entityOrderKeys = @[ @"orderingKey", @"name", @"title", @"name", @"name" ];

    [_numberOfSearchResultsPerSection removeAllObjects];
    [_sectionHeaders removeAllObjects];

    for (NSString *entityName in entityNames) {
        NSInteger index = [entityNames indexOfObject:entityName];
        NSString *searchKey = entitySearchKeys[index];

        NSString *predicatePrefix = @"";
        if ([entityName isEqualToString:@"Artwork"]) {
            predicatePrefix = @"images.@count > 0 AND ";
        }

        // For a single length query compare the first letter only
        NSString *action = (query.length == 1) ? @"beginswith" : @"contains";
        NSString *predicateFormat = [NSString stringWithFormat:@"%@%@ %@[cd] %%@", predicatePrefix, searchKey, action];

        NSArray *matchingEntities = [self searchResultsForEntityWithName:entityName
                                                         predicateFormat:predicateFormat
                                                        containingString:query
                                                                sortedBy:entityOrderKeys[index]
                                                               inContext:context];
        // cancel if search string has changed inbetween
        if (_searchString && query != _searchString) return;

        NSArray *resultSet = [self searchResultSetWithEntityName:entityName entities:matchingEntities];
        [newSearchResults addObjectsFromArray:resultSet];

        // As this is called in an operation atomicly update the search results
        @synchronized(_searchResults)
        {
            _searchResults = newSearchResults;
        }

        if ([resultSet count]) {
            [_sectionHeaders addObject:entityName];
            [_numberOfSearchResultsPerSection addObject:@(resultSet.count)];
        }
        [self performSelectorOnMainThread:@selector(reloadSearchResults) withObject:nil waitUntilDone:NO];
    }
    [self performSelectorOnMainThread:@selector(allSearchesPerformed) withObject:nil waitUntilDone:NO];
}

- (NSArray *)searchResultSetWithEntityName:(NSString *)entityName entities:(NSArray *)entities
{
    NSMutableArray *resultSet = [[NSMutableArray alloc] init];

    for (ARManagedObject<ARGridViewItem> *managedObject in entities) {
        SearchResult *result = [[SearchResult alloc] init];
        BOOL isArtwork = [managedObject isKindOfClass:[Artwork class]];
        result.title = isArtwork ? managedObject.gridSubtitle : managedObject.gridTitle;
        result.slug = managedObject.slug;
        result.entityClass = entityName;
        [resultSet addObject:result];
    }
    return resultSet;
}

- (void)reloadSearchResults
{
    [_searchDisplayController.searchResultsTableView reloadData];
}

- (void)allSearchesPerformed
{
    // Do we have an empty results label?
    if (_searchResults.count == 0) {
        for (UIView *subview in _searchDisplayController.searchResultsTableView.subviews) {
            if ([subview isKindOfClass:[UILabel class]]) {
                UILabel *noResultsLabel = (UILabel *)subview;
                noResultsLabel.font = [UIFont sansSerifFontWithSize:ARFontSansLarge];
                noResultsLabel.text = [noResultsLabel.text uppercaseString];
            }
        }
    }
}

- (NSArray *)searchResultsForEntityWithName:(NSString *)name
                            predicateFormat:(NSString *)formatString
                           containingString:(NSString *)string
                                   sortedBy:(NSString *)sortTerm
                                  inContext:(NSManagedObjectContext *)context
{
    id classForEntity = NSClassFromString(name);
    NSPredicate *predicate = [NSPredicate predicateWithFormat:formatString, string];
    NSArray *results = [classForEntity findAllSortedBy:sortTerm
                                             ascending:YES
                                         withPredicate:predicate
                                             inContext:context];
    return results;
}

- (NSArray *)searchResults
{
    return [NSArray arrayWithArray:_searchResults];
}

#pragma mark - stylizing the search results

- (void)reset
{
    [_sectionHeaders removeAllObjects];
    [_browseTableView reloadData];

    if (_searchDisplayController && _searchDisplayController.searchResultsTableView && _searchDisplayController.searchBar) {
        _searchDisplayController.searchBar.text = nil;
    }
}

- (void)viewDidUnload
{
    _searchPlaceholderLabel = nil;
    [super viewDidUnload];
}

- (NSManagedObjectContext *)managedObjectContext
{
    return _managedObjectContext ?: [CoreDataManager mainManagedObjectContext];
}


@end
