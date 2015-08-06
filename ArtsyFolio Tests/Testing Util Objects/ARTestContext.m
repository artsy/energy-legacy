#import "ARTestContext.h"
#import "UIDevice+DeviceInfo.h"
#import "ARDispatchManager.h"

static OCMockObject *ARDeviceMock;
static OCMockObject *ARPartialScreenMock;
static ARTestContextOptions ARSharedTestContextOptions;

NS_ENUM(NSInteger, ARDeviceType){
    ARDeviceTypePhone4,
    ARDeviceTypePhone5,
    ARDeviceTypePhone6,
    ARDeviceTypePad};


@implementation ARTestContext

+ (void)runAsDevice:(enum ARDeviceType)device
{
    CGSize size;
    BOOL isClassedAsPhone = YES;

    switch (device) {
        case ARDeviceTypePad:
            size = (CGSize){768, 1024};
            isClassedAsPhone = NO;
            break;

        case ARDeviceTypePhone4:
            size = (CGSize){320, 480};
            break;

        case ARDeviceTypePhone5:
            size = (CGSize){320, 568};
            break;

        case ARDeviceTypePhone6:
            size = (CGSize){375, 667};
            break;
    }

    ARDeviceMock = [OCMockObject niceMockForClass:UIDevice.class];
    [[[ARDeviceMock stub] andReturnValue:OCMOCK_VALUE((BOOL){!isClassedAsPhone})] isPad];
    [[[ARDeviceMock stub] andReturnValue:OCMOCK_VALUE((BOOL){isClassedAsPhone})] isPhone];

    ARPartialScreenMock = [OCMockObject partialMockForObject:UIScreen.mainScreen];
    NSValue *phoneSize = [NSValue valueWithCGRect:(CGRect)CGRectMake(0, 0, size.width, size.height)];
    [[[ARPartialScreenMock stub] andReturnValue:phoneSize] bounds];
}

+ (void)endRunningAsDevice;
{
    [ARPartialScreenMock stopMocking];
    [ARDeviceMock stopMocking];
}

+ (void)setContext:(ARTestContextOptions)context
{
    if (context & ARTestContextDeviceTypePhone4) {
        [self runAsDevice:ARDeviceTypePhone4];
    } else if (context & ARTestContextDeviceTypePhone5) {
        [self runAsDevice:ARDeviceTypePhone5];
    } else if (context & ARTestContextDeviceTypePhone6) {
        [self runAsDevice:ARDeviceTypePhone6];
    } else if (context & ARTestContextDeviceTypePad) {
        [self runAsDevice:ARDeviceTypePad];
    }

    ARSharedTestContextOptions = context;
}

+ (void)endContext
{
    if (ARSharedTestContextOptions & ARTestContextDeviceTypePhone4 ||
        ARSharedTestContextOptions & ARTestContextDeviceTypePhone5 ||
        ARSharedTestContextOptions & ARTestContextDeviceTypePhone6 ||
        ARSharedTestContextOptions & ARTestContextDeviceTypePad) {
        [self endRunningAsDevice];
    }
}

+ (void)useContext:(ARTestContextOptions)context:(void (^)(void))block;
{
    NSParameterAssert(block);
    [self setContext:context];
    block();
    [self endContext];
}

@end
