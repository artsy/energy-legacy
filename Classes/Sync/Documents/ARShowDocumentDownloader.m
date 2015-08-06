#import "ARShowDocumentDownloader.h"
#import "ARRouter.h"


@interface ARShowDocumentDownloader ()
@property (readwrite, nonatomic, strong) Show *show;
@end


@implementation ARShowDocumentDownloader

- (Class)classForRenderedObjects
{
    return ShowDocument.class;
}

- (NSURLRequest *)urlRequestForIDsWithObject:(Show *)show
{
    self.show = show;
    return [ARRouter newPartnerShowDocumentsRequestWithPartnerSlug:[Partner currentPartnerID] showID:show.showSlug];
}

- (NSURLRequest *)urlRequestForObjectWithID:(NSString *)objectID
{
    return [ARRouter newPartnerShowDocumentsInfoRequestWithPartnerSlug:[Partner currentPartnerID] showID:self.show.showSlug documentID:objectID];
}

@end
