#import "ARSelectionToolbarView.h"
#import "ARBlockRunner.h"

SpecBegin(ARSelectionToolbarView);

__block ARSelectionToolbarView *sut;

before(^{
    [ARTestContext setContext:ARTestContextDeviceTypePad];
    sut = [[ARSelectionToolbarView alloc] init];
});

after(^{
    [ARTestContext endContext];
});

describe(@"constrained width", ^{
    beforeEach(^{
        sut.horizontallyConstrained = YES;
    });
    
    it(@"handles creating one button", ^{
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"Hello World" style:UIBarButtonItemStylePlain target:nil action:nil];
        sut.barButtonItems = @[item];
        sut.frame = CGRectMake(0, 0, 320, sut.intrinsicContentSize.height);
        
        expect(sut).to.haveValidSnapshot();
    });

    it(@"handles creating two buttons", ^{
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"Hello World" style:UIBarButtonItemStylePlain target:nil action:nil];
        UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithTitle:@"2nd Life" style:UIBarButtonItemStylePlain target:nil action:nil];

        sut.barButtonItems = @[item, item2];
        sut.frame = CGRectMake(0, 0, 320, sut.intrinsicContentSize.height);
        
        expect(sut).to.haveValidSnapshot();
    });
});

describe(@"unconstrained width", ^{
    beforeEach(^{
        sut.horizontallyConstrained = NO;
    });
    
    it(@"handles creating one button", ^{
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"Hello World" style:UIBarButtonItemStylePlain target:nil action:nil];
        sut.barButtonItems = @[item];
        sut.frame = CGRectMake(0, 0, 320, sut.intrinsicContentSize.height);
        
        expect(sut).to.haveValidSnapshot();
    });
    
    it(@"handles creating two buttons", ^{
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"Hello World" style:UIBarButtonItemStylePlain target:nil action:nil];
        UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithTitle:@"2nd Life" style:UIBarButtonItemStylePlain target:nil action:nil];
        
        sut.barButtonItems = @[item, item2];
        sut.frame = CGRectMake(0, 0, 320, sut.intrinsicContentSize.height);
        
        expect(sut).to.haveValidSnapshot();
    });
});

it(@"should handle callbacks", ^{
    ARBlockRunner *blockRunner = [[ARBlockRunner alloc] init];
    __block BOOL success = NO;

    blockRunner.block = ^{
        success = YES;
    };
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"Hello World" style:UIBarButtonItemStylePlain target:blockRunner action:@selector(runBlock)];
    sut.barButtonItems = @[item];
    [sut.button sendActionsForControlEvents:UIControlEventTouchUpInside];
    expect(success).to.beTruthy();
});


SpecEnd
