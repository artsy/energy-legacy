
#import "ARArtworkInfoAdditionalMetadataView.h"
#import <FLKAutoLayout/UIView+FLKAutoLayout.h>
#import "ARModelFactory.h"
#import "UIDevice+DeviceInfo.h"
#import "ARDefaults.h"
#import "AROptions.h"
#import "EditionSet.h"
#import <Artsy_UILabels/ARLabelSubclasses.h>
#import "ORStackView+TestingHelpers.h"


@interface ARArtworkInfoAdditionalMetadataView ()
@property (nonatomic, strong) NSUserDefaults *defaults;
- (instancetype)initWithArtwork:(Artwork *)artwork preferredWidth:(CGFloat)preferredWidth split:(BOOL)split defaults:(NSUserDefaults *)defaults;
- (BOOL)showPriceOfEditionSet:(EditionSet *)set;
@end

SpecBegin(ARArtworkInfoAdditionalMetadataView);

__block UIView *wrapper;
__block ARArtworkInfoAdditionalMetadataView *sut;
__block ForgeriesUserDefaults *fakeDefaults;
__block NSManagedObjectContext *context;

void (^setupSUTWithArtwork)(Artwork *artwork) = ^(Artwork *artwork) {

    wrapper = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    BOOL split = [UIDevice isPad];
    CGFloat width = CGRectGetWidth(wrapper.bounds) - 40;

    sut = [[ARArtworkInfoAdditionalMetadataView alloc] initWithArtwork:artwork preferredWidth:width split:split defaults:(id)fakeDefaults];
    
    [wrapper addSubview:sut];
    [sut alignTop:@"0" leading:@"0" bottom:nil trailing:@"0" toView:wrapper];
};

beforeEach(^{
    context = [CoreDataManager stubbedManagedObjectContext];
});

