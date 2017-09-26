#import "ARAmbiguousSplitStackView.h"
#import "ARDebugPlaceholderView.h"
#import <FLKAutoLayout/UIView+FLKAutoLayout.h>

SpecBegin(ARAmbiguousSplitStackView);

__block UIView *wrapper;
__block ARAmbiguousSplitStackView *sut;
__block ARDebugPlaceholderView *view1, *view2, *view3, *view4, *view5;

before(^{
    wrapper = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 300)];
    sut = [[ARAmbiguousSplitStackView alloc] init];
    view1 = [[ARDebugPlaceholderView alloc] initWithSize:(CGSize) { 25, 25 } color:UIColor.blueColor];
    view2 = [[ARDebugPlaceholderView alloc] initWithSize:(CGSize) { 25, 88 } color:UIColor.orangeColor];
    view3 = [[ARDebugPlaceholderView alloc] initWithSize:(CGSize) { 25, 33 } color:UIColor.greenColor];
    view4 = [[ARDebugPlaceholderView alloc] initWithSize:(CGSize) { 25, 10 } color:UIColor.purpleColor];
    view5 = [[ARDebugPlaceholderView alloc] initWithSize:(CGSize) { 25, 100 } color:UIColor.redColor];

    [wrapper addSubview:sut];
    [sut alignTop:@"0" leading:@"0" bottom:nil trailing:@"0" toView:wrapper];
});

describe(@"single stack", ^{
    before(^{
        sut.isSplit = NO;
    });

    it(@"with one view", ^{
        [sut addSubview:view1 withPrecedingMargin:@"0"];
        expect(wrapper).to.haveValidSnapshot();
    });

    it(@"with two views", ^{
        [sut addSubview:view1 withPrecedingMargin:@"0"];
        [sut addSubview:view2 withPrecedingMargin:@"0"];
        expect(wrapper).to.haveValidSnapshot();
    });

    it(@"with three views", ^{
        [sut addSubview:view1 withPrecedingMargin:@"0"];
        [sut addSubview:view2 withPrecedingMargin:@"0"];
        [sut addSubview:view3 withPrecedingMargin:@"0"];
        expect(wrapper).to.haveValidSnapshot();
    });
});

describe(@"margins", ^{
    before(^{
        sut.isSplit = YES;
    });

    it(@"small with three views", ^{
        sut.centerMargin = 20;
        [sut addSubview:view1 withPrecedingMargin:@"0"];
        [sut addSubview:view2 withPrecedingMargin:@"0"];
        [sut addSubview:view3 withPrecedingMargin:@"0"];
        expect(wrapper).to.haveValidSnapshot();
    });

    it(@"medium with three views", ^{
        sut.centerMargin = 50;
        [sut addSubview:view1 withPrecedingMargin:@"0"];
        [sut addSubview:view2 withPrecedingMargin:@"0"];
        [sut addSubview:view3 withPrecedingMargin:@"0"];
        expect(wrapper).to.haveValidSnapshot();
    });

});

describe(@"bg color", ^{
    it(@"works right on single", ^{
        [sut addSubview:view1 withPrecedingMargin:@"20"];
        sut.backgroundColor = UIColor.blackColor;
        expect(wrapper).to.haveValidSnapshot();
    });

    it(@"works right in split", ^{
        sut.isSplit = YES;
        [sut addSubview:view1 withPrecedingMargin:@"20"];
        [sut addSubview:view2 withPrecedingMargin:@"20"];
        sut.backgroundColor = UIColor.blackColor;
        expect(wrapper).to.haveValidSnapshot();
    });
});

describe(@"double stack", ^{
    before(^{
        sut.isSplit = YES;
    });

    it(@"with one view", ^{
        [sut addSubview:view1 withPrecedingMargin:@"0"];
        expect(wrapper).to.haveValidSnapshot();
    });

    it(@"with two views", ^{
        [sut addSubview:view1 withPrecedingMargin:@"0"];
        [sut addSubview:view2 withPrecedingMargin:@"0"];
        expect(wrapper).to.haveValidSnapshot();
    });

    it(@"with three views", ^{
        [sut addSubview:view1 withPrecedingMargin:@"0"];
        [sut addSubview:view2 withPrecedingMargin:@"0"];
        [sut addSubview:view3 withPrecedingMargin:@"0"];
        expect(wrapper).to.haveValidSnapshot();
    });

    it(@"with four views", ^{
        [sut addSubview:view1 withPrecedingMargin:@"0"];
        [sut addSubview:view2 withPrecedingMargin:@"0"];
        [sut addSubview:view3 withPrecedingMargin:@"0"];
        [sut addSubview:view4 withPrecedingMargin:@"0"];
        expect(wrapper).to.haveValidSnapshot();
    });

    it(@"with five views", ^{
        [sut addSubview:view1 withPrecedingMargin:@"0"];
        [sut addSubview:view2 withPrecedingMargin:@"0"];
        [sut addSubview:view3 withPrecedingMargin:@"0"];
        [sut addSubview:view4 withPrecedingMargin:@"0"];
        [sut addSubview:view5 withPrecedingMargin:@"0"];
        expect(wrapper).to.haveValidSnapshot();
    });
});


SpecEnd
