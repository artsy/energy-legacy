#import <AFNetworking/AFNetworking.h>
#import <Artsy+UIFonts/UIFont+ArtsyFonts.h>

#import "ARAdminPartnerSelectViewController.h"
#import "NSDictionary+QueryString.h"
#import "ARRouter.h"
#import "ARTableViewCell.h"

const NSString *ARMetaData = @"metadata";


@implementation ARAdminPartnerSelectViewController {
    __weak IBOutlet UIActivityIndicatorView *_networkActivityIndicator;
    __weak IBOutlet UISearchBar *_searchBar;
    __weak IBOutlet UITableView *_tableView;
    __weak IBOutlet UILabel *_titleLabel;

    NSMutableArray *_JSONPartners;
    AFJSONRequestOperation *_searchRequestOperation;
    NSOperationQueue *_additionalInfoRequestsQueue;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _additionalInfoRequestsQueue = [[NSOperationQueue alloc] init];
    _titleLabel.font = [UIFont sansSerifFontWithSize:ARFontSansLarge];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_searchBar becomeFirstResponder];
}

- (void)viewDidUnload
{
    _tableView = nil;
    _searchBar = nil;
    _networkActivityIndicator = nil;
    _titleLabel = nil;
    [super viewDidUnload];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length) {
        [self searchForQuery:searchText];
    }
}

- (void)searchForQuery:(NSString *)searchText
{
    NSString *escapedString = [NSDictionary URLEscape:searchText];
    NSURLRequest *searchRequest = [ARRouter newSearchPartnersRequestWithQuery:escapedString];

    [_additionalInfoRequestsQueue cancelAllOperations];
    if (!_searchRequestOperation.isFinished) {
        [_searchRequestOperation cancel];
    }

    _searchRequestOperation = [AFJSONRequestOperation JSONRequestOperationWithRequest:searchRequest success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        _JSONPartners = [JSON mutableCopy];
        [_tableView reloadData];
        [_networkActivityIndicator stopAnimating];

    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [_networkActivityIndicator stopAnimating];
    }];

    [_networkActivityIndicator startAnimating];
    [_searchRequestOperation start];
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseIdentifier = NSStringFromClass([self class]);
    UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[ARTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    }

    cell.textLabel.text = _JSONPartners[indexPath.row][@"name"];

    if (_JSONPartners[indexPath.row][ARMetaData]) {
        cell.detailTextLabel.text = _JSONPartners[indexPath.row][ARMetaData];
    } else {
        [self getMetadataForPartnerAtIndex:indexPath.row];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_callback) {
        _callback(_JSONPartners[indexPath.row]);
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _JSONPartners.count;
}

- (void)getMetadataForPartnerAtIndex:(NSInteger)index
{
    NSDictionary *partnerDict = _JSONPartners[index];
    NSURLRequest *request = [ARRouter newPartnerInfoRequestWithID:partnerDict[ARFeedIDKey]];
    AFJSONRequestOperation *metadataRequest = nil;
    metadataRequest = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {

        NSString *formatString = @"%i Artists, %i Artworks & %i Documents.";
        NSString *metadata = [NSString stringWithFormat:formatString,
                                                        [JSON[ARFeedArtistsCountKey] integerValue],
                                                        [JSON[ARFeedArtworksCountKey] integerValue],
                                                        [JSON[ARFeedArtistDocumentsCountKey] integerValue] + [JSON[ARFeedShowDocumentsCountKey] integerValue]];

        NSMutableDictionary *newPartner = [@{ ARMetaData : metadata, ARFeedArtworksCountKey: JSON[ARFeedArtworksCountKey] } mutableCopy];
        [newPartner addEntriesFromDictionary:partnerDict];
        [_JSONPartners replaceObjectAtIndex:index withObject:newPartner];

        NSIndexPath *thisIndexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [_tableView reloadRowsAtIndexPaths:@[ thisIndexPath ] withRowAnimation:UITableViewRowAnimationAutomatic];

    } failure:nil];
    [_additionalInfoRequestsQueue addOperation:metadataRequest];
}

@end
