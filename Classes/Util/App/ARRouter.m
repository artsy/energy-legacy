#import "ARRouter.h"
#import "UIDevice+UserAgent.h"
#import <Keys/FolioKeys.h>

static AFHTTPClient *httpClient = nil;
static NSURL *staticBaseURL = nil;


@implementation ARRouter

+ (void)setup
{
    [ARRouter setupWithBaseURL:ARBaseURL];
}

+ (AFHTTPClient *)client
{
    return httpClient;
}

+ (void)setupWithBaseURL:(NSString *)baseURL
{
    NSURL *url = [NSURL URLWithString:baseURL];
    httpClient = [AFHTTPClient clientWithBaseURL:url];
    [httpClient setDefaultHeader:@"User-Agent" value:[UIDevice userAgent]];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:AROAuthToken];
    if (token) {
        [ARRouter setAuthToken:token];
    }
    staticBaseURL = [NSURL URLWithString:ARStaticBaseURL];
}

+ (NSURL *)baseURL
{
    return httpClient.baseURL;
}

+ (NSURL *)fullURLForImage:(NSString *)urlString
{
    if ([urlString hasPrefix:@"http"]) {
        return [NSURL URLWithString:urlString];
    } else {
        return [NSURL URLWithString:urlString relativeToURL:staticBaseURL];
    }
}

+ (NSURLRequest *)requestForURL:(NSURL *)url
{
    return [httpClient requestWithMethod:@"GET" path:url.path parameters:nil];
}

#pragma mark -
#pragma mark OAuth

+ (void)setAuthToken:(NSString *)token
{
    [httpClient setDefaultHeader:ARAuthHeader value:token];
}

+ (NSURLRequest *)newOAuthRequestWithUsername:(NSString *)username password:(NSString *)password
{
    FolioKeys *keys = [[FolioKeys alloc] init];
    NSDictionary *params = @{
        @"email" : username,
        @"password" : password,
        @"client_id" : [keys artsyAPIClientKey],
        @"client_secret" : [keys artsyAPIClientSecret],
        @"grant_type" : @"credentials",
        @"scope" : @"offline_access"
    };
    return [httpClient requestWithMethod:@"GET" path:AROAuthURL parameters:params];
}

#pragma mark -
#pragma mark User Info

+ (NSURLRequest *)newUserInfoRequest
{
    return [httpClient requestWithMethod:@"GET" path:ARMyInfoURL parameters:nil];
}

+ (NSURLRequest *)newPartnersRequest
{
    return [httpClient requestWithMethod:@"GET" path:ARMyPartnersURL parameters:nil];
}

+ (NSURLRequest *)newSearchPartnersRequestWithQuery:(NSString *)query
{
    NSDictionary *params = @{ @"term" : query };
    return [httpClient requestWithMethod:@"GET" path:ARSearchPartnersURL parameters:params];
}

+ (NSURLRequest *)newPartnerInfoRequestWithID:(NSString *)partnerSlug
{
    NSString *url = [NSString stringWithFormat:ARPartnerInfoURLFormat, partnerSlug];
    return [httpClient requestWithMethod:@"GET" path:url parameters:nil];
}

+ (NSURLRequest *)newPartnerFullInfoRequestWithID:(NSString *)partnerSlug
{
    NSString *url = [NSString stringWithFormat:ARPartnerInfoFullURLFormat, partnerSlug];
    return [httpClient requestWithMethod:@"GET" path:url parameters:nil];
}

+ (NSURLRequest *)newSetPartnerOptionForKey:(NSString *)key value:(NSString *)value partnerID:(NSString *)partnerID
{
    NSString *url = [NSString stringWithFormat:ARPartnerFlagsURLFormat, partnerID];
    return [httpClient requestWithMethod:@"PUT" path:url parameters:@{ @"key" : key,
                                                                       @"value" : value }];
}


