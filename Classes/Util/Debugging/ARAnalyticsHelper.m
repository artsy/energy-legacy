#import "ARAnalyticsHelper.h"
#import <Analytics/SEGAnalytics.h>
#import "SubscriptionPlan.h"
#import <Keys/FolioKeys.h>
#import <Intercom/Intercom.h>
#import <ARAnalytics/IntercomProvider.h>

static NSString *currentUserEmail;


@implementation ARAnalyticsHelper

- (instancetype)init
{
    self = [super init];
    if (!self) return nil;

    [self observeNotification:ARUserUpdatedNotification globallyWithSelector:@selector(gotUser:)];
    [self observeNotification:ARPartnerUpdatedNotification globallyWithSelector:@selector(gotPartner:)];

    return self;
}

- (void)setup
{
    FolioKeys *keys = [[FolioKeys alloc] init];
    NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
    BOOL isAppStore = [bundleIdentifier isEqualToString:@"sy.art.folio"];
    BOOL isBeta = [bundleIdentifier hasPrefix:@".beta"];

    NSString *segment = isAppStore ? [keys segmentProduction] : isBeta ? [keys segmentBeta] : [keys segmentDev];

    [ARAnalytics setupWithAnalytics:@{
        ARHockeyAppBetaID : [keys hockeyAppBetaID],
        ARHockeyAppLiveID : [keys hockeyAppLiveID],
        ARIntercomAppID : [keys intercomAppID],
        ARIntercomAPIKey : [keys intercomAPIKey],
        ARSegmentioWriteKey : segment
    }];

    IntercomProvider *provider = (id)[ARAnalytics providerInstanceOfClass:IntercomProvider.class];
    provider.registerTrackedEvents = NO;

    if ([User currentUser]) {
        [self storeUserDetails:[User currentUser]];
    }

    if ([Partner currentPartner]) {
        [self storePartnerDetails:[Partner currentPartner]];
    }

    BOOL wasSyncing = [[NSUserDefaults standardUserDefaults] boolForKey:ARSyncingIsInProgress];
    if (wasSyncing) {
        [ARAnalytics event:@"sync_stalled"];
    }
}


- (void)gotUser:(NSNotification *)notification
{
    User *user = notification.object;
    [self storeUserDetails:user];
}

- (void)gotPartner:(NSNotification *)notification
{
    Partner *partner = notification.object;
    [self storePartnerDetails:partner];
}

- (void)storePartnerDetails:(Partner *)partner
{
    NSString *bundleID = [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];
    NSString *bundleDate = [[NSBundle mainBundle] infoDictionary][@"CFBundleVersion"];

    [ARAnalytics setUserProperty:@"Folio Version" toValue:bundleID];
    [ARAnalytics setUserProperty:@"Partner Name" toValue:partner.name];
    [ARAnalytics setUserProperty:@"partner_id" toValue:partner.slug];

    NSArray *plans = [SubscriptionPlan stringRepresentationOfPlans:partner.subscriptionPlans];

    [ARAnalytics addEventSuperProperties:@{
        @"app_version" : bundleID,
        @"app_release" : bundleDate,
        @"os_version" : [[UIDevice currentDevice] systemVersion] ?: @"",
        @"device_model" : [[UIDevice currentDevice] model] ?: @"",
        @"partner_id" : partner.partnerID ?: @"",
        @"partner_slug" : partner.slug ?: @"",
        @"partner_type" : partner.partnerType ?: @"",
        @"partner_subscription_plans_names" : plans ?: @"",
        @"partner_contract_type" : partner.contractType ?: @"",
        @"partner_relative_size" : partner.relativeSize ?: @"",
        @"partner_limited_access" : partner.partnerLimitedAccess ?: @0,
        @"partner_region" : partner.region ?: @"",
        @"partner_founding_partner" : partner.foundingPartner ?: @0,
        @"partner_admin_id" : partner.admin.slug ?: @"",
    }];

    [Intercom updateUserWithAttributes:@{
        @"company" : @{
            @"id" : partner.partnerID,
            @"name" : partner.name,
            @"plan" : plans ?: @"",
        }
    }];
}

- (void)storeUserDetails:(User *)user
{
    // In the case of logging in, then finding that the account has no partners
    // we want to protect against sending wrong user_ids

    if (!user || [user.email isEqualToString:currentUserEmail]) return;
    currentUserEmail = user.email;

    // We need a bit more control than ARAnalytics provides
    [[SEGAnalytics sharedAnalytics] identify:user.slug traits:@{
        @"name" : user.name ?: @"",
        @"email" : user.email ?: @"",
        @"type" : user.type ?: @""
    }];

    // Using ARAnalytics for this would mean doing the above twice
    [Intercom registerUserWithUserId:user.slug email:user.email ?: @""];

    [ARAnalytics addEventSuperProperties:@{
        @"user_email" : user.email ?: @"",
        @"user_type" : user.type ?: @"",
    }];

    [Intercom updateUserWithAttributes:@{
        @"role" : user.type ?: @"",
    }];

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateStyle = NSDateFormatterMediumStyle;

    [ARAnalytics setUserProperty:@"Last Session" toValue:[formatter stringFromDate:[NSDate date]]];
}

@end
