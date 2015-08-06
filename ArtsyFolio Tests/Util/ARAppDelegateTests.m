#import "ARAppDelegate.h"

SpecBegin(ARAppDelegate);

__block ARAppDelegate *sut;

before(^{
    sut = [[ARAppDelegate alloc] init];
});

it(@"sends an ARApplicationDidGoIntoBackground notification on applicationWillResignActive", ^{
    expect(^{
        [sut applicationWillResignActive:nil];
    }).to.postNotification(ARApplicationDidGoIntoBackground);
});

SpecEnd
