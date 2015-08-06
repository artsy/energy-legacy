#import "ARImageThumbnailCreator.h"
#import "ARImageFormat.h"
#import "ARThumbnailCreationOperation.h"
#import "ARFeedKeys.h"


@interface ARImageThumbnailCreatorTests : XCTestCase
@end

@protocol Image <NSObject>
@property (nonatomic, strong) NSString *slug;
@end


@implementation ARImageThumbnailCreatorTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (id)mockFormat:(BOOL)large
{
    id image = [OCMockObject mockForProtocol:@protocol(Image)];
    [[[image stub] andReturn:@"image-slug"] slug];

    id format = [OCMockObject mockForClass:[ARImageFormat class]];
    [[[format stub] andReturnValue:OCMOCK_VALUE(large)] isLarge];
    [[[format stub] andReturn:image] image];
    [(ARImageFormat *)[[format stub] andReturn:ARFeedImageSizeMediumKey] format];
    return format;
}

- (void)assertResultCount:(NSUInteger)count withImageFormat:(id)format
{
    ARImageThumbnailCreator *creator = [[ARImageThumbnailCreator alloc] init];
    __block NSArray *result = nil;
    [creator operationTree:nil objectsForObject:format completion:^(NSArray *objects) {
        result = objects;
    }];

    expect([result count]).will.equal(count);
}

- (void)testObjectsForLargeImage
{
    id format = [self mockFormat:YES];
    [self assertResultCount:2 withImageFormat:format];
}

- (void)testObjectsForNonLargeImage
{
    id format = [self mockFormat:NO];
    [self assertResultCount:0 withImageFormat:format];
}

- (void)testOperationForObject
{
    id format = [self mockFormat:YES];
    ARImageThumbnailCreator *creator = [[ARImageThumbnailCreator alloc] init];
    NSOperation *operation = [creator operationTree:nil
                                 operationForObject:format
                                       continuation:nil
                                            failure:nil];
    expect([operation class]).to.equal([ARThumbnailCreationOperation class]);
}

@end
