#import <DRBOperationTree/DRBOperationTree.h>
#import "ARSync.h"
#import "ARDefaults.h"
#import "ARNotifications.h"
#import "ARSynchronousOperationTree.h"
#import "ARSyncronousTreeProvider.h"
#import "ARFeedTranslator.h"
#import "PartnerOption.h"
#import <ISO8601DateFormatter/ISO8601DateFormatter.h>

DRBOperationTree *blockBasedTree(void);
ARSync *stubbedSync(void);
ARSyncProgress *stubbedProgress(void);


@interface ARSync (Private)
@property (readwrite, nonatomic, strong) DRBOperationTree *rootOperation;
@property (nonatomic, strong) NSUserDefaults *defaults;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (readwrite, nonatomic, strong) UIApplication *sharedApplication;

- (BOOL)shouldSyncBasedOnPartnerCMSLoginDate;
@end

SpecBegin(ARSync);

__block ISO8601DateFormatter *formatter;

beforeAll(^{
    [ARFeedTranslator shouldParseJSON:NO];
    formatter = [[ISO8601DateFormatter alloc] init];
});

afterAll(^{
    [ARFeedTranslator shouldParseJSON:YES];
});

describe(@"delegate", ^{

    it(@"saves when expected", ^{
        id aMock = [OCMockObject mockForProtocol:@protocol(ARSyncDelegate)];
        [[aMock expect] syncDidFinish:[OCMArg any]];

        ARSync *sync = stubbedSync();
        sync.delegate = aMock;
        [sync sync];

        expect(^{ [aMock verify]; }).willNot.raiseAny();
    });
});

describe(@"notifications", ^{
    
    it(@"sends a sync stated notification on sync", ^{
        ARSync *sync = stubbedSync();
        expect(^{ [sync sync]; }).will.notify(ARSyncStartedNotification);
    });
    
    it(@"sends a sync finished notification on sync finished", ^{
        ARSync *sync = stubbedSync();
        expect(^{ [sync sync]; }).will.notify(ARSyncFinishedNotification);
    });

    it(@"listens for ARApplicationDidGoIntoBackground during syncs", ^{
        ARSync *sync = stubbedSync();

        expect(^{ [sync sync]; }).will.notify(ARSyncFinishedNotification);
    });
});

describe(@"saving", ^{
    
    it(@"saves when calling save", ^{
        ARSync *sync = stubbedSync();
        [Artwork stubbedArtworkWithImages:NO inContext:sync.managedObjectContext];
        
        expect(sync.managedObjectContext.hasChanges).to.beTruthy();
        [sync save];
        expect(sync.managedObjectContext.hasChanges).to.beFalsy();
    });
});


pending(@"doesnt sleep", ^{
    ARSync *sync = stubbedSync();

    OCMockObject *appMock = [OCMockObject mockForClass:UIApplication.class];
    [[[appMock expect] ignoringNonObjectArgs] setIdleTimerDisabled:NO];
    
    sync.sharedApplication = (id)appMock;
    [sync sync];
    expect(^{ [appMock verify]; }).toNot.raiseAny();
});


describe(@"On running sync", ^{
    it(@"starts the progress object", ^{
        ARSync *sync = stubbedSync();
        ARSyncProgress *progress = stubbedProgress();
        expect(progress.startDate).to.beFalsy();

        sync.progress = progress;
        [sync sync];

        expect(progress.startDate).will.beTruthy();
    });

    pending(@"cancel stops all operations");
    pending(@"pausing pause active operations");

    pending(@"on completion", ^{
        it(@"sends a refresh notification", ^{
            ARSync *sync = stubbedSync();
            expect(^{ [sync sync]; }).to.notify(ARSyncFinishedNotification);
        });

        it(@"nils the root operation", ^{
            id sync = stubbedSync();
            [[sync expect] setRootOperation:[OCMArg isNil]];
            [sync sync];
            expect(^{ [sync verify]; }).willNot.raiseAny();
        });

    });
});

pending(@"marks all objects for deletion");
pending(@"calls for deletion of unused objects");

SpecEnd

    ARSyncProgress *
    stubbedProgress(void)
{
    id progress = [[ARSyncProgress alloc] init];
    return progress;
}

ARSync *stubbedSync(void)
{
    ARSync *sync = [[ARSync alloc] init];
    sync.managedObjectContext = [CoreDataManager stubbedManagedObjectContext];
    sync.rootOperation = blockBasedTree();
    return [OCMockObject partialMockForObject:sync];
}

DRBOperationTree *blockBasedTree(void)
{
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    DRBOperationTree *parent = [[ARSynchronousOperationTree alloc] initWithOperationQueue:queue];
    DRBOperationTree *child = [[ARSynchronousOperationTree alloc] initWithOperationQueue:queue];
    child.provider = [[ARSyncronousTreeProvider alloc] init];
    parent.provider = [[ARSyncronousTreeProvider alloc] init];
    [parent addChild:child];
    return parent;
}
