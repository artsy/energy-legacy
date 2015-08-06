#import "ARSyncMessageViewController.h"
#import "ARSync.h"

SpecBegin(ARSyncMessageViewController);

__block ARSyncMessageViewController *sut;

it(@"shows a message on phone", ^{
    sut = [[ARSyncMessageViewController alloc] initWithMessage:@"Message goes here" sync:nil];

    [ARTestContext useContext:ARTestContextDeviceTypePhone5 :^{
        sut.view.frame = [UIScreen mainScreen].bounds;
       expect(sut).to.haveValidSnapshot();
    }];
});

it(@"shows a message on pad", ^{
    sut = [[ARSyncMessageViewController alloc] initWithMessage:@"Message goes here" sync:nil];
    
    [ARTestContext useContext:ARTestContextDeviceTypePad :^{
        sut.view.frame = [UIScreen mainScreen].bounds;
        expect(sut).to.haveValidSnapshot();
    }];
});

it(@"sets the delegates for sync and progress", ^{
    ARSync *sync = [[ARSync alloc] init];
    ARSyncProgress *progress = [[ARSyncProgress alloc] init];
    sync.progress = progress;
    
    sut = [[ARSyncMessageViewController alloc] initWithMessage:@"" sync:sync];
    
    expect(sync.delegate).to.equal(sut);
    expect(sync.progress.delegate).to.equal(sut);
});

describe(@"show sync progress ", ^{
    __block ARSync *sync;
    __block ARSyncProgress *progress;
    
    beforeEach(^{
        sync = [[ARSync alloc] init];
        progress = [[ARSyncProgress alloc] init];
        sync.progress = progress;
        
        [progress setNumEstimatedBytes:30];
    });
    
    it(@"on phone", ^{
        
        sut = [[ARSyncMessageViewController alloc] initWithMessage:@"Message goes here" sync:sync];
        
        [ARTestContext useContext:ARTestContextDeviceTypePhone5 :^{
            sut.view.frame = [UIScreen mainScreen].bounds;
            [sync.progress downloadedNumBytes:20];
            
            expect(sut).to.haveValidSnapshot();
        }];
    });

    it(@"on pad", ^{
        
        sut = [[ARSyncMessageViewController alloc] initWithMessage:@"Message goes here" sync:sync];
        [sync.progress.delegate syncDidProgress:sync.progress];
        
        [ARTestContext useContext:ARTestContextDeviceTypePad :^{
            sut.view.frame = [UIScreen mainScreen].bounds;
            [sync.progress downloadedNumBytes:20];
            
            expect(sut).to.haveValidSnapshot();
        }];
    });

});

SpecEnd
