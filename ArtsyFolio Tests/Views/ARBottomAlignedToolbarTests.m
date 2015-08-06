#import "ARBottomAlignedToolbar.h"

SpecBegin(ARBottomAlignedToolbar);

__block ARBottomAlignedToolbar *sut;
__block UIBarButtonItem *leftItem, *leftItem2, *rightItem, *rightItem2;

before(^{
    [ARTestContext setContext:ARTestContextDeviceTypePad];
    sut = [[ARBottomAlignedToolbar alloc] init];
    sut.frame = CGRectMake(0, 0, 320, sut.intrinsicContentSize.height);

    leftItem = [[UIBarButtonItem alloc] initWithTitle:@"left" style:UIBarButtonItemStylePlain target:self action:@selector(sourceModel)];
    leftItem2 = [[UIBarButtonItem alloc] initWithTitle:@"left2" style:UIBarButtonItemStylePlain target:self action:@selector(sourceModel)];
    rightItem = [[UIBarButtonItem alloc] initWithTitle:@"right" style:UIBarButtonItemStylePlain target:self action:@selector(sourceModel)];
    rightItem2 = [[UIBarButtonItem alloc] initWithTitle:@"right2" style:UIBarButtonItemStylePlain target:self action:@selector(sourceModel)];
});

after(^{
    [ARTestContext endContext];
});

it(@"handles a left item", ^{
    sut.leftBarButtonItem = leftItem;
    expect(sut).to.haveValidSnapshot();
});

it(@"handles a right item", ^{
    sut.rightBarButtonItem = rightItem;
    expect(sut).to.haveValidSnapshot();
});

it(@"handles both left & right items", ^{
    sut.leftBarButtonItem = leftItem;
    sut.rightBarButtonItem = rightItem;
    expect(sut).to.haveValidSnapshot();
});

it(@"handles multiple left & right items", ^{
    sut.leftBarButtonItems = @[leftItem, leftItem2];
    sut.rightBarButtonItems = @[rightItem, rightItem2];
    expect(sut).to.haveValidSnapshot();
});

it(@"handles multiple right items", ^{
    sut.rightBarButtonItems = @[rightItem, rightItem2];
    expect(sut).to.haveValidSnapshot();
});

it(@"handles multiple left items", ^{
    sut.leftBarButtonItems = @[leftItem, leftItem2];
    expect(sut).to.haveValidSnapshot();
});

it(@"handles overwriting items", ^{
    sut.rightBarButtonItems = @[leftItem, leftItem2];
    sut.rightBarButtonItems = @[rightItem, rightItem2];
    expect(sut).to.haveValidSnapshot();
});

it(@"passes through single items to the array methods", ^{
    OCMockObject *sutMock = [OCMockObject partialMockForObject:sut];

    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"title" style:UIBarButtonItemStylePlain target:self action:@selector(sourceModel)];

    [[sutMock expect] setRightBarButtonItems:OCMOCK_ANY];
    [[sutMock expect] setLeftBarButtonItems:OCMOCK_ANY];

    sut.leftBarButtonItem = item;
    sut.rightBarButtonItem = item;

    [sutMock verify];
});


SpecEnd