+ (NSURLRequest *)newPartnerSizeRequest:(NSString *)partnerSlug
{
    NSString *url = [NSString stringWithFormat:ARPartnerSizeURL, partnerSlug];
    return [httpClient requestWithMethod:@"GET" path:url parameters:nil];
}

#pragma mark -
#pragma mark Artworks

+ (NSURLRequest *)newAllArtworkIDsRequestWithPartnerSlug:(NSString *)partnerSlug
{
    NSString *path = [NSString stringWithFormat:ARPartnerArtworkIdsURLFormat, partnerSlug];
    NSDictionary *params = @{ @"ids" : @(YES),
                              @"size" : @"all" };
    return [httpClient requestWithMethod:@"GET" path:path parameters:params];
}

+ (NSURLRequest *)newArtworkRequestForArtworkWithID:(NSString *)idString
{
    NSString *url = [NSString stringWithFormat:ARArtworkURLFormat, idString];
    return [httpClient requestWithMethod:@"GET" path:url parameters:nil];
}

#pragma mark -
#pragma mark Artists

+ (NSURLRequest *)newArtistIDsRequestWithPartnerSlug:(NSString *)partnerSlug
{
    NSDictionary *params = @{ @"ids" : @YES,
                              @"size" : @"all" };
    NSString *url = [NSString stringWithFormat:ARPartnerArtistsURLFormat, partnerSlug];
    return [httpClient requestWithMethod:@"GET" path:url parameters:params];
}

+ (NSURLRequest *)newArtistInfoRequestWithArtistID:(NSString *)artistID
{
    NSString *url = [NSString stringWithFormat:ARArtistURLFormat, artistID];
    return [httpClient requestWithMethod:@"GET" path:url parameters:nil];
}

+ (NSURLRequest *)newArtistDocumentsRequestWithPartnerSlug:(NSString *)partnerSlug artistID:(NSString *)artistID
{
    NSDictionary *params = @{ @"ids" : @YES,
                              @"size" : @"all" };
    NSString *path = [NSString stringWithFormat:ARPartnerArtistDocumentsURLFormat, partnerSlug, artistID];
    return [httpClient requestWithMethod:@"GET" path:path parameters:params];
}

+ (NSURLRequest *)newArtistDocumentInfoRequestWithPartnerSlug:(NSString *)partnerSlug artistID:(NSString *)artistID documentID:(NSString *)documentID
{
    NSString *path = [NSString stringWithFormat:ARPartnerArtistDocumentURLFormat, partnerSlug, artistID, documentID];
    return [httpClient requestWithMethod:@"GET" path:path parameters:nil];
}

#pragma mark -
#pragma mark Shows

+ (NSURLRequest *)newInstallationImagesRequestForShowWithID:(NSString *)showID page:(NSInteger)page
{
    NSDictionary *params = @{ @"size" : @"20",
                              @"page" : @(page),
                              @"default" : @NO };
    NSString *url = [NSString stringWithFormat:ARPartnerShowImagesURLFormat, showID];
    return [httpClient requestWithMethod:@"GET" path:url parameters:params];
}

+ (NSURLRequest *)newCoverImageRequestForShowWithID:(NSString *)showID page:(NSInteger)page
{
    NSDictionary *params = @{ @"default" : @YES };
    NSString *url = [NSString stringWithFormat:ARPartnerShowImagesURLFormat, showID];
    return [httpClient requestWithMethod:@"GET" path:url parameters:params];
}

+ (NSURLRequest *)newArtworksRequestForShowWithID:(NSString *)showID page:(NSInteger)page partnerSlug:(NSString *)partnerSlug
{
    NSDictionary *params = @{ @"size" : @"20",
                              @"page" : @(page) };
    NSString *url = [NSString stringWithFormat:ARPartnerShowArtworksURLFormat, partnerSlug, showID];
    return [httpClient requestWithMethod:@"GET" path:url parameters:params];
}

+ (NSURLRequest *)newPartnerShowIDsRequestWithPartnerSlug:(NSString *)partnerSlug
{
    NSDictionary *params = @{ @"ids" : @YES,
                              @"size" : @"all" };
    NSString *path = [NSString stringWithFormat:ARPartnerShowsURLFormat, partnerSlug];
    return [httpClient requestWithMethod:@"GET" path:path parameters:params];
}

