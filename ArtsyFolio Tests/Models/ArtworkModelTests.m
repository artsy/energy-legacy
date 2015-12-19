SpecBegin(ArtworkModel);

__block Artwork *artwork1, *artwork2;
__block NSManagedObjectContext *context;

describe(@"json parsing", ^{

    before(^{
        context = [CoreDataManager stubbedManagedObjectContext];

        artwork1 = [Artwork modelFromJSON:@{
                   ARFeedDepthKey : @"",
                   ARFeedHeightKey : @"23",
                   ARFeedWidthKey : [NSNull null],
                   ARFeedDiameterKey : @"42",
                   ARFeedMetricKey : @"in",
                   } inContext:context];
        
        artwork2 = [Artwork modelFromJSON:@{
                    ARFeedMetricKey : @"cm",
                    ARFeedWidthKey : @"22",
                    ARFeedDepthKey : @"",
                    } inContext:context];
    });


    it(@"correctly converts decimals from empty strings", ^{
        expect(artwork1.depth).to.beNil;
    });

    it(@"correctly converts decimals from non-empty strings", ^{
        expect(artwork1.height).to.equal([NSDecimalNumber decimalNumberWithString:@"23"]);
    });

    it(@"correctly converts decimals from nulls", ^{
        expect(artwork1.width).to.beNil;
    });
    
    it(@"does not convert dimensions if using american units", ^{
        expect(artwork1.diameter).to.equal([NSDecimalNumber decimalNumberWithString:@"42"]);
    });
    
    it(@"does convert dimensions if using metric system", ^{
        NSNumber *value = @(22/2.54);
        NSDecimalNumber *convertedWidth = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%@", value]];
        expect(artwork2.width).to.equal(convertedWidth);
    });

});

SpecEnd
