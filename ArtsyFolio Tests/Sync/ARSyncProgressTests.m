#import "ARSyncProgress.h"

SpecBegin(ARSyncProgress);

__block ARSyncProgress *sut;

before(^{
    sut = [[ARSyncProgress alloc] init];
});

describe(@"estimates", ^{
    it(@"it provides an estimate based on the bytes downloaded", ^{
        [sut startWithLastSyncLog:0];
        sut.numEstimatedBytes = 1000000000;
        [sut downloadedNumBytes:10000];

        expect(sut.estimatedTimeRemaining).to.beLessThan(7);
    });

    it(@"it weighs the estimate based on a last sync time", ^{
        [sut startWithLastSyncLog:20];
        sut.numEstimatedBytes = 1000000000;
        [sut downloadedNumBytes:10000];

        expect(sut.estimatedTimeRemaining).to.beInTheRangeOf(9, 11);
    });

});

SpecEnd
