#import "ARFeedTranslator.h"
#import "ARFeedKeys.h"

SpecBegin(ARFeedTranslator);

__block NSManagedObjectContext *context;

beforeEach(^{
    context = [CoreDataManager stubbedManagedObjectContext];
});

it(@"returns an Artwork from a dictionary", ^{
    NSDictionary *artworkDict = @{ @"id": @"artwork1" };
    Artwork *artwork = (id)[ARFeedTranslator addOrUpdateObject:artworkDict withEntityName:@"Artwork" inContext:context saving:NO];

    expect(artwork).to.beTruthy();
    expect(artwork).to.beKindOf(Artwork.class);
});

it(@"returns an array of Artwork from an array of dictionaries", ^{
    NSDictionary *artworkDict = @{ @"id": @"artwork1" };
    NSDictionary *artworkDict2 = @{ @"id": @"artwork2" };

    NSArray *artworks = (id)[ARFeedTranslator addOrUpdateObjects:@[artworkDict, artworkDict2] withEntityName:@"Artwork" inContext:context saving:NO];
    
    expect(artworks).to.beTruthy();
    expect(artworks).to.containInstancesOfClass(Artwork.class);
});

it(@"adds the artwork into the context", ^{
    expect([context countForFetchRequest:[Artwork requestAllInContext:context] error:nil]).to.equal(0);
    NSDictionary *artworkDict = @{ @"id": @"artwork1" };
    Artwork *artwork = (id)[ARFeedTranslator addOrUpdateObject:artworkDict withEntityName:@"Artwork" inContext:context saving:NO];
    
    expect([context countForFetchRequest:[Artwork requestAllInContext:context] error:nil]).to.equal(1);
    expect([Artwork findFirstInContext:context]).to.equal(artwork);
});

it(@"saves the core database when asked", ^{
    OCMockObject *mockContext = [OCMockObject partialMockForObject:context];
    [[mockContext expect] save:[OCMArg anyObjectRef]];
    
    NSDictionary *artworkDict = @{ @"id": @"artwork1" };
    [ARFeedTranslator addOrUpdateObject:artworkDict withEntityName:@"Artwork" inContext:context saving:YES];
    [mockContext verify];
});

it(@"updates existing objects instead of creating new ones", ^{
    NSDictionary *artworkDict = @{ @"id": @"artwork1", ARFeedTitleKey: @"old_title" };
    NSDictionary *artworkDict2 = @{ @"id": @"artwork1", ARFeedTitleKey: @"new_title" };

    Artwork *artwork = (id)[ARFeedTranslator addOrUpdateObject:artworkDict withEntityName:@"Artwork" inContext:context saving:NO];
    expect(artwork.title).to.equal(@"old_title");
    
    Artwork *artwork2 = (id)[ARFeedTranslator addOrUpdateObject:artworkDict2 withEntityName:@"Artwork" inContext:context saving:NO];
    expect(artwork2).to.equal(artwork);
    expect(artwork2.title).to.equal(@"new_title");
});


SpecEnd
