#import "ARGridViewCell.h"

SpecBegin(ARGridViewCell);

__block ARGridViewCell *sut;
__block UIImage *exampleImage;

before(^{
    [ARTestContext setContext:ARTestContextDeviceTypePad];
    NSString *localImagePath = [[NSBundle bundleForClass:self.class] pathForResource:@"example-image" ofType:@"png"];
    exampleImage = [UIImage imageWithContentsOfFile:localImagePath];

    sut = [[ARGridViewCell alloc] initWithFrame:CGRectMake(0, 0, 242, 296)];
    [sut tintColorDidChange];
});

after(^{
    [ARTestContext endContext];
});

it(@"should set an image", ^{
    sut.image = exampleImage;
    [sut layoutSubviews];
    expect(sut).to.haveValidSnapshot();
});

it(@"should set a image and title", ^{
    sut.title = @"Title";
    [sut layoutSubviews];
    expect(sut).to.haveValidSnapshot();
});

it(@"should handle two lines of a title", ^{
    sut.title = @"Title on two lines that's long see";
    [sut layoutSubviews];
    expect(sut).to.haveValidSnapshot();
});

it(@"should set a image & title & subtitle", ^{
    sut.title = @"Title";
    sut.subtitle = @"Subtitle";
    [sut layoutSubviews];
    expect(sut).to.haveValidSnapshot();
});

it(@"should handle aspect ratios", ^{
    sut.aspectRatio = 1.3f;
    
    [sut layoutSubviews];
    expect(sut).to.haveValidSnapshot();
});

it(@"should handle the special date format", ^{
    sut.image = exampleImage;
    sut.title = @"an artwork";
    sut.subtitle = @"A date, 2014";
    
    [sut layoutSubviews];
    expect(sut).to.haveValidSnapshot();
});

it(@"supports supressing the special date format", ^{
    sut.image = exampleImage;
    sut.suppressItalics = YES;
    sut.title = @"an artwork";
    sut.subtitle = @"A date, 2014";
    
    [sut layoutSubviews];
    expect(sut).to.haveValidSnapshot();
});


it(@"should inset when in multi-selection mode", ^{
    sut.image = exampleImage;
    sut.title = @"an artwork";
    sut.subtitle = @"A date, 2014";
    sut.aspectRatio = 1.3f;

    [sut setIsMultiSelectable:YES animated:NO];
    [sut layoutSubviews];
    expect(sut).to.haveValidSnapshot();
});

it(@"should add a tick from multi-selection mode", ^{
    sut.image = exampleImage;
    sut.title = @"an artwork";
    sut.subtitle = @"A date, 2014";
    sut.aspectRatio = 1.3f;

    [sut setIsMultiSelectable:YES animated:NO];
    [sut setVisuallySelected:YES animated:NO];
    
    [sut layoutSubviews];
    expect(sut).to.haveValidSnapshot();
});

it(@"should reset tick from multi-selection mode", ^{
    sut.image = exampleImage;
    sut.title = @"an artwork";
    sut.subtitle = @"A date, 2014";
    [sut setVisuallySelected:YES animated:NO];
    [sut setVisuallySelected:NO animated:NO];

    [sut layoutSubviews];
    expect(sut).to.haveValidSnapshot();
});


SpecEnd
