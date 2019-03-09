#import "AREditAvailabilityNetworkModel.h"
#import "ARRouter.h"
#import "EditionSet.h"
#import <AFNetworking/AFNetworking.h>


@implementation AREditAvailabilityNetworkModel

- (void)updateArtwork:(Artwork *)artwork mainAvailability:(ARArtworkAvailability)availability completion:(void (^)(BOOL))completion
{
    NSString *gravityStringForAvailability = [Artwork stringForAvailabilityState:availability];

    NSURLRequest *updateRequest = [ARRouter newPartnerUpdateArtworkAvailabilityRequestWithArtworkID:artwork.slug availabilityUpdate:gravityStringForAvailability];

    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:updateRequest success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {

        completion(YES);

    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        completion(NO);
    }];

    [operation start];
}

- (void)updateArtwork:(Artwork *)artwork editionSet:(EditionSet *)set toAvailability:(ARArtworkAvailability)availability completion:(void (^)(BOOL))completion

{
    NSString *gravityStringForAvailability = [Artwork stringForAvailabilityState:availability];

    NSURLRequest *updateRequest = [ARRouter newPartnerUpdateEditionSetAvailabilityRequestWithArtworkID:artwork.slug editionSetID:set.slug availabilityUpdate:gravityStringForAvailability];

    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:updateRequest success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {

        completion(YES);

    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        completion(NO);
    }];

    [operation start];
}
@end