describe(@"visually", ^{

    it(@"doesn't mess up inventory IDs using HTML chars", ^{
        Artwork *artwork = [Artwork stubbedModelFromJSON: @{ ARFeedInventoryIDKey: @"MI&N 12345" }];
        setupSUTWithArtwork(artwork);

        UILabel *inventoryIDLabel = [sut.subviews.firstObject subviews][1];
        expect(inventoryIDLabel.text).to.equal(@"MI&N 12345");
    });

    it(@"looks right for barely-filled artworks", ^{
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

    it(@"looks right for semi-filled artworks", ^{
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

    it(@"looks right for filled artworks", ^{
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
    
    it(@"looks right for artworks with editions", ^{
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
    
    it(@"looks right for artworks with confidential notes", ^{
        Artwork *artwork = [ARModelFactory partiallyFilledArtworkInContext:context];
        artwork.confidentialNotes = @"super secret";
        
        fakeDefaults = [ForgeriesUserDefaults defaults:@{
                         ARHideConfidentialNotes: @NO,
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

describe(@"showing and hiding edition prices", ^{
    
    it(@"shows unsold edition prices when pres mode is off", ^{
        Artwork *artwork = [ARModelFactory fullArtworkWithEditionsInContext:context];
        
        fakeDefaults = [ForgeriesUserDefaults defaults:@{
                         ARPresentationModeOn: @NO,
                         ARHideAllPrices: @NO,
                         ARHidePricesForSoldWorks: @YES
                         }];
        
        setupSUTWithArtwork(artwork);
        
        expect([sut showPriceOfEditionSet:artwork.editionSets.firstObject]).to.beTruthy();
    });
    
    it(@"shows unsold edition prices when pres mode is on and sold work prices hidden", ^{
        Artwork *artwork = [ARModelFactory fullArtworkWithEditionsInContext:context];
        
        fakeDefaults = [ForgeriesUserDefaults defaults:@{
                         ARPresentationModeOn: @YES,
                         ARHideAllPrices: @NO,
                         ARHidePricesForSoldWorks: @YES
                         }];

        setupSUTWithArtwork(artwork);
        
        expect([sut showPriceOfEditionSet:artwork.editionSets.firstObject]).to.beTruthy();
    });
    
    it(@"hides unsold edition prices when pres mode is on and all prices are hidden", ^{
        Artwork *artwork = [ARModelFactory fullArtworkWithEditionsInContext:context];
        
        fakeDefaults = [ForgeriesUserDefaults defaults:@{
                         ARPresentationModeOn: @YES,
                         ARHideAllPrices: @YES,
                         ARHidePricesForSoldWorks: @NO
                         }];
        
        setupSUTWithArtwork(artwork);
        
        expect([sut showPriceOfEditionSet:artwork.editionSets.firstObject]).to.beFalsy();
    });
    
    it(@"shows sold edition prices when pres mode is off", ^{
        Artwork *artwork = [ARModelFactory fullArtworkWithEditionsInContext:context];
        EditionSet *set = artwork.editionSets.firstObject;
        set.availability = ARAvailabilitySold;
        
        fakeDefaults = [ForgeriesUserDefaults defaults:@{
                         ARPresentationModeOn: @NO,
                         ARHideAllPrices: @"YES",
                         ARHidePricesForSoldWorks: @YES
                         }];
        
        setupSUTWithArtwork(artwork);
        
        expect([sut showPriceOfEditionSet:artwork.editionSets.firstObject]).to.beTruthy();
    });

    it(@"shows sold edition prices when pres mode is on and sold works prices are not hidden", ^{
        Artwork *artwork = [ARModelFactory fullArtworkWithEditionsInContext:context];
        EditionSet *set = artwork.editionSets.firstObject;
        set.availability = ARAvailabilitySold;
        
        fakeDefaults = [ForgeriesUserDefaults defaults:@{
                         ARPresentationModeOn: @YES,
                         ARHideAllPrices: @NO,
                         ARHidePricesForSoldWorks: @NO
                         }];
        
        setupSUTWithArtwork(artwork);
        
        expect([sut showPriceOfEditionSet:artwork.editionSets.firstObject]).to.beTruthy();
    });
    
    it(@"hides sold edition prices when pres mode is on and sold works prices hidden", ^{
        Artwork *artwork = [ARModelFactory fullArtworkWithEditionsInContext:context];
        EditionSet *set = artwork.editionSets.firstObject;
        set.availability = ARAvailabilitySold;
        
        fakeDefaults = [ForgeriesUserDefaults defaults:@{
                         ARPresentationModeOn: @YES,
                         ARHideAllPrices: @"NO",
                         ARHidePricesForSoldWorks: @YES
                         }];
        
        setupSUTWithArtwork(artwork);
        
        expect([sut showPriceOfEditionSet:artwork.editionSets.firstObject]).to.beFalsy();
    });
});

describe(@"showing and hiding confidential notes", ^{
    
    it(@"respects Hide Conf Notes default in presentation mode when HCN is on", ^{
        Artwork *artwork = [ARModelFactory partiallyFilledArtworkInContext:context];
        artwork.confidentialNotes = @"super secret";
        
        fakeDefaults = [ForgeriesUserDefaults defaults:@{
                             ARHideConfidentialNotes: @YES,
                             ARPresentationModeOn: @YES,
                             }];

        setupSUTWithArtwork(artwork);
        
        NSArray *stackViews = [[sut.subviews.firstObject subviews] reject:^BOOL(id object) {
            return ![object isKindOfClass:ORStackView.class];
        }];
        
        NSNumber *hasConfidentialNotesView = [stackViews reduce:@(NO) withBlock:^id(NSNumber *accumulator, ORStackView *stackView) {
            if (accumulator.boolValue) return @(YES);
            return @([stackView containsLabelWithText:@"confidential notes"]);
        }];

        expect(hasConfidentialNotesView).to.beFalsy();
    });
    
    it(@"respects Hide Conf Notes default in presentation mode when HCN is off", ^{
        Artwork *artwork = [ARModelFactory partiallyFilledArtworkInContext:context];
        artwork.confidentialNotes = @"super secret";
        
        fakeDefaults = [ForgeriesUserDefaults defaults:@{
                             ARHideConfidentialNotes: @NO,
                             ARPresentationModeOn: @YES,
                             }];

        setupSUTWithArtwork(artwork);
        
        NSArray *stackViews = [[sut.subviews.firstObject subviews] reject:^BOOL(id object) {
            return ![object isKindOfClass:ORStackView.class];
        }];

        NSNumber *hasConfidentialNotesView = [stackViews reduce:@(NO) withBlock:^id(NSNumber *accumulator, ORStackView *stackView) {
            if (accumulator.boolValue) return @(YES);
            return @([stackView containsLabelWithText:@"confidential notes"]);
        }];
        
        
        expect(hasConfidentialNotesView).to.beTruthy();
    });
    
    it(@"ignores Hide Conf Notes default when not in presentation mode", ^{
        Artwork *artwork = [ARModelFactory partiallyFilledArtworkInContext:context];
        artwork.confidentialNotes = @"super secret";
        
        fakeDefaults = [ForgeriesUserDefaults defaults:@{
                             ARHideConfidentialNotes: @YES,
                             ARPresentationModeOn: @NO,
                         }];
        
        setupSUTWithArtwork(artwork);
        
        NSArray *stackViews = [[sut.subviews.firstObject subviews] reject:^BOOL(id object) {
            return ![object isKindOfClass:ORStackView.class];
        }];
        
        NSNumber *hasConfidentialNotesView = [stackViews reduce:@(NO) withBlock:^id(NSNumber *accumulator, ORStackView *stackView) {
            if (accumulator.boolValue) return @(YES);
            return @([stackView containsLabelWithText:@"confidential notes"]);
        }];
        
        expect(hasConfidentialNotesView).to.beTruthy();
    });

});

SpecEnd
