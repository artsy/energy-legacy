#import "ARImageDownloader.h"
#import "ARImageFormat.h"
#import "ARNotifications.h"
#import "ARFeedKeys.h"
#import <AFNetworking/AFNetworking.h>
#import "InstallShotImage.h"
#import "ARSync+TestsExtension.h"

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

it(@"gets included in a default sync", ^{
    ARSync *sync = [[ARSync alloc] init];
    expect([sync createsSyncStepInstanceOfClass:ARImageDownloader.class]).to.beTruthy();
});


SpecEnd
