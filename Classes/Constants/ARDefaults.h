extern NSString *const ARAppName;
extern NSString *const ARLastSyncDate;

// Will be preserved across database resets
extern NSString *const AROAuthToken;
extern NSString *const AROAuthTokenExpiryDate;
extern NSString *const ARUserEmailAddress;
extern NSString *const ARPartnerID;
extern NSString *const ARAppSyncVersion;
extern NSString *const ARLimitedAccess;

extern NSString *const ARHideUnpublishedWorks;
extern NSString *const ARShowPrices;
extern NSString *const ARShowAvailability;
extern NSString *const ARShowConfidentialNotes;

extern NSString *const ARPresentationModeOn;
extern NSString *const ARHideAllPrices;
extern NSString *const ARHideConfidentialNotes;
extern NSString *const ARHidePricesForSoldWorks;
extern NSString *const ARHideWorksNotForSale;
extern NSString *const ARHideArtworkEditButton;
extern NSString *const ARHideArtworkAvailability;

extern NSString *const ARHasInitializedPresentationMode;

extern NSString *const AREmailGreeting;
extern NSString *const AREmailSignature;
extern NSString *const AREmailCCEmail;

extern NSString *const AREmailSubject;
extern NSString *const ARMultipleEmailSubject;
extern NSString *const ARMultipleSameArtistEmailSubject;

extern NSString *const ARStartedFirstSync;
extern NSString *const ARFinishedFirstSync;
extern NSString *const ARSyncingIsInProgress;
extern NSString *const ARRecommendSync;


@interface ARDefaults : NSObject
+ (void)registerDefaults:(NSUserDefaults *)defaults context:(NSManagedObjectContext *)context;
@end
