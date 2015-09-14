#if __has_include(<CoreSpotlight/CoreSpotlight.h>)

#import <CoreSpotlight/CoreSpotlight.h>
#import "ARSpotlightExporter.h"

SpecBegin(ARSpotlightExporter);

__block ARSpotlightExporter *subject;
__block NSManagedObjectContext *context;

before(^{
    context = [CoreDataManager stubbedManagedObjectContext];
});

pending(@"gets expected artist results from a context", ^{
    Artist *artist = [ARModelFactory filledArtistInContext:context];
    CSSearchableIndex *index = [[CSSearchableIndex alloc] initWithName:@"Hi"];
    subject = [[ARSpotlightExporter alloc] initWithManagedObjectContext:context index:index];
    NSArray *artistsResults = [subject artistResults];

    expect(artistsResults.count).to.equal(1);

    CSSearchableItem *item = artistsResults.firstObject;
    expect([item.attributeSet title]).to.equal(artist.gridTitle);
});

pending(@"gets expected artist results from a context", ^{
    Artwork *artwork = [ARModelFactory fullArtworkInContext:context];

    CSSearchableIndex *index = [[CSSearchableIndex alloc] initWithName:@"Hi"];
    subject = [[ARSpotlightExporter alloc] initWithManagedObjectContext:context index:index];
    NSArray *artworkResults = [subject artworkResults];

    expect(artworkResults.count).to.equal(1);

    CSSearchableItem *item = artworkResults.firstObject;
    expect([item.attributeSet title]).to.equal(artwork.gridTitle);
});

SpecEnd

#endif
