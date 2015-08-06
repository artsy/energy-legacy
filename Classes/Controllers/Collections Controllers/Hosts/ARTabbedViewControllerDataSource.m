#import "ARTabbedViewControllerDataSource.h"

#import "ARArtworkContainerViewController.h"
#import "ARDocumentContainerViewController.h"
#import "AROptions.h"

NS_ENUM(NSInteger, ARTabbedDataSourceOption){
    ARTabbedDataSourceOptionArtworks,
    ARTabbedDataSourceOptionShows,
    ARTabbedDataSourceOptionAlbums,
    ARTabbedDataSourceOptionInstallShots,
    ARTabbedDataSourceOptionDocuments};


@interface ARTabbedViewControllerDataSource ()
@property (readonly, nonatomic, strong) id representedObject;
@property (readonly, nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (readonly, nonatomic, strong) ARSelectionHandler *selectionHandler;
@end


@implementation ARTabbedViewControllerDataSource

- (instancetype)initWithRepresentedObject:(id)representedObject managedObjectContext:(NSManagedObjectContext *)context selectionHandler:(ARSelectionHandler *)selectionHandler
{
    self = [super init];
    if (!self) return nil;

    NSMutableArray *titles = [NSMutableArray array];

    if ([representedObject conformsToProtocol:@protocol(ARArtworkContainer)]) {
        [titles addObject:[self titleForOption:ARTabbedDataSourceOptionArtworks]];
    }

    if ([representedObject respondsToSelector:@selector(showsFeaturingArtist)]) {
        [titles addObject:[self titleForOption:ARTabbedDataSourceOptionShows]];
    }

    if ([representedObject respondsToSelector:@selector(albumsFeaturingArtist)]) {
        [titles addObject:[self titleForOption:ARTabbedDataSourceOptionAlbums]];
    }

    if ([representedObject conformsToProtocol:@protocol(ARDocumentContainer)]) {
        [titles addObject:[self titleForOption:ARTabbedDataSourceOptionDocuments]];
    }

    if ([representedObject respondsToSelector:@selector(installationImages)]) {
        [titles addObject:[self titleForOption:ARTabbedDataSourceOptionInstallShots]];
    }

    _potentialTitles = [NSArray arrayWithArray:titles];

    _representedObject = representedObject;
    _managedObjectContext = context;
    _selectionHandler = selectionHandler;

    return self;
}

#pragma mark -
#pragma mark Tab View Data Source Methods

- (enum ARTabbedDataSourceOption)optionForIndex:(NSInteger)index
{
    NSString *title = self.potentialTitles[index];
    if ([title isEqualToString:[self titleForOption:ARTabbedDataSourceOptionArtworks]]) return ARTabbedDataSourceOptionArtworks;
    if ([title isEqualToString:[self titleForOption:ARTabbedDataSourceOptionShows]]) return ARTabbedDataSourceOptionShows;
    if ([title isEqualToString:[self titleForOption:ARTabbedDataSourceOptionAlbums]]) return ARTabbedDataSourceOptionAlbums;
    if ([title isEqualToString:[self titleForOption:ARTabbedDataSourceOptionDocuments]]) return ARTabbedDataSourceOptionDocuments;
    if ([title isEqualToString:[self titleForOption:ARTabbedDataSourceOptionInstallShots]]) return ARTabbedDataSourceOptionInstallShots;

    return ARTabbedDataSourceOptionArtworks;
}

- (NSInteger)indexForOption:(enum ARTabbedDataSourceOption)option
{
    NSString *title = [self titleForOption:option];
    return [self.potentialTitles indexOfObject:title];
}

- (NSString *)titleForOption:(enum ARTabbedDataSourceOption)option
{
    switch (option) {
        case ARTabbedDataSourceOptionArtworks:
            return NSLocalizedString(@"Works", @"Artworks Switch Title");

        case ARTabbedDataSourceOptionShows:
            return NSLocalizedString(@"Shows", @"Shows Switch Title");

        case ARTabbedDataSourceOptionAlbums:
            return NSLocalizedString(@"Albums", @"Albums Switch Title");

        case ARTabbedDataSourceOptionDocuments:
            return NSLocalizedString(@"Documents", @"Documents Switch Title");

        case ARTabbedDataSourceOptionInstallShots:
            return NSLocalizedString(@"Installs", @"Installation Shots Switch Title");
    }
}

- (UIViewController *)viewControllerForTabView:(ARTabContentView *)tabView atIndex:(NSInteger)index
{
    ARGridViewController *controller = nil;

    switch ([self optionForIndex:index]) {
        case ARTabbedDataSourceOptionArtworks:
            controller = [self createArtworkViewController];
            break;

        case ARTabbedDataSourceOptionShows:
            controller = [self createArtistShowsViewController];
            break;

        case ARTabbedDataSourceOptionAlbums:
            controller = [self createArtistAlbumsViewController];
            break;

        case ARTabbedDataSourceOptionDocuments:
            controller = [self createDocumentViewController];
            break;

        case ARTabbedDataSourceOptionInstallShots:
            controller = [self createInstallShotsViewController];
    }

    controller.managedObjectContext = self.managedObjectContext;
    controller.selectionHandler = self.selectionHandler;
    return controller;
}

- (BOOL)tabView:(ARTabContentView *)tabView canPresentViewControllerAtIndex:(NSInteger)index
{
    switch ([self optionForIndex:index]) {
        case ARTabbedDataSourceOptionArtworks:
            return YES;

        case ARTabbedDataSourceOptionShows:
            return ([self.representedObject respondsToSelector:@selector(showsFeaturingArtist)] &&
                    ([self.representedObject showsFeaturingArtist].count > 0));

        case ARTabbedDataSourceOptionAlbums:
            return ([self.representedObject respondsToSelector:@selector(albumsFeaturingArtist)] &&
                    ([self.representedObject albumsFeaturingArtist].count > 0));

        case ARTabbedDataSourceOptionDocuments:
            return ([self.representedObject respondsToSelector:@selector(sortedDocuments)] &&
                    ([self.representedObject sortedDocuments].count > 0));

        case ARTabbedDataSourceOptionInstallShots:
            return ([self.representedObject respondsToSelector:@selector(installationImages)] &&
                    ([self.representedObject installationImages].count > 0));
    }

    return NO;
}

- (NSInteger)numberOfViewControllersForTabView:(ARTabContentView *)tabView
{
    return self.potentialTitles.count;
}

- (ARGridViewController *)createArtworkViewController
{
    return [[ARArtworkContainerViewController alloc] initWithArtworkContainer:self.representedObject];
}

- (ARGridViewController *)createDocumentViewController
{
    return [[ARDocumentContainerViewController alloc] initWithDocumentContainer:self.representedObject];
}

- (ARGridViewController *)createArtistShowsViewController
{
    ARGridViewController *gridView = [[ARGridViewController alloc] initWithDisplayMode:ARDisplayModeArtistShows];
    gridView.results = [self.representedObject showsFeaturingArtistFetchRequest];
    return gridView;
}

- (ARGridViewController *)createArtistAlbumsViewController
{
    ARGridViewController *gridView = [[ARGridViewController alloc] initWithDisplayMode:ARDisplayModeArtistAlbums];
    gridView.results = [self.representedObject albumsFeaturingArtistFetchRequest];
    return gridView;
}

- (ARGridViewController *)createInstallShotsViewController
{
    ARGridViewController *gridView = [[ARGridViewController alloc] initWithDisplayMode:ARDisplayModeInstallationShots];
    gridView.results = [self.representedObject installationShotsFetchRequestInContext:self.managedObjectContext];
    return gridView;
}


@end
