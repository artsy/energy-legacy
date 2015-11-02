#import "ARSyncLogger.h"
#import "ARSync+TestsExtension.h"
#import "SyncLog.h"


SpecBegin(ARSyncLogger);

__block ARSyncLogger *sut;
__block ARSync *sync;
__block NSManagedObjectContext *context;

beforeEach(^{
    sut = [[ARSyncLogger alloc] init];
    sync = [ARSync syncForTesting];
    context = sync.config.managedObjectContext;
});

it(@"creates a sync log after sync finishes", ^{
    expect([SyncLog findFirstInContext:context]).to.beFalsy();
    [sut syncDidStart:sync];
    [sut syncDidFinish:sync];
    SyncLog *log = [SyncLog findFirstInContext:context];
    expect(log).to.beTruthy();
});

it(@"logs start date", ^{
    [sut syncDidStart:sync];
    [sut syncDidFinish:sync];
    SyncLog *log = [SyncLog findFirstInContext:context];
    expect(log.dateStarted).to.beTruthy();
});

it(@"logs artworks count delta", ^{
    [ARModelFactory partiallyFilledArtworkInContext:context];
    [sut syncDidStart:sync];
    
    [ARModelFactory partiallyFilledArtworkInContext:context];
    [ARModelFactory partiallyFilledArtworkInContext:context];
    [ARModelFactory partiallyFilledArtworkInContext:context];
    [ARModelFactory partiallyFilledArtworkInContext:context];
    
    [sut syncDidFinish:sync];
    SyncLog *log = [SyncLog findFirstInContext:context];
    expect(log.artworkDelta).to.equal(4);
});

it(@"logs albums count delta", ^{
    [Album objectInContext:context];
    [sut syncDidStart:sync];
    
    [Album objectInContext:context];
    [Album objectInContext:context];
    
    [sut syncDidFinish:sync];
    SyncLog *log = [SyncLog findFirstInContext:context];
    expect(log.albumsDelta).to.equal(2);
});

it(@"logs shows count delta", ^{
    [sut syncDidStart:sync];
    
    [Show objectInContext:context];
    [Show objectInContext:context];
    [Show objectInContext:context];
    
    [sut syncDidFinish:sync];
    SyncLog *log = [SyncLog findFirstInContext:context];
    expect(log.showDelta).to.equal(3);
});

it(@"logs time to completion", ^{
    [sut syncDidStart:sync];
    
    SyncLog *log = [SyncLog findFirstInContext:context];
    log.dateStarted = [log.dateStarted dateByAddingTimeInterval:-60];
    [sut syncDidFinish:sync];
    
    expect(log.timeToCompletion).to.beInTheRangeOf(58, 62);
});

SpecEnd
