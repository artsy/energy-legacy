#import "ARPartnerFullMetadataDownloader.h"
#import <AFNetworking/AFJSONRequestOperation.h>
#import "ARSync+TestsExtension.h"

SpecBegin(ARPartnerFullMetadataDownloader);

__block ARPartnerFullMetadataDownloader *subject;
__block NSManagedObjectContext *context;

before(^{
    context = [CoreDataManager stubbedManagedObjectContext];
    subject = [[ARPartnerFullMetadataDownloader alloc] initWithContext:context];
});

it(@"grabs the right url", ^{
    AFJSONRequestOperation *jsonOp = (id)[subject operationTree:nil operationForObject:@"partnerSlug" continuation:nil failure:nil];
    expect(jsonOp.request.URL.path).to.equal(@"/api/v1/partner/partnerSlug/all");
});

SpecEnd
