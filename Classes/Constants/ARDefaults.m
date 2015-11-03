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
NSString *const ARShowAvailableOnly = @"ARShowAvailableOnly";
NSString *const ARShowConfidentialNotes = @"ARShowConfidentialNotes";

// Lab settings; easier to do this for now than use the NOT versions of existing ones and have to retroactively change things later
NSString *const ARHidePrices = @"ARHidePrices";
NSString *const ARHideSoldWorksPrices = @"ARHideSoldWorksPrices";
NSString *const ARHideNotForSaleWorks = @"ARHideNotForSaleWorks";
NSString *const ARHideArtworkEditButton = @"ARHideArtworkEditButton";
NSString *const ARPresentationMode = @"ARPresentationMode";

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

+ (void)registerDefaults
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *defaultDefaults = @{
        ARHideUnpublishedWorks : @NO,
        ARShowAvailableOnly : @NO,
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

    void (^setPartnerSettingsBlock)(NSNotification *);
    setPartnerSettingsBlock = ^(NSNotification *notification) {

        Partner *partner = [Partner currentPartner];
        [defaults setObject:partner.slug forKey:ARPartnerID];
        [defaults setObject:partner.email forKey:AREmailCCEmail];
        [defaults setObject:partner.partnerLimitedAccess forKey:ARLimitedAccess];
        [defaults synchronize];

        [[NSNotificationCenter defaultCenter] removeObserver:self name:ARPartnerUpdatedNotification object:nil];
    };

    if ([Partner currentPartner]) {
        setPartnerSettingsBlock(nil);

    } else {
        [[NSNotificationCenter defaultCenter] addObserverForName:ARPartnerUpdatedNotification object:nil
                                                           queue:[NSOperationQueue mainQueue]
                                                      usingBlock:setPartnerSettingsBlock];
    }
}

@end
