#import "ARModernArtworkInfoViewController.h"
#import "ARModelFactory.h"

SpecBegin(ARModernArtworkInfoViewController);

__block ARModernArtworkInfoViewController *sut;
__block Artwork *fullArtwork, *partialArtwork;
__block NSManagedObjectContext *context;

void (^setupSUTWithArtwork)(Artwork *artwork) = ^(Artwork *artwork) {
    sut = [[ARModernArtworkInfoViewController alloc] initWithArtwork:artwork];
    sut.view.frame = [UIScreen mainScreen].bounds;
};

before(^{
    context = [CoreDataManager stubbedManagedObjectContext];
    fullArtwork = [ARModelFactory fullArtworkInContext:context];
    partialArtwork = [ARModelFactory partiallyFilledArtworkInContext:context];
});

it(@"looks right with full artwork", ^{
    [ARTestContext useContext:ARTestContextDeviceTypePad :^{
        setupSUTWithArtwork(fullArtwork);
        expect(sut).to.haveValidSnapshotNamed(@"full artwork ipad");
    }];

    [ARTestContext useContext:ARTestContextDeviceTypePhone5 :^{
        setupSUTWithArtwork(fullArtwork);
        expect(sut).to.haveValidSnapshotNamed(@"full artwork iphone");
    }];
});


it(@"looks right with partial artwork", ^{
    [ARTestContext useContext:ARTestContextDeviceTypePad :^{
        setupSUTWithArtwork(partialArtwork);
        expect(sut).to.haveValidSnapshotNamed(@"partial artwork ipad");
    }];

    [ARTestContext useContext:ARTestContextDeviceTypePhone5 :^{
        setupSUTWithArtwork(partialArtwork);
        expect(sut).to.haveValidSnapshotNamed(@"partial artwork iphone");
    }];
});


SpecEnd
