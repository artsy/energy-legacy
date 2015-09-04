SpecBegin(ArtworkModel);

__block Artwork *artwork;
__block NSManagedObjectContext *context;

describe(@"json parsing", ^{

    before(^{
        context = [CoreDataManager stubbedManagedObjectContext];

        artwork = [Artwork modelFromJSON:@{
                   ARFeedDepthKey : @"",
                   ARFeedHeightKey : @"23",
                   ARFeedWidthKey : [NSNull null],
                   } inContext:context];
    });


    it(@"correctly converts decimals from empty strings", ^{
        expect(artwork.depth).to.beNil;
    });

    it(@"correctly converts decimals from non-empty strings", ^{
        expect(artwork.height).to.equal([NSDecimalNumber decimalNumberWithString:@"23"]);
    });

    it(@"correctly converts decimals from nulls", ^{
        expect(artwork.width).to.beNil;
    });

});

SpecEnd
