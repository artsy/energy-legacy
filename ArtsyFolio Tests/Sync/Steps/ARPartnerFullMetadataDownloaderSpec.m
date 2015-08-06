#import "ARPartnerFullMetadataDownloader.h"
#import <AFNetworking/AFJSONRequestOperation.h>


@interface AFJSONRequestOperation (Private)
@property (readwrite, nonatomic, strong) id responseJSON;
@end

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

pending(@"creates a partner", ^{

    // JSON parsing is done on a BG thread.
    waitUntil(^(DoneCallback done) {

        void (^completionBlock)(id, void(^)()) = ^void(id result, void(^completion)()) {
            Partner *partner = [Partner currentPartnerInContext:context];
            expect(partner).to.beTruthy();
            expect(partner.slug).equal(@"PartnerSlug");

            done();
        };

        AFJSONRequestOperation *jsonOp = (id)[subject operationTree:nil operationForObject:@"partnerSlug" continuation:completionBlock failure:nil];
        jsonOp.responseJSON = @{ ARFeedSlugKey : @"PartnerSlug" };

        jsonOp.completionBlock();

    });
});

pending(@"sends a notification about ARPartnerUpdatedNotification", ^{

    expect(^{
        waitUntil(^(DoneCallback done) {

            void (^completionBlock)(id, void(^)()) = ^void(id result, void(^completion)()) {
                done();
            };

            AFJSONRequestOperation *jsonOp = (id)[subject operationTree:nil operationForObject:@"partnerSlug" continuation:completionBlock failure:nil];
            jsonOp.responseJSON = @{ ARFeedSlugKey : @"PartnerSlug" };
            jsonOp.completionBlock();
        });


    }).to.postNotification(ARPartnerUpdatedNotification);

});


SpecEnd
