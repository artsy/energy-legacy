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
        /// Sync will crash without a config and deleter
        ARSyncDeleter *deleter = [[ARSyncDeleter alloc] init];
        ARSyncConfig *config = [[ARSyncConfig alloc] initWithManagedObjectContext:[CoreDataManager stubbedManagedObjectContext] defaults:[[NSUserDefaults alloc] init] deleter:deleter];
        delegate = [[ARStubbedSyncDelegate alloc] init];

        sync = [[ARSync alloc] init];
        sync.config = config;
        sync.delegate = delegate;
    });

    it(@"before sync isSyncing is false", ^{
        
        /// This should be false at all times unless a sync is in progress
        expect(sync.isSyncing).to.beFalsy();
    });

    it(@"during sync isSyncing is true", ^{
        
        /// Any code in stubbedTree's block parameter will be executed as part of the sync operation tree, so we check that isSyncing is true here
        sync.rootOperation = stubbedTree(^{
            expect(sync.isSyncing).to.beTruthy();
        });
        [sync sync];
    });

    it(@"after sync isSyncing is false", ^{
        
        /// We don't need the operation tree to actually do anything; we just need to make sure sync updates itself properly once operations are completed
        sync.rootOperation = stubbedTree(^{});
        
        /// onSyncCompletion will run when syncDidFinish is called
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
    /// Keep everything on the main queue; no threading
    NSOperationQueue *stubbedOperationQueue = [NSOperationQueue mainQueue];

    /// This creates a synchronous version of DRBOperationTree
    DRBOperationTree *root = [[ARStubbedDRBOperation alloc] initWithOperationQueue:stubbedOperationQueue];

    /// The sideEffect block is executed in the provider's objectsForObject method before any operations
    ARStubbedSyncProvider *stub = [[ARStubbedSyncProvider alloc] init];
    stub.sideEffect = block;

    root.provider = stub;
    return root;
}