+ (NSURLRequest *)newPartnerShowRequestWithPartnerSlug:(NSString *)partnerSlug showID:(NSString *)showID
{
    NSString *path = [NSString stringWithFormat:ARPartnerShowURLFormat, partnerSlug, showID];
    return [httpClient requestWithMethod:@"GET" path:path parameters:nil];
}

+ (NSURLRequest *)newPartnerShowDocumentsRequestWithPartnerSlug:(NSString *)partnerSlug showID:(NSString *)showID
{
    NSDictionary *params = @{ @"ids" : @YES,
                              @"size" : @"all" };
    NSString *url = [NSString stringWithFormat:ARPartnerShowDocumentsURLFormat, partnerSlug, showID];
    return [httpClient requestWithMethod:@"GET" path:url parameters:params];
}

+ (NSURLRequest *)newPartnerShowDocumentsInfoRequestWithPartnerSlug:(NSString *)partnerSlug showID:(NSString *)showID documentID:(NSString *)documentID
{
    NSString *url = [NSString stringWithFormat:ARPartnerShowDocumentURLFormat, partnerSlug, showID, documentID];
    return [httpClient requestWithMethod:@"GET" path:url parameters:nil];
}

#pragma mark -
#pragma mark Albums

+ (NSURLRequest *)newAlbumIDsRequestWithPartnerSlug:(NSString *)partnerSlug
{
    NSDictionary *params = @{ @"ids" : @YES,
                              @"size" : @"all" };
    NSString *url = [NSString stringWithFormat:ARPartnerAlbumsURLFormat, partnerSlug];
    return [httpClient requestWithMethod:@"GET" path:url parameters:params];
}

+ (NSURLRequest *)newPartnerAlbumInfoRequestWithPartnerID:(NSString *)partnerID albumID:(NSString *)albumID
{
    NSString *url = [NSString stringWithFormat:ARPartnerAlbumURLFormat, partnerID, albumID];
    return [httpClient requestWithMethod:@"GET" path:url parameters:nil];
}

+ (NSURLRequest *)newArtworksRequestForPartner:(NSString *)partnerID album:(NSString *)albumID page:(NSInteger)page
{
    NSDictionary *params = @{ @"size" : @"20",
                              @"page" : @(page) };
    NSString *url = [NSString stringWithFormat:ARPartnerAlbumArtworksURLFormat, partnerID, albumID];
    return [httpClient requestWithMethod:@"GET" path:url parameters:params];
}

#pragma mark -
#pragma mark Locations


+ (NSURLRequest *)newLocationIDsRequestWithPartnerSlug:(NSString *)partnerSlug
{
    NSDictionary *params = @{ @"ids" : @YES,
                              @"size" : @"all",
                              @"private" : @"true" };
    NSString *url = [NSString stringWithFormat:ARPartnerLocationsURLFormat, partnerSlug];
    return [httpClient requestWithMethod:@"GET" path:url parameters:params];
}

+ (NSURLRequest *)newPartnerLocationRequestWithPartnerID:(NSString *)partnerID locationID:(NSString *)locationID
{
    NSString *url = [NSString stringWithFormat:ARPartnerLocationURLFormat, partnerID, locationID];
    return [httpClient requestWithMethod:@"GET" path:url parameters:nil];
}

+ (NSURLRequest *)newPartnerLocationArtworksRequestWithPartnerID:(NSString *)partnerID locationID:(NSString *)locationID page:(NSInteger)page
{
    NSDictionary *params = @{ @"size" : @"20",
                              @"page" : @(page),
                              @"partner_location_id" : locationID };
    NSString *url = [NSString stringWithFormat:ARPartnerLocationArtworksURLFormat, partnerID];
    return [httpClient requestWithMethod:@"GET" path:url parameters:params];
}

@end
