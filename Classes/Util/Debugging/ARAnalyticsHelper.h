/// An object for dealing with our model class specifics
/// With respect to analytics


@interface ARAnalyticsHelper : NSObject

/// Sets up Keys + ARAnalytics
- (void)setup;

/// Identifies the partner and adds useful super properties
- (void)storePartnerDetails:(Partner *)partner;

/// Identifies the user and adds useful super properties
- (void)storeUserDetails:(User *)user;

@end
