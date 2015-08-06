#import "UIImageView+ArtsySetURL.h"

SpecBegin(ARImageViewCategories);

__block NSString *localPath;
__block NSURL *remoteURL;
__block UIImageView *imageView;

before(^{
    localPath = [[NSBundle bundleForClass:self.class] pathForResource:@"example-image" ofType:@"png"];
    remoteURL = [NSURL URLWithString:@"http://example-image.png"];
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
});

it(@"should support setting an image locally", ^{
    [imageView setupWithFilepath:localPath url:nil];
    expect(imageView).to.haveValidSnapshot();
});

it(@"should support setting an image remotely", ^{
    [OHHTTPStubs stubRequestsMatchingAddress:remoteURL.absoluteString withImageAtPath:localPath];
    [imageView setupWithFilepath:nil url:remoteURL];
    expect(imageView).to.haveValidSnapshot();
});

it(@"should store remote images after downloading", ^{
    NSString *localTempPath = [NSTemporaryDirectory() stringByAppendingString:@"test.png"];

    [OHHTTPStubs stubRequestsMatchingAddress:remoteURL.absoluteString withImageAtPath:localPath];
    [imageView setupWithFilepath:localTempPath url:remoteURL];
    expect([[NSFileManager defaultManager] fileExistsAtPath:localTempPath]).to.beTruthy();
});


SpecEnd
