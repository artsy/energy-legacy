typedef NS_OPTIONS(NSInteger, ARTestContextOptions) {
    ARTestContextNone = 0,
    ARTestContextDeviceTypePhone4 = 1 << 1,
    ARTestContextDeviceTypePhone5 = 1 << 2,
    ARTestContextDeviceTypePhone6 = 1 << 3,
    ARTestContextDeviceTypePad = 1 << 4,
};


@interface ARTestContext : NSObject

/// Runs the block in the specified test context
+ (void)useContext:(ARTestContextOptions)context:(void (^)(void))block;

/// Creates a test context
+ (void)setContext:(ARTestContextOptions)context;

/// Closes and stops mocks for the test context
+ (void)endContext;

@end
