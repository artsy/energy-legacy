#import "ARAlbumDownloader.h"
#import "ARRouter.h"


@implementation ARAlbumDownloader

- (Class)classForRenderedObjects
{
    return Album.class;
}

- (NSURLRequest *)urlRequestForIDsWithObject:(id)_
{
    return [ARRouter newAlbumIDsRequestWithPartnerSlug:[Partner currentPartnerID]];
}

- (NSURLRequest *)urlRequestForObjectWithID:(NSString *)objectID
{
    return [ARRouter newPartnerAlbumInfoRequestWithPartnerID:[Partner currentPartnerID] albumID:objectID];
}

- (void)performWorkWithDownloadObject:(Album *)album
{
    album.updatedAt = [NSDate date];
    album.editable = @(YES);
}

@end
