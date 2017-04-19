SpecBegin(ImageModel);

__block NSManagedObjectContext *context;

before(^{
    context = [CoreDataManager stubbedManagedObjectContext];
});

it(@"computes aspectRatio when one is not given from the API via max_tiled_x", ^{
    Image *image = [Image modelFromJSON:@{
        @"id" : @"ok",
        @"aspectRatio" : [NSNull null],
        @"original_height" : [NSNull null],
        @"original_width" : [NSNull null],
        @"max_tiled_width" : @(1),
        @"max_tiled_height" : @(1)
    } inContext:context];

    expect(image.aspectRatio).to.equal(1);
});

it(@"computes aspectRatio when one is not given from the API via original_x", ^{
    Image *image = [Image modelFromJSON:@{
        @"id" : @"ok",
        @"aspectRatio" : [NSNull null],
        @"original_height" : @(1),
        @"original_width" : @(1)
    } inContext:context];

    expect(image.aspectRatio).to.equal(1);
});


SpecEnd
