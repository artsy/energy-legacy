#import "ARViewInRoomView.h"
#import "ARPadViewInRoomViewController.h"
#import "ARModelFactory.h"
#import "ARStubbedImage.h"

SpecBegin(ARViewInRoomView);

__block NSManagedObjectContext *context;
__block Artwork *painting;

before(^{
    context = [CoreDataManager stubbedManagedObjectContext];
    painting = [ARModelFactory partiallyFilledArtworkInContext:context];
    painting.width = [NSDecimalNumber decimalNumberWithString:@"15.0"];
    painting.height = [NSDecimalNumber decimalNumberWithString:@"14.0"];
});

describe(@"looks as expected when artwork ", ^{
    __block ARPadViewInRoomViewController *subject;

    beforeEach(^{
        subject = [[ARPadViewInRoomViewController alloc] init];
    });

    it(@"is small on ipad", ^{
        subject.artwork = painting;
        subject.roomView.artworkImageView.backgroundColor = [UIColor blueColor];
        [subject.view layoutSubviews];
        
        expect(subject).to.haveValidSnapshot();
    });

    it(@"is medium sized on ipad", ^{
        painting.width = [NSDecimalNumber decimalNumberWithString:@"90.0"];
        painting.height = [NSDecimalNumber decimalNumberWithString:@"140.0"];

        subject.artwork = painting;
        subject.roomView.artworkImageView.backgroundColor = [UIColor blueColor];
        [subject.view layoutSubviews];
        expect(subject).to.haveValidSnapshot();
    });

    it(@"is large on ipad", ^{
        painting.width = [NSDecimalNumber decimalNumberWithString:@"160.0"];
        painting.height = [NSDecimalNumber decimalNumberWithString:@"240.0"];

        subject.artwork = painting;
        subject.roomView.artworkImageView.backgroundColor = [UIColor blueColor];
        [subject.view layoutSubviews];
        expect(subject).to.haveValidSnapshot();
    });
});

describe(@"defaults", ^{

    it(@"rejects artworks that have depth", ^{
        Artwork *unviewable = [ARModelFactory partiallyFilledArtworkInContext:context];
        unviewable.depth = [NSDecimalNumber decimalNumberWithString:@"5.0"];
        unviewable.width = [NSDecimalNumber decimalNumberWithString:@"5.0"];
        unviewable.height = [NSDecimalNumber decimalNumberWithString:@"5.0"];

        expect([ARViewInRoomView canShowArtwork:unviewable]).to.beFalsy();
    });

    it(@"shows artworks that should be viewable", ^{

        expect([ARViewInRoomView canShowArtwork:painting]).to.beTruthy();
    });
});

SpecEnd
