#import "ARSlideshowImageView.h"

SpecBegin(ARSlideshowImageView);

__block ARSlideshowImageView *sut;
__block UIView *container;
__block NSString *localImagePath;

describe(@"defaults", ^{
    before(^{
        container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
        sut = [[ARSlideshowImageView alloc] initWithFrame:container.bounds];
        [container addSubview:sut];

        localImagePath = [[NSBundle bundleForClass:self.class] pathForResource:@"example-image" ofType:@"png"];
    });

    it(@"starts out empty", ^{
        expect(sut.subviews.count).to.equal(0);
        expect(sut.currentImageView).to.beNil();
    });

    it(@"adds a file to the image queue", ^{
        expect(sut.hasImages).to.beFalsy();
        [sut addImagePathToQueue:localImagePath];
        expect(sut.hasImages).to.beTruthy();
    });

    it(@"shows the image ", ^{
        [sut addImagePathToQueue:localImagePath];
        [sut start];
        expect(sut.subviews.count).to.equal(1);
    });

});

SpecEnd
