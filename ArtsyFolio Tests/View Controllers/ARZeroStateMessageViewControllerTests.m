#import "ARZeroStateMessageViewController.h"
#import "ARSync.h"
#import "ARBaseViewController+TransparentModals.h"

@interface ARZeroStateMessageViewController () <ARSyncDelegate>
@property (nonatomic, strong) ARSync *sync;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

// I don't like doing this, but otherwise there's a lot of crazy hacking
// to get a working UIWindow heirarchy.
- (void)dismissSelf;

@end

SpecBegin(ARZeroStateMessageViewController)

__block ARZeroStateMessageViewController *sut;

before(^{
    sut = [[ARZeroStateMessageViewController alloc] init];
});

it(@"runs a sync on the when tapping the retry button ", ^{
    id syncMock = OCMClassMock(ARSync.class);
    sut.sync = syncMock;

    OCMExpect([(ARSync *)syncMock sync]);
    sut.secondaryAction();

    OCMVerifyAll(syncMock);
});

it(@"removes the overlay on a sync completion if partner has works", ^{
    ARZeroStateMessageViewController *zeroVC = [[ARZeroStateMessageViewController alloc] init];
    zeroVC.managedObjectContext = [CoreDataManager stubbedManagedObjectContext];

    // Make the partner has work checks pass
    id _ = [Partner modelFromJSON:@{} inContext:zeroVC.managedObjectContext];
    _ = [Artwork modelFromJSON:@{} inContext:zeroVC.managedObjectContext];


    id rootVCMock = OCMPartialMock(zeroVC);
    OCMExpect([rootVCMock dismissSelf]);

    [rootVCMock syncDidFinish:nil];
    OCMVerifyAll(rootVCMock);
});

SpecEnd
