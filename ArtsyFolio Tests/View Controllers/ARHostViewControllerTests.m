#import "ARHostViewController.h"
#import "ARModelFactory.h"


@interface NSObject (HostVC)
- (void)dismissPopoversAnimated:(BOOL)animate;
@end

SpecBegin(ARHostViewController);

__block ARHostViewController *sut;
__block id sutMock;

before(^{
    sut = [[ARHostViewController alloc] init];
    sutMock = [OCMockObject partialMockForObject:sut];
});

it(@"should not go under the toolbar", ^{
    expect(sut.edgesForExtendedLayout).to.equal(UIRectEdgeNone);
});

it(@"should use presentable names when they exist", ^{
    NSManagedObjectContext *context = [CoreDataManager stubbedManagedObjectContext];
    Show *show = [Show objectInContext:context];
    Partner *partner = [Partner objectInContext:context];
    partner.name = @"Some Gallery";
    show.name = [NSString stringWithFormat:@"%@ at Some Fair", [Partner currentPartnerInContext:context].name];
    
    ARHostViewController *showController = [[ARHostViewController alloc] initWithRepresentedObject:show];
    showController.managedObjectContext = context;
    
    expect(showController.title).to.equal(@"Some Fair".uppercaseString);
});

describe(@"popovers", ^{

    it(@"should hide popovers when selecting", ^{
        [[sutMock expect] dismissPopoversAnimated:YES];
        [sut startSelecting];
        [sutMock verify];
    });

    it(@"should hide popovers when selecting", ^{
        [[sutMock expect] dismissPopoversAnimated:YES];
        [sut endSelecting];
        [sutMock verify];
    });

});

SpecEnd
