
#import "ARArtworkInfoAdditionalMetadataView.h"
#import <FLKAutoLayout/UIView+FLKAutoLayout.h>
#import "ARModelFactory.h"
#import "UIDevice+DeviceInfo.h"
#import "ARDefaults.h"


@interface ARArtworkInfoAdditionalMetadataView ()
@property (nonatomic, strong) NSUserDefaults *defaults;
- (instancetype)initWithArtwork:(Artwork *)artwork preferredWidth:(CGFloat)preferredWidth split:(BOOL)split defaults:(NSUserDefaults *)defaults;
@end

SpecBegin(ARArtworkInfoAdditionalMetadataView);

__block UIView *wrapper;
__block ARArtworkInfoAdditionalMetadataView *sut;
__block ForgeriesUserDefaults *fakeDefaults;

void (^setupSUTWithArtwork)(Artwork *artwork) = ^(Artwork *artwork) {

    wrapper = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    BOOL split = [UIDevice isPad];
    CGFloat width = CGRectGetWidth(wrapper.bounds) - 40;

    sut = [[ARArtworkInfoAdditionalMetadataView alloc] initWithArtwork:artwork preferredWidth:width split:split defaults:(id)fakeDefaults];
    
    [wrapper addSubview:sut];
    [sut alignTop:@"0" leading:@"0" bottom:nil trailing:@"0" toView:wrapper];
};

describe(@"with metadata", ^{

    it(@"doesn't mess up inventory IDs using HTML chars", ^{
        Artwork *artwork = [Artwork stubbedModelFromJSON: @{ ARFeedInventoryIDKey: @"MI&N 12345" }];
        setupSUTWithArtwork(artwork);

        UILabel *inventoryIDLabel = [sut.subviews.firstObject subviews][1];
        expect(inventoryIDLabel.text).to.equal(@"MI&N 12345");
    });

    it(@"barely-filled artwork", ^{
        Artwork *artwork = [Artwork stubbedModelFromJSON: @{
           @"signature": @"Signature that is long enough so that on an ipad it should be full length"
        }];

        [ARTestContext useContext:ARTestContextDeviceTypePad :^{
            setupSUTWithArtwork(artwork);
            expect(wrapper).to.haveValidSnapshotNamed(@"barely filled artwork ipad");
        }];

        [ARTestContext useContext:ARTestContextDeviceTypePhone4 :^{
            setupSUTWithArtwork(artwork);
            expect(wrapper).to.haveValidSnapshotNamed(@"barely filled artwork iphone");
        }];

    });

    it(@"semi-filled artwork", ^{
        NSManagedObjectContext *context = [CoreDataManager stubbedManagedObjectContext];
        Artwork *artwork = [ARModelFactory partiallyFilledArtworkInContext:context];
        [ARTestContext useContext:ARTestContextDeviceTypePad :^{
            setupSUTWithArtwork(artwork);
            expect(wrapper).to.haveValidSnapshotNamed(@"semi filled artwork ipad");
        }];

        [ARTestContext useContext:ARTestContextDeviceTypePhone4 :^{
            setupSUTWithArtwork(artwork);
            expect(wrapper).to.haveValidSnapshotNamed(@"semi filled artwork iphone");
        }];
    });

    it(@"filled artwork", ^{
        NSManagedObjectContext *context = [CoreDataManager stubbedManagedObjectContext];
        Artwork *artwork = [ARModelFactory fullArtworkInContext:context];

        [ARTestContext useContext:ARTestContextDeviceTypePad :^{
            setupSUTWithArtwork(artwork);
            expect(wrapper).to.haveValidSnapshotNamed(@"filled artwork ipad");
        }];

        [ARTestContext useContext:ARTestContextDeviceTypePhone4 :^{
            setupSUTWithArtwork(artwork);
            expect(wrapper).to.haveValidSnapshotNamed(@"filled artwork iphone");
        }];
    });
    
    it(@"filled artwork with editions", ^{
        NSManagedObjectContext *context = [CoreDataManager stubbedManagedObjectContext];
        Artwork *artwork = [ARModelFactory fullArtworkWithEditionsInContext:context];
        
        [ARTestContext useContext:ARTestContextDeviceTypePad :^{
            setupSUTWithArtwork(artwork);
            expect(wrapper).to.haveValidSnapshotNamed(@"filled editions artwork ipad");
        }];
        
        [ARTestContext useContext:ARTestContextDeviceTypePhone4 :^{
            setupSUTWithArtwork(artwork);
            expect(wrapper).to.haveValidSnapshotNamed(@"filled editions artwork iphone");
        }];
    });
    
    it(@"shows prices for editions when it should", ^{
        NSManagedObjectContext *context = [CoreDataManager stubbedManagedObjectContext];
        Artwork *artwork = [ARModelFactory fullArtworkWithEditionsInContext:context];
        
        fakeDefaults = [ForgeriesUserDefaults defaults:@{
                          ARShowPrices: @YES,
        }];
        
        [ARTestContext useContext:ARTestContextDeviceTypePad :^{
            setupSUTWithArtwork(artwork);
            expect(wrapper).to.haveValidSnapshotNamed(@"editions with prices artwork ipad");
        }];
        
        [ARTestContext useContext:ARTestContextDeviceTypePhone4 :^{
            setupSUTWithArtwork(artwork);
            expect(wrapper).to.haveValidSnapshotNamed(@"editions with prices artwork iphone");
        }];
    });
    
    it(@"hides confidential notes when it should", ^{
        NSManagedObjectContext *context = [CoreDataManager stubbedManagedObjectContext];
        Artwork *artwork = [ARModelFactory partiallyFilledArtworkInContext:context];
        artwork.confidentialNotes = @"super secret";
        
        [ARTestContext useContext:ARTestContextDeviceTypePad :^{
            setupSUTWithArtwork(artwork);
            expect(wrapper).to.haveValidSnapshotNamed(@"hidden notes ipad");
        }];
        
        [ARTestContext useContext:ARTestContextDeviceTypePhone4 :^{
            setupSUTWithArtwork(artwork);
            expect(wrapper).to.haveValidSnapshotNamed(@"hidden notes iphone");
        }];
    });

    it(@"shows confidential notes when it should", ^{
        NSManagedObjectContext *context = [CoreDataManager stubbedManagedObjectContext];
        Artwork *artwork = [ARModelFactory partiallyFilledArtworkInContext:context];
        artwork.confidentialNotes = @"super secret";
        
        fakeDefaults = [ForgeriesUserDefaults defaults:@{
                     ARShowConfidentialNotes: @YES,
        }];
        
        [ARTestContext useContext:ARTestContextDeviceTypePad :^{
            setupSUTWithArtwork(artwork);
            expect(wrapper).to.haveValidSnapshotNamed(@"showing notes ipad");
        }];
        
        [ARTestContext useContext:ARTestContextDeviceTypePhone4 :^{
            setupSUTWithArtwork(artwork);
            expect(wrapper).to.haveValidSnapshotNamed(@"showing notes iphone");
        }];
    });
});

SpecEnd
