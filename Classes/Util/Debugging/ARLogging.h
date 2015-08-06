// If you update this enum, update `contextMap` in the implementation too please
typedef NS_ENUM(NSInteger, ARLogContext) {
    // starting at 1 because 0 is the default
    ARLogContextNetwork = 1,
    ARLogContextSync,
    ARLogContextAppLifecycle,
    ARLogContextErrors
};


@interface ARLogging : NSObject
/// Call this ASAP to get logging up and running
+ (void)setup;
@end

#pragma mark -
#pragma mark Context specific macros

/// File-based detailed log for network errors and diagnostics
#define ARNetworkLog(frmt, ...) ASYNC_LOG_OBJC_MAYBE(ARDDLogLevel, LOG_FLAG_VERBOSE, ARLogContextNetwork, frmt, ##__VA_ARGS__)

/// File-based detailed log for sync
#define ARSyncLog(frmt, ...) NSLog(frmt, ##__VA_ARGS__)

/// File-based application lifecycle log (Launch, memory warnings, suspension, background activity etc.)
#define ARAppLifecycleLog(frmt, ...) ASYNC_LOG_OBJC_MAYBE(ARDDLogLevel, LOG_FLAG_VERBOSE, ARLogContextAppLifecycle, frmt, ##__VA_ARGS__)

/// File-based detailed log for errors
#define ARErrorLog(frmt, ...) ASYNC_LOG_OBJC_MAYBE(ARDDLogLevel, LOG_FLAG_ERROR, ARLogContextErrors, frmt, ##__VA_ARGS__)
