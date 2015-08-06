#import "ARPartnerMetadataUploader.h"
#import <AFNetworking/AFJSONRequestOperation.h>

SpecBegin(ARPartnerMetadataUploader);

__block Partner *partner;
__block ARPartnerMetadataUploader *subject;
__block NSManagedObjectContext *context;

before(^{
    context = [CoreDataManager stubbedManagedObjectContext];
    partner = [Partner modelFromJSON:@{ ARFeedSlugKey : @"ClubMate"} inContext:context];

    subject = [[ARPartnerMetadataUploader alloc] initWithContext:context];
});

it(@"gives an empty operation if an admin", ^{
    User *user = [ARModelFactory createCurrentUserInContext:context];
    user.type = @"Admin";
    id op = [subject operationTree:nil operationForObject:partner.slug continuation:nil failure:nil];
    expect([op class]).to.equal(NSBlockOperation.class);
});

it(@"generates the right keys", ^{
    AFJSONRequestOperation *op = (id)[subject operationTree:nil operationForObject:partner.slug continuation:nil failure:nil];
    NSString *query = [[NSString alloc] initWithData:op.request.HTTPBody encoding:NSUTF8StringEncoding];
    expect(query).to.contain(@"key=last_folio_access");
    expect(query).to.contain(@"value=");
});

it(@"sends to the right url", ^{
    AFJSONRequestOperation *op = (id)[subject operationTree:nil operationForObject:partner.slug continuation:nil failure:nil];
    expect(op.request.URL.path).to.equal(@"/api/v1/partner/ClubMate/partner_flags");
});


SpecEnd
