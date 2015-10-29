#import <ARAnalytics/ARAnalyticalProvider.h>

/// A stubbed provider created in ARAnalytics to
/// provide easy feedback on what events are getting sent
/// down the pipeline.


@interface ARStubbedProvider : ARAnalyticalProvider

/// Sets up ARAnalytics to only have this as it's provider
/// this means in tests you can use these values
/// to see what has happened in the code.

+ (ARStubbedProvider *)setupAnalyticsWithStubbedProvider;

@property (readonly, nonatomic, copy) NSString *lastProviderIdentifier;

/// The last event that came through [ARAnalyics event: ...]
@property (readonly, nonatomic, copy) NSString *lastEventName;

/// A dictionary that may have come through with the [ARAnalytics event: ...]
@property (readonly, nonatomic, copy) NSDictionary *lastEventProperties;

@property (readonly, nonatomic, copy) NSString *lastUserPropertyValue;
@property (readonly, nonatomic, copy) NSString *lastUserPropertyKey;
@property (readonly, nonatomic, assign) NSInteger lastUserPropertyCount;

@property (readonly, nonatomic, copy) NSString *email;
@property (readonly, nonatomic, copy) NSString *identifier;

@property (readonly, nonatomic, strong) NSError *lastError;
@property (readonly, nonatomic, copy) NSString *lastErrorMessage;

@property (readonly, nonatomic, strong) UINavigationController *lastMonitoredNavigationController;

@property (readonly, nonatomic, copy) NSString *lastRemoteLog;

@end
