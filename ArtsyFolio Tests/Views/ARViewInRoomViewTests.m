#import "ARViewInRoomView.h"
#import "ARModelFactory.h"

SpecBegin(ARViewInRoomView);

__block NSManagedObjectContext *context;

describe(@"defaults", ^{
    before(^{
        context = [CoreDataManager stubbedManagedObjectContext];
    });

    it(@"rejects artworks that have depth", ^{
        Artwork *unviewable = [ARModelFactory partiallyFilledArtworkInContext:context];
        unviewable.depth = [NSDecimalNumber decimalNumberWithString:@"5.0"];
        unviewable.width = [NSDecimalNumber decimalNumberWithString:@"5.0"];
        unviewable.height = [NSDecimalNumber decimalNumberWithString:@"5.0"];

        expect([ARViewInRoomView canShowArtwork:unviewable]).to.beFalsy();
    });

    it(@"shows artworks that should be viewable", ^{
        Artwork *painting = [ARModelFactory partiallyFilledArtworkInContext:context];
        painting.width = [NSDecimalNumber decimalNumberWithString:@"5.0"];
        painting.height = [NSDecimalNumber decimalNumberWithString:@"5.0"];

        expect([ARViewInRoomView canShowArtwork:painting]).to.beTruthy();
    });
});

SpecEnd
