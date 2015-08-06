#import "ARModernArtworkMetadataViewController.h"
#import "ARArtworkMetadataView.h"


@interface ARModernArtworkMetadataViewController ()
@property (nonatomic, strong, readonly) UITapGestureRecognizer *artworkInfoTapGesture;
@property (nonatomic, strong, readonly) UISwipeGestureRecognizer *artworkInfoSwipeGesture;

- (void)hideArtworkInfo:(NSNotification *)notification;
- (void)showArtworkInfo:(NSNotification *)notification;

@end

SpecBegin(ARModernArtworkMetadataViewController);

__block ARModernArtworkMetadataViewController *sut;
__block NSManagedObjectContext *context;
__block Artwork *artwork;

beforeEach(^{
    sut = [[ARModernArtworkMetadataViewController alloc] init];
});

it(@"should not load a view on init", ^{
    expect(sut.isViewLoaded).to.beFalsy();
});

describe(@"gestures", ^{
    beforeEach(^{
        [sut view];
        context = [CoreDataManager stubbedManagedObjectContext];
    });
    
    it(@"should have a tap & swipe gesture", ^{
        expect(sut.artworkInfoTapGesture).to.beTruthy();
        expect(sut.artworkInfoSwipeGesture).to.beTruthy();
    });
    
    it(@"should be enabled when artwork has metadata", ^{
        artwork = [Artwork modelFromJSON:@{
            ARFeedTitleKey: @"title",
            ARFeedArtworkInfoKey: @"something"
        } inContext:context];
        
        sut.artwork = artwork;

        expect(sut.artworkInfoTapGesture.enabled).to.beTruthy();
        expect(sut.artworkInfoTapGesture.enabled).to.beTruthy();
    });
    
    it(@"should be disable when artwork has no metadata", ^{
        Artwork *artwork = [Artwork modelFromJSON:@{
            ARFeedTitleKey: @"title"
        } inContext:context];
        
        sut.artwork = artwork;
        
        expect(sut.artworkInfoTapGesture.enabled).to.beFalsy();
        expect(sut.artworkInfoTapGesture.enabled).to.beFalsy();
    });

});

describe(@"notifications", ^{
    __block OCMockObject *sutStub;
    
    beforeEach(^{
        [sut view];
        sutStub = [OCMockObject partialMockForObject:sut];
    });
    
    it(@"should respond to show", ^{
        [[sutStub expect] showArtworkInfo:OCMArg.any];

        [[NSNotificationCenter defaultCenter]postNotificationName:ARShowArtworkInfoNotification object:nil];
        [sutStub verify];
    });
    
    it(@"should respond to hide", ^{
        [[sutStub expect] hideArtworkInfo:OCMArg.any];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:ARHideArtworkInfoNotification object:nil];
        [sutStub verify];
    });

});

describe(@"number of lines of artwork metadata", ^{
    before(^{
        sut.constrainedHorizontalSpace = YES;
        sut.constrainedVerticalSpace = YES;
    });
    
    it(@"should be limited to 4 on small screens", ^{
        [ARTestContext useContext:ARTestContextDeviceTypePhone4 :^{
        [sut beginAppearanceTransition:YES animated:NO];
        ARArtworkMetadataView *metadataView = (ARArtworkMetadataView *)sut.view;
        expect(metadataView.maxAllowedInputs).to.equal(4);
        }];
    });
    
    it(@"should be limited to 5 on large screens", ^{
        [ARTestContext useContext:ARTestContextDeviceTypePhone5 :^{
        [sut beginAppearanceTransition:YES animated:NO];
        ARArtworkMetadataView *metadataView = (ARArtworkMetadataView *)sut.view;
        expect(metadataView.maxAllowedInputs).to.equal(5);
        }];
    });
});


SpecEnd
