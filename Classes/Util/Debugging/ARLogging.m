#import <CocoaLumberjack/DDASLLogger.h>
#import <CocoaLumberjack/DDTTYLogger.h>
#import <CocoaLumberjack/DDFileLogger.h>

// Human-readable context names for file loggers
static const NSDictionary *contextMap;


@interface ARLogFilter : NSObject <DDLogFormatter>

- (instancetype)initWithContext:(NSInteger)context;

@property (nonatomic, assign) NSInteger context;
@property (nonatomic, assign) NSInteger loggerCount;
@end


@implementation ARLogFilter

+ (void)initialize
{
    contextMap = @{
        @(ARLogContextNetwork) : @"Network",
        @(ARLogContextSync) : @"Sync",
        @(ARLogContextAppLifecycle) : @"App Lifecycle",
        @(ARLogContextErrors) : @"Errors"
    };
}

- (instancetype)initWithContext:(NSInteger)context
{
    self = [super init];
    if (!self) return nil;

    _context = context;
    _loggerCount = 0;

    return self;
}

- (NSString *)formatLogMessage:(DDLogMessage *)logMessage
{
    if (!self.context) return logMessage->logMsg;

    if (self.context == logMessage->logContext) {
        return [NSString stringWithFormat:@"[%@] - %@", [contextMap[@(self.context)] uppercaseString], logMessage->logMsg];
    }

    return nil;
}

- (void)didAddToLogger:(id<DDLogger>)logger
{
    self.loggerCount++;
    NSAssert(self.loggerCount <= 1, @"This logger isn't thread-safe");
}

- (void)willRemoveFromLogger:(id<DDLogger>)logger
{
    self.loggerCount--;
}

@end

#pragma mark -
#pragma mark Log housekeeping


@implementation ARLogging

+ (void)setup
{
    //Console.app + Xcode log window
    [DDLog addLogger:[DDASLLogger sharedInstance]];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];

    [self addDailyLogWithContext:ARLogContextNetwork];
    [self addDailyLogWithContext:ARLogContextSync];
    [self addDailyLogWithContext:ARLogContextAppLifecycle];
    [self addDailyLogWithContext:ARLogContextErrors];

    // TODO: File logs for the various specialized contexts
}

+ (void)addDailyLogWithContext:(ARLogContext)context
{
    return [self addFileLogWithContext:context rollingFrequency:60 * 60 * 24 maxFiles:7];
}

+ (void)addFileLogWithContext:(ARLogContext)context rollingFrequency:(NSTimeInterval)freq maxFiles:(NSUInteger)maxFiles
{
    DDFileLogger *logger = [[DDFileLogger alloc] init];
    logger.rollingFrequency = freq;
    logger.logFileManager.maximumNumberOfLogFiles = maxFiles;

    // We could reuse the formatter, but then our date formatter would
    // need to be thread-safe
    // See: https://github.com/robbiehanson/CocoaLumberjack/wiki/CustomFormatters

    [logger setLogFormatter:[[ARLogFilter alloc] initWithContext:(NSInteger)context]];
    [DDLog addLogger:logger];
}

@end
