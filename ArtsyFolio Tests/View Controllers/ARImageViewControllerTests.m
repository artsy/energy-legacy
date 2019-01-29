#import "ARImageViewController.h"

SpecBegin(ARImageViewController);

__block ARImageViewController *sut;
__block NSManagedObjectContext *context;

describe(@"unprocessed images", ^{

    before(^{
        context = [CoreDataManager stubbedManagedObjectContext];

        Image *image = [Image createInContext:context];
        image.processing = @(YES);

        sut = [[ARImageViewController alloc] initWithImage:image];

    });

    it(@"shows a message that this work is unprocessed", ^{
        [OHHTTPStubs stubRequestsMatchingPath:@"(null)larger.jpg" returningJSONWithObject:@{}];

        [sut loadViewsProgrammatically];
        expect(sut).to.haveValidSnapshot();
    });
});

SpecEnd
