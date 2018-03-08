#import <Foundation/Foundation.h>
#import "NSString+StripHTML.h"

SpecBegin(StringStripHTML);

describe(@"strips text correctly", ^{
    it(@"handles HTML", ^{
        NSString *before = @"Hello";
        NSString *after  = @"Hello";
        expect(before.stringByStrippingHTML).to.equal(after);
    });

    it(@"handles a backslash", ^{
        NSString *before = @"Framed dimensions: 49 1/4 x 39 3/4 inches (125.1 x 101 cm). From an edition of 10.";
        NSString *after  = @"Framed dimensions: 49 1/4 x 39 3/4 inches (125.1 x 101 cm). From an edition of 10.";
        expect(before.stringByStrippingHTML).to.equal(after);
    });

    it(@"handles a backslash", ^{
        NSString *before = @"Framed dimensions: 49 1/4 x 39 3/4 inches (125.1 x 101 cm). From an edition of 10.";
        NSString *after  = @"Framed dimensions: 49 1/4 x 39 3/4 inches (125.1 x 101 cm). From an edition of 10.";
        expect(before.stringByStrippingHTML).to.equal(after);
    });
});

SpecEnd
