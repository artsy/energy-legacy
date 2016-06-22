NSString *const ARAppName = @"ArtsyFolio";

NSString *const ARLastSyncDate = @"ARLastFeedUpdate";

// Will be preserved across database resets
NSString *const AROAuthToken = @"AROAuthToken";
NSString *const AROAuthTokenExpiryDate = @"AROAuthTokenExpiryDate";
NSString *const ARUserEmailAddress = @"ARUserEmailAddress";
NSString *const ARPartnerID = @"ARPartnerID";
NSString *const ARAppSyncVersion = @"ARAppVersion";
NSString *const ARLimitedAccess = @"ARLimitedAccess";

NSString *const ARHideUnpublishedWorks = @"ARHideUnpublishedWorks";
NSString *const ARShowPrices = @"ARShowPrices";
NSString *const ARShowAvailability = @"ARShowAvailability";
NSString *const ARShowConfidentialNotes = @"ARShowConfidentialNotes";

NSString *const ARPresentationModeOn = @"ARPresentationModeOn";
NSString *const ARHideAllPrices = @"ARHideAllPrices";
NSString *const ARHideConfidentialNotes = @"ARHideConfidentialNotes";
NSString *const ARHidePricesForSoldWorks = @"ARHidePricesForSoldWorks";
NSString *const ARHideWorksNotForSale = @"ARHideWorksNotForSale";
NSString *const ARHideArtworkEditButton = @"ARHideArtworkEditButton";

NSString *const ARHasInitializedPresentationMode = @"ARHasInitializedPresentationMode";

NSString *const AREmailGreeting = @"AREmailGreeting";
NSString *const AREmailSignature = @"AREmailSignature";
NSString *const AREmailSubject = @"AREmailSubject";
NSString *const ARMultipleEmailSubject = @"ARMultipleEmailSubject";
NSString *const ARMultipleSameArtistEmailSubject = @"ARMultipleSameArtistEmailSubject";
NSString *const AREmailCCEmail = @"AREmailCCEmail";

NSString *const ARStartedFirstSync = @"ARStartedFirstSync";
NSString *const ARFinishedFirstSync = @"ARFinishedFirstSync";
NSString *const ARSyncingIsInProgress = @"ARSyncingIsInProgress";
NSString *const ARRecommendSync = @"ARRecommendSync";


@implementation ARDefaults

+ (void)registerDefaults:(NSUserDefaults *)defaults context:(NSManagedObjectContext *)context
{
    NSDictionary *defaultDefaults = @{
        ARPresentationModeOn : @NO,
        ARHasInitializedPresentationMode : @NO,

        ARShowAvailability : @YES,
        ARShowPrices : @NO,
        ARShowConfidentialNotes : @NO,
        ARStartedFirstSync : @NO,
        ARFinishedFirstSync : @NO,
        AREmailSubject : @"More information about %@ by %@",
        ARMultipleEmailSubject : @"More information about the artworks we discussed",
        ARMultipleSameArtistEmailSubject : @"More information about %@'s artworks",
        AREmailGreeting : @"Here is more information about the artwork we discussed."
    };

    [defaults registerDefaults:defaultDefaults];

    /// When a partner has been updated we'll need new details
    void (^setPartnerSettingsBlock)(Partner *);
    setPartnerSettingsBlock = ^(Partner *partner) {

        [defaults setObject:partner.slug forKey:ARPartnerID];
        [defaults setObject:partner.partnerLimitedAccess forKey:ARLimitedAccess];
        [defaults synchronize];

        /// Set a registered fallback for the email, allowing any custom setting to override it
        [defaults registerDefaults:@{ AREmailCCEmail: partner.email }];
    };

    /// When we get a notification, so map it out to the partner
    void (^gotPartnerNotificationsBlock)(NSNotification *);
    gotPartnerNotificationsBlock = ^(NSNotification *notification) {

        Partner *partner = [notification userInfo][ARPartnerKey];
        setPartnerSettingsBlock(partner);
    };

    Partner *partner = [Partner currentPartnerInContext:context];
    if (partner) {
        setPartnerSettingsBlock(partner);

    } else {
        [[NSNotificationCenter defaultCenter] addObserverForName:ARPartnerUpdatedNotification object:nil
                                                           queue:[NSOperationQueue mainQueue]
                                                      usingBlock:gotPartnerNotificationsBlock];
    }
}

@end
