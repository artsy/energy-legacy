#import "ARImageDownloader.h"
#import "ARImageFormat.h"
#import "ARNotifications.h"
#import "ARFeedKeys.h"
#import <AFNetworking/AFNetworking.h>
#import "InstallShotImage.h"

SpecBegin(ARImageDownloader);


__block ARImageDownloader *subject;
__block NSManagedObjectContext *context;

before(^{
    context = [CoreDataManager stubbedManagedObjectContext];
    subject = [[ARImageDownloader alloc] initWithProgress:nil];
});

describe(@"when passed an object", ^{
    it(@"returns an artwork's image paths", ^{
        Artwork *artwork = [Artwork stubbedArtworkWithImages:YES inContext:context];

        [subject operationTree:nil objectsForObject:artwork completion:^(NSArray *objects) {
            NSArray *formats = [[artwork.images.anyObject class] imageFormatsToDownload];
            expect(objects.count).to.equal(formats.count * artwork.images.count);
        }];
    });

    it(@"returns an image's image paths", ^{
        Image *image = [ARModelFactory imageWithKnownRemoteResourcesInContext:context];

        [subject operationTree:nil objectsForObject:image completion:^(NSArray *objects) {
            NSArray *formats = [image.class imageFormatsToDownload];
            expect(objects.count).to.equal(formats.count);
        }];
    });

    it(@"returns an show's installation image's paths", ^{
        Show *show = [Show modelFromJSON:@{} inContext:context];
        InstallShotImage *image = [InstallShotImage modelFromJSON: @{
            ARFeedImageSourceKey: @"http://static0.artsy.net/additional_images/519d3bb4275b249173000070/",
            ARFeedSlugKey:@"519d3bb4275b249173000070",
            ARFeedIDKey:@"519d3bb4275b249173000070"
        } inContext:context];

        show.installationImages = [NSSet setWithObject:image];

        [subject operationTree:nil objectsForObject:show completion:^(NSArray *objects) {
            NSArray *formats = [image.class imageFormatsToDownload];
            expect(objects.count).to.equal(formats.count);
        }];

    });
});

pending(@"grabs the right image", ^{
    __block AFHTTPRequestOperation *operation;
    __block NSString *expectedAddress;

    beforeEach(^{
        ARImageDownloader *downloader = [[ARImageDownloader alloc] init];

        expectedAddress = NSStringWithFormat(@"http://baseURL.com/%@.jpg", ARFeedImageSizeLargerKey);
        Image *image = [Image objectInContext:context];
        image.baseURL = @"http://baseURL.com/";

        ARImageFormat *format = [ARImageFormat imageFormatWithImage:image format:ARFeedImageSizeLargerKey];
         operation = (id)[downloader operationTree:nil operationForObject:format
                                                             continuation:^(id object, void (^completion)()) {
                                                                } failure:nil];
    });

    it(@"creates the right operation", ^{
        expect(operation).will.beKindOf(AFHTTPRequestOperation.class);
        expect(operation.request.URL.absoluteString).to.equal(expectedAddress);
    });

    pending(@"sends a notification that a large image has been sent", ^{

        [OHHTTPStubs stubRequestsMatchingAddressReturningRandomImage:expectedAddress];

        expect(^{
            [operation start];
        }).will.notify(ARLargeImageDownloadCompleteNotification);
    });

});

SpecEnd
