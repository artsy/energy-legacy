#import "ARAlbumDownloader.h"
#import "ARRouter.h"


@implementation ARAlbumDownloader

- (Class)classForRenderedObjects
{
    return Album.class;
}

- (NSURLRequest *)urlRequestForIDsWithObject:(NSString *)partnerID
{
    return [ARRouter newAlbumIDsRequestWithPartnerSlug:partnerID];
}

- (NSURLRequest *)urlRequestForObjectWithID:(NSString *)objectID
{
    return [ARRouter newPartnerAlbumInfoRequestWithPartnerID:[Partner currentPartnerID] albumID:objectID];
}

- (void)performWorkWithDownloadObject:(Album *)album
{
    album.editable = @(NO);
}

@end
