#import "ARArtworkMetadataView.h"
#import "AROptions.h"
#import "NSAttributedString+Artsy.h"

SpecBegin(ARArtworkMetadataView);

__block ARArtworkMetadataView *metadataView;
__block UIView *wrapper;

beforeEach(^{
    wrapper = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 400)];
    wrapper.backgroundColor = [UIColor colorWithWhite:0.80f alpha:1.000];

    metadataView = [[ARArtworkMetadataView alloc] initWithFrame:wrapper.bounds];
    [wrapper addSubview:metadataView];
});

it(@"handles mixed strings correctly", ^{
    Artwork *artwork = [Artwork stubbedModelFromJSON: @{
        @"id":@"id", @"title": @"artwork", @"date":@"date"
    }];

    [metadataView setStrings:@[@"Hello", [NSAttributedString titleAndDateStringForArtwork:artwork]]];
    expect(wrapper).to.haveValidSnapshot();
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

    it(@"ignores more than 3 string inputs", ^{
        [metadataView setStrings:@[@"Hello", @"Bye", @"world", @"another", @"value"]];
        expect(wrapper).to.haveValidSnapshot();
    });

    itHasSnapshotsForViewControllerWithDevicesAndColorStates(@"with no indicator with multi lines", ^{
        wrapper = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        wrapper.backgroundColor = [UIColor colorWithWhite:0.800f alpha:1.000];
        metadataView = [[ARArtworkMetadataView alloc] initWithFrame:wrapper.bounds];
        [wrapper addSubview:metadataView];

        [metadataView setStrings:@[@"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec a diam lectus. Sed sit amet ipsum mauris. Maecenas congue ligula ac quam viverra nec consectetur ante hendrerit. Donec et mollis dolor. ", @"Vivamus fermentum semper porta. Nunc diam velit, adipiscing ut tristique vitae, sagittis vel odio. Maecenas convallis ullamcorper ultricies."]];

        return wrapper;
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

    it(@"ignores more than 4 string inputs", ^{
        [metadataView setStrings:@[@"Hello", @"Bye", @"world", @"another", @"think"]];
        expect(wrapper).to.haveValidSnapshot();
    });

    it(@"handles multi lines", ^{
        [metadataView setStrings:@[@"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec a diam lectus. Sed sit amet ipsum mauris. Maecenas congue ligula ac quam viverra nec consectetur ante hendrerit. Donec et mollis dolor. ", @"Vivamus fermentum semper porta. Nunc diam velit, adipiscing ut tristique vitae, sagittis vel odio. Maecenas convallis ullamcorper ultricies."]];
        expect(wrapper).to.haveValidSnapshot();
    });

    it(@"shows the number of artworks indicator", ^{
        metadataView.additionalImages = 3;
        [metadataView setStrings:@[@"Hello", @"Bye"]];

        expect(wrapper).to.haveValidSnapshot();
    });

});


SpecEnd
