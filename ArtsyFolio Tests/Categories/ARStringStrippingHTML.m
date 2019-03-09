#import <Foundation/Foundation.h>
#import "NSString+StripHTML.h"
#import "Artwork+HTMLTexts.h"

SpecBegin(StringStripHTML);

describe(@"strips text correctly", ^{
    it(@"handles HTML", ^{
        NSString *before = @"Hello";
        NSString *after = @"Hello";
        expect(before.stringByStrippingHTML).to.equal(after);
    });

    it(@"handles a backslash", ^{
        NSString *before = @"Framed dimensions: 49 1/4 x 39 3/4 inches (125.1 x 101 cm). From an edition of 10.";
        NSString *after = @"Framed dimensions: 49 1/4 x 39 3/4 inches (125.1 x 101 cm). From an edition of 10.";
        expect(before.stringByStrippingHTML).to.equal(after);
    });

    it(@"handles quotes", ^{
        NSString *before = @"single ' double \"";
        NSString *after = @"single ' double \"";
        expect(before.stringByStrippingHTML).to.equal(after);
    });

    it(@"handles de-gunking stringsfrom the HTML-er", ^{
        NSManagedObjectContext *context = [CoreDataManager stubbedManagedObjectContext];

        Artwork *artwork = [Artwork modelFromJSON:@{
            ARFeedArtworkInfoKey : @"It’s my work thanks",
        } inContext:context];

        NSString *htmlInfo = artwork.htmlInfo;
        expect(htmlInfo).to.equal(@"<p style='font-family: Georgia, serif; font-weight:100;margin-bottom:0px;margin-top:0px;'>It’s my work thanks</p>");

        NSString *reversal = [htmlInfo stringByStrippingHTML];
        NSString *after = @"It’s my work thanks";
        expect(reversal).to.equal(after);
    });
});

SpecEnd
