#import "ARHighlightableImageView.h"

SpecBegin(ARHighlightableImageView);

__block ARHighlightableImageView *sut;
__block UIImage *exampleImage;

before(^{
    NSString *localImagePath = [[NSBundle bundleForClass:self.class] pathForResource:@"example-image" ofType:@"png"];
    exampleImage = [UIImage imageWithContentsOfFile:localImagePath];

    sut = [[ARHighlightableImageView alloc] initWithFrame:CGRectMake(0, 0, 240, 240)];
});

it(@"setting the image sets the image", ^{
    sut.image = exampleImage;
    expect(sut).to.haveValidSnapshot();
});

it(@"setting the bg works", ^{
    sut.imageBackgroundColor = [UIColor lightGrayColor] ;
    expect(sut).to.haveValidSnapshot();
});

it(@"should constrain to aspect ratios", ^{
    sut.imageBackgroundColor = [UIColor lightGrayColor];
    sut.aspectRatio = 0.33f;
    expect(sut).to.haveValidSnapshot();
});

it(@"should constrain to the same aspect ratio but zoom in and out", ^{
    sut.imageBackgroundColor = [UIColor lightGrayColor];
    sut.aspectRatio = 0.2f;
    
    [sut setContentInsetX:5 insetY:5 animated:NO];
    expect(sut).to.haveValidSnapshotNamed(@"vertical inset 5 5");
    
    [sut setContentInsetX:5 insetY:20 animated:NO];
    expect(sut).to.haveValidSnapshotNamed(@"vertical inset 5 20");
    
    [sut setContentInsetX:20 insetY:20 animated:NO];
    expect(sut).to.haveValidSnapshotNamed(@"vertical inset 20");
    
    sut.aspectRatio = 1.2f;
    
    [sut setContentInsetX:5 insetY:5 animated:NO];
    expect(sut).to.haveValidSnapshotNamed(@"horizontal inset 5 5");
    
    [sut setContentInsetX:5 insetY:20 animated:NO];
    expect(sut).to.haveValidSnapshotNamed(@"horizontal inset 5 20");
    
    [sut setContentInsetX:20 insetY:20 animated:NO];
    expect(sut).to.haveValidSnapshotNamed(@"horizontal inset 20");
    
    sut.aspectRatio = 1.5;
    sut.image = exampleImage;
    [sut setContentInsetX:40 insetY:40 animated:NO];
    expect(sut).to.haveValidSnapshotNamed(@"inset works with image");
});

it(@"should add a badge", ^{
    sut.imageBackgroundColor  = [UIColor lightGrayColor];
    sut.aspectRatio = 0.33f;
    [sut addBadge:exampleImage animated:NO];
    
    expect(sut).to.haveValidSnapshot();
});

it(@"should remove a badge", ^{
    sut.imageBackgroundColor = [UIColor lightGrayColor];
    sut.aspectRatio = 0.33f;
    [sut addBadge:exampleImage animated:NO];
    [sut removeBadgeAnimated:NO];
    
    expect(sut).to.haveValidSnapshot();
});


SpecEnd
