#import "ARAdminPartnerSelectViewController.h"
#import "ARRouter.h"
#import "ARFeedKeys.h"

SpecBegin(ARAdminPartnerSelectViewController);

it(@"looks right on ipad", ^{
    [ARTestContext useContext:ARTestContextDeviceTypePad :^{
        ARAdminPartnerSelectViewController *controller = [[ARAdminPartnerSelectViewController alloc] init];
        controller.view.frame = [UIScreen mainScreen].bounds;
        expect(controller).to.haveValidSnapshot();
    }];
});


it(@"looks right on iPhone", ^{
    [ARTestContext useContext:ARTestContextDeviceTypePhone5 :^{
        ARAdminPartnerSelectViewController *controller = [[ARAdminPartnerSelectViewController alloc] init];
        controller.view.frame = [UIScreen mainScreen].bounds;
        expect(controller).to.haveValidSnapshot();
    }];
});

pending(@"shows partner names on a search", ^{
    [ARTestContext useContext:ARTestContextDeviceTypePhone5 :^{
        NSString *query = @"hello_world";
        
        NSURLRequest *partnersRequest = [ARRouter newSearchPartnersRequestWithQuery:query];
        [OHHTTPStubs stubRequestsMatchingRequest:partnersRequest returningJSONWithObject: @[
            @{ @"id" : @"fada", @"name": @"FADA" }
        ]];
        
        NSURLRequest *infoRequest = [ARRouter newPartnerInfoRequestWithID:@"fada"];
        [OHHTTPStubs stubRequestsMatchingRequest:infoRequest returningJSONWithObject: @{
            ARFeedArtistsCountKey: @2, ARFeedArtworksCountKey: @3, ARFeedArtistDocumentsCountKey: @4, ARFeedShowDocumentsCountKey: @5
        }];
            
        ARAdminPartnerSelectViewController *controller = [[ARAdminPartnerSelectViewController alloc] init];
        [controller beginAppearanceTransition:YES animated:NO];
        [controller endAppearanceTransition];

        [controller searchForQuery:query];
        expect(controller).will.haveValidSnapshot();
    }];
});

SpecEnd
