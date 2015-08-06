#import "Specta.h"
#import "ARArtworkMetadataExtendedView.h"
#import "ARArtworkMetadataView.h"
#import "UIColor+FolioColours.h"
#import "AROptions.h"
#import "NSAttributedString+Artsy.h"


SpecBegin(ARArtworkExpandedMetadataViewTests);

__block ARArtworkMetadataExtendedView *metadataView;
__block UIView *wrapper;
__block NSString *lorem;

beforeEach(^{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:AROptionsUseWhiteFolio];
    
    lorem = @"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec a diam lectus. Sed sit amet ipsum mauris. Maecenas congue ligula ac quam viverra nec consectetur ante hendrerit. Donec et mollis dolor.";
    wrapper = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 768, 400)];
    wrapper.backgroundColor = [UIColor colorWithWhite:0.800f alpha:1.000];
    metadataView = [[ARArtworkMetadataExtendedView alloc] initWithFrame:wrapper.bounds];
    [wrapper addSubview:metadataView];
});

describe(@"mixed types", ^{
    
    it(@"handles mixed strings correctly", ^{
        
        Artwork *artwork = [Artwork stubbedModelFromJSON:@{
            @"id":@"id", @"title": @"artwork", @"date": @"date"
        }];
        
        [metadataView setStrings:@[@"Hello", [NSAttributedString titleAndDateStringForArtwork:artwork]]];
        expect(wrapper).to.haveValidSnapshot();
    });
    
    it(@"handles a 3+ mixed strings correctly", ^{
        Artwork *artwork = [Artwork stubbedModelFromJSON:@{
            @"id":@"id", @"title": @"artwork", @"date": @"date"
        }];
        
        [metadataView setStrings:@[@"Hello",
                                   [NSAttributedString titleAndDateStringForArtwork:artwork],
                                   @"World", @"thing", @"place", [NSAttributedString titleAndDateStringForArtwork:artwork]]];
        expect(wrapper).to.haveValidSnapshot();
    });
});


describe(@"with no indicator", ^{
    
    it(@"handles 1 string input correctly", ^{
        [metadataView setStrings:@[@"Hello"]];
        expect(wrapper).to.haveValidSnapshot();
    });
    
    it(@"handles 2 string inputs correctly", ^{
        [metadataView setStrings:@[@"Hello", @"Bye"]];
        expect(wrapper).to.haveValidSnapshot();
    });
    
    it(@"handles 3 string inputs correctly", ^{
        [metadataView setStrings:@[@"Hello", @"Bye", @"world"]];
        expect(wrapper).to.haveValidSnapshot();
    });
    
    it(@"handles 4 string inputs correctly", ^{
        [metadataView setStrings:@[@"Hello", @"Bye", @"world", @"thing"]];
        expect(wrapper).to.haveValidSnapshot();
    });
    
    it(@"handles 5 string inputs correctly", ^{
        [metadataView setStrings:@[@"Hello", @"Bye", @"world", @"another", @"value"]];
        expect(wrapper).to.haveValidSnapshot();
    });
    
    it(@"handles 6 string inputs correctly", ^{
        [metadataView setStrings:@[@"Hello", @"Bye", @"world", @"another", @"value", @"hey?"]];
        expect(wrapper).to.haveValidSnapshot();
    });

    
    it(@"handles multi lines", ^{
        metadataView.constrainedVerticalSpace = YES;
        [metadataView setStrings:@[lorem, lorem, lorem, lorem, lorem]];
        expect(wrapper).to.haveValidSnapshot();
    });

    it(@"handles unconstrained multi lines", ^{
        metadataView.constrainedVerticalSpace = NO;
        [metadataView setStrings:@[lorem, lorem, lorem, lorem, lorem]];
        expect(wrapper).to.haveValidSnapshot();
    });

});

describe(@"with indicator ", ^{
    
    beforeEach(^{
        metadataView.needsIndicator = YES;
    });

    it(@"handles 1 string input correctly", ^{
        [metadataView setStrings:@[@"Hello"]];
        expect(wrapper).to.haveValidSnapshot();
    });
    
    it(@"handles 2 string inputs correctly", ^{
        [metadataView setStrings:@[@"Hello", @"Bye"]];
        expect(wrapper).to.haveValidSnapshot();
    });
    
    it(@"handles 3 string inputs correctly", ^{
        [metadataView setStrings:@[@"Hello", @"Bye", @"world"]];
        expect(wrapper).to.haveValidSnapshot();
    });
    
    it(@"handles 4 string inputs correctly", ^{
        [metadataView setStrings:@[@"Hello", @"Bye", @"world", @"thing"]];
        expect(wrapper).to.haveValidSnapshot();
    });
    
    it(@"handles 5 string inputs correctly", ^{
        [metadataView setStrings:@[@"Hello", @"Bye", @"world", @"another", @"value"]];
        expect(wrapper).to.haveValidSnapshot();
    });
    
    it(@"handles 6 string inputs correctly", ^{
        [metadataView setStrings:@[@"Hello", @"Bye", @"world", @"another", @"value", @"hey?"]];
        expect(wrapper).to.haveValidSnapshot();
    });
    
    it(@"handles multi lines", ^{
        metadataView.constrainedVerticalSpace = YES;
        [metadataView setStrings:@[lorem, lorem, lorem, lorem, lorem]];
        expect(wrapper).to.haveValidSnapshot();
    });

    it(@"handles unconstrained multi lines", ^{
        metadataView.constrainedVerticalSpace = NO;
        [metadataView setStrings:@[lorem, lorem, lorem, lorem, lorem]];
        expect(wrapper).to.haveValidSnapshot();
    });


    it(@"shows the number of artworks indicator in two column", ^{
        metadataView.additionalImages = 3;
        [metadataView setStrings:@[@"Hello", @"Bye", @"world", @"another", @"value"]];
        
        expect(wrapper).to.haveValidSnapshot();
    });
    it(@"shows the number of artworks indicator in one column", ^{
        metadataView.additionalImages = 3;
        
        [metadataView setStrings:@[@"Hello", @"Bye"]];
        
        expect(wrapper).to.haveValidSnapshot ();
    });

});


SpecEnd
