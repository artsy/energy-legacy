#import "ARRouter.h"
#import "ARAppTestDelegate+Tests.h"
#import "ARDefaults.h"
#import "ARTheme.h"
#import "AROptions.h"
#import "AROHHTTPNoStubAssertionBot.h"
#import <Forgeries/ForgeriesUserDefaults+Mocks.h>

static OCMockObject *defaultsClassMock;


@implementation ARAppTestSetup

+ (void)beforeEach
{
    defaultsClassMock = [ForgeriesUserDefaults replaceStandardUserDefaultsWith:@{
        AROAuthToken : @"Legit OAuth Token",
        AROAuthTokenExpiryDate : [NSDate dateWithTimeIntervalSinceNow:9999],
        ARUserEmailAddress : @"dev@artsymail.com",
        ARPartnerID : @"testing-partner",
        ARHideUnpublishedWorks : @NO,
        ARShowPrices : @NO,
        ARShowAvailability : @NO,
        ARHideWorksNotForSale : @NO,
        ARShowConfidentialNotes : @NO,
        AREmailGreeting : @"Email greeting",
        AREmailSignature : @"Email signature",
        AREmailSubject : @"Email Subject",
        ARMultipleEmailSubject : @"Multiple Email Subject",
        ARMultipleSameArtistEmailSubject : @"Same Artist Multiple Email subject",
        AREmailCCEmail : @"CC Email",
        ARStartedFirstSync : @YES,
        ARFinishedFirstSync : @YES,
        AROptionsUseWhiteFolio : @NO,
    }];

    [ARRouter setup];

    [ARTheme setupWithWhiteFolio:NO];
    [AROHHTTPNoStubAssertionBot assertOnFailForGlobalOHHTTPStubs];
}

@end
