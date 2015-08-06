#import "AREmailArtworksViewController.h"


@interface AREmailArtworksViewController ()
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@end

SpecBegin(AREmailArtworksViewController);


__block NSManagedObjectContext *context;
__block AREmailArtworksViewController *controller;

beforeEach(^{
    context = [CoreDataManager stubbedManagedObjectContext];
    controller = [[AREmailArtworksViewController alloc] init];
    controller.userDefaults = (id)[[FakeUserDefaults alloc] init];
});


it(@"tells you not to show if no options", ^{
    Artwork *artwork = [Artwork objectInContext:context];
    controller.artworks = @[artwork];
    expect(controller.hasAdditionalOptions).to.beFalsy();
});

it(@"shows price options", ^{
    Artwork *artwork = [Artwork objectInContext:context];
    artwork.displayPrice = @"something";
    controller.artworks = @[artwork];
    
    controller.view.frame = (CGRect){0,0, controller.preferredContentSize};
    expect(controller).to.haveValidSnapshot();
});

it(@"shows metadata options", ^{
    Artwork *artwork = [Artwork objectInContext:context];
    artwork.provenance = @"something";
    controller.artworks = @[artwork];
    
    controller.view.frame = (CGRect){0,0, controller.preferredContentSize};
    expect(controller).to.haveValidSnapshot();
});

it(@"shows combined prince & metadata options", ^{
    Artwork *artwork = [Artwork objectInContext:context];
    artwork.displayPrice = @"something";
    artwork.provenance = @"something";
    controller.artworks = @[artwork];
    
    controller.view.frame = (CGRect){0,0, controller.preferredContentSize};
    expect(controller).to.haveValidSnapshot();
});

it(@"shows document options", ^{
    Show *show = [Show objectInContext:context];

    Artwork *artwork = [Artwork objectInContext:context];
    show.artworks = [NSSet setWithObject:artwork];
    
    Document *document = [Document objectInContext:context];
    document.title = @"Document name";
    
    OCMockObject *showMock = [OCMockObject partialMockForObject:show];
    [[[showMock stub] andReturn:@[document]] sortedDocuments];
    [[[showMock stub] andReturn:@"Name"] name];
    
    controller.artworks = @[artwork];
    
    controller.view.frame = (CGRect){0,0, controller.preferredContentSize};
    expect(controller).to.haveValidSnapshot();
});

it(@"shows document and metadata options", ^{
    Show *show = [Show objectInContext:context];
    
    Artwork *artwork = [Artwork objectInContext:context];
    show.artworks = [NSSet setWithObject:artwork];
    artwork.provenance = @"something";
    
    Document *document = [Document objectInContext:context];
    document.title = @"Document name";
    
    OCMockObject *showMock = [OCMockObject partialMockForObject:show];
    [[[showMock stub] andReturn:@[document]] sortedDocuments];
    [[[showMock stub] andReturn:@"Name"] name];
    
    controller.artworks = @[artwork];
    
    controller.view.frame = (CGRect){0,0, controller.preferredContentSize};
    expect(controller).to.haveValidSnapshot();
});


SpecEnd
