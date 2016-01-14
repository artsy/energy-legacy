#import "ARSync.h"
#import <DRBOperationTree/DRBOperationTree.h>
#import "ARStubbedSyncProvider.h"
#import "ARStubbedSyncDelegate.h"
#import "ARStubbedDRBOperation.h"

DRBOperationTree *stubbedTree(dispatch_block_t block);


@interface ARSync (Testing)
@property (readwrite, nonatomic, strong) DRBOperationTree *rootOperation;
@end

SpecBegin(ARSync);

describe(@"perform sync", ^{
    __block ARSync *sync;
    __block ARStubbedSyncDelegate *delegate;

    before(^{
        ARSyncDeleter *deleter = [[ARSyncDeleter alloc] init];
        ARSyncConfig *config = [[ARSyncConfig alloc] initWithManagedObjectContext:[CoreDataManager stubbedManagedObjectContext] defaults:[[NSUserDefaults alloc] init] deleter:deleter];
        delegate = [[ARStubbedSyncDelegate alloc] init];

        sync = [[ARSync alloc] init];
        sync.config = config;
        sync.delegate = delegate;
    });

    it(@"before sync isSyncing is false", ^{
        expect(sync.isSyncing).to.beFalsy();
    });

    it(@"during sync isSyncing is true", ^{
        sync.rootOperation = stubbedTree(^{
            expect(sync.isSyncing).to.beTruthy();
        });
        [sync sync];
    });

    it(@"after sync isSyncing is false", ^{
        sync.rootOperation = stubbedTree(^{});
        delegate.onSyncCompletion = ^{
            expect(sync.isSyncing).to.beFalsy();
        };

        [sync sync];
    });
});

SpecEnd

    DRBOperationTree *
    stubbedTree(dispatch_block_t block)
{
    NSOperationQueue *stubbedOperationQueue = [NSOperationQueue mainQueue];
    DRBOperationTree *root = [[ARStubbedDRBOperation alloc] initWithOperationQueue:stubbedOperationQueue];
    ARStubbedSyncProvider *stub = [[ARStubbedSyncProvider alloc] init];
    stub.sideEffect = block;
    root.provider = stub;
    return root;
}
