#import "ARBrowseProvider.h"
#import "NSFetchedResultsController+Count.h"
#import "ARTableViewCell.h"
#import "ARSwitchBoard.h"

static NSString *CellIdentifier = @"Search Result List Cell";


@interface ARBrowseProvider ()
@property (nonatomic, strong) NSFetchedResultsController *artists;
@property (nonatomic, strong) NSFetchedResultsController *shows;
@property (nonatomic, strong) NSFetchedResultsController *albums;
@property (nonatomic, strong) NSFetchedResultsController *locations;
@end


@implementation ARBrowseProvider

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self resultsForDisplayMode:self.currentDisplayMode] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ARTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    NSManagedObject *selected = [self.currentResults objectAtIndexPath:indexPath];
    cell.textLabel.text = [self textForObject:selected];

    if ([selected isEqual:self.selectedItem]) {
        cell.contentView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    } else {
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObject *object = [self.currentResults objectAtIndexPath:indexPath];
    if ([object isEqual:self.selectedItem]) {
        return;
    }

    ARSwitchBoard *switchBoard = [ARSwitchBoard sharedSwitchboard];
    switch (self.currentDisplayMode) {
        case ARBrowseDisplayModeAlbums:
            [ARAnalytics event:ARSearchSelectAlbumEvent];
            [switchBoard jumpToAlbumViewController:(Album *)object animated:YES];
            break;
        case ARBrowseDisplayModeShows:
            [ARAnalytics event:ARSearchSelectShowEvent];
            [switchBoard jumpToShowViewController:(Show *)object animated:YES];
            break;
        case ARBrowseDisplayModeArtists:
            [ARAnalytics event:ARSearchSelectArtistEvent];
            [switchBoard jumpToArtistViewController:(Artist *)object animated:YES];
            break;
        case ARBrowseDisplayModeLocations:
            [ARAnalytics event:ARSearchSelectLocationEvent];
            [switchBoard jumpToLocationViewController:(Location *)object animated:YES];
            break;
    }
}

- (void)refreshWithTableView:(UITableView *)tableView
{
    // This is a pretty awkward place to put it
    // (and pretty awkward to have to pass the TV in)
    // but it's gotta go somewhere right?

    [tableView registerClass:[ARTableViewCell class] forCellReuseIdentifier:CellIdentifier];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    NSManagedObjectContext *context = self.managedObjectContext;
    self.artists = [self controllerForRequest:[Artist allArtistsFetchRequestInContext:context] context:context];
    self.albums = [self controllerForRequest:[Album allAlbumsFetchRequestInContext:context] context:context];
    self.shows = [self controllerForRequest:[Show allShowsFetchRequestInContext:context] context:context];
    self.locations = [self controllerForRequest:[Location allLocationsFetchRequestInContext:context defaults:defaults] context:context];
}

- (NSFetchedResultsController *)currentResults
{
    return [self resultsForDisplayMode:self.currentDisplayMode];
}

- (NSFetchedResultsController *)resultsForDisplayMode:(ARBrowseDisplayMode)displayMode
{
    switch (displayMode) {
        case ARBrowseDisplayModeArtists:
            return self.artists;
        case ARBrowseDisplayModeAlbums:
            return self.albums;
        case ARBrowseDisplayModeShows:
            return self.shows;
        case ARBrowseDisplayModeLocations:
            return self.locations;
    }
}

- (NSString *)textForObject:(NSManagedObject *)object
{
    if ([object respondsToSelector:@selector(searchDisplayName)]) {
        return [(id)object searchDisplayName];

    } else if ([object respondsToSelector:@selector(name)]) {
        return [(id)object name];
    }

    NSLog(@"Unsupported object for browse! %@", object);
    return @"";
}

- (NSFetchedResultsController *)controllerForRequest:(NSFetchRequest *)fetchRequest context:(NSManagedObjectContext *)context
{
    NSFetchedResultsController *controller = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                                 managedObjectContext:context
                                                                                   sectionNameKeyPath:nil
                                                                                            cacheName:nil];
    NSError *error = nil;
    BOOL success = [controller performFetch:&error];
    if (!success) {
        NSLog(@"Core Data Error!  Couldn't perform fetch for %@", fetchRequest);
        return nil;
    }
    return controller;
}

@end
