#import "ARDefaults.h"

SpecBegin(ARDefaults);

__block NSUserDefaults *defaults;
__block NSManagedObjectContext *context;

extern void sendUpdateNotification(Partner *partner);

beforeEach(^{
    defaults = [[NSUserDefaults alloc] initWithSuiteName:[[NSUUID UUID] UUIDString]];
    context = [CoreDataManager stubbedManagedObjectContext];
});

it(@"registers defaults", ^{
    [ARDefaults registerDefaults:defaults context:context];

    expect([defaults objectForKey:ARPresentationModeOn]).to.equal(@NO);
    expect([defaults objectForKey:AREmailSubject]).to.equal(@"More information about “%@“ by %@");
});

it(@"handles a partner being updated", ^{
    [ARDefaults registerDefaults:defaults context:context];

    expect([defaults objectForKey:ARPartnerID]).to.beNil();

    Partner *partner = [Partner modelFromJSON:@{
        ARFeedIDKey : @"testing_partner_id",
        ARFeedHasLimitedPartnerToolAccessKey : @YES,
        ARFeedEmailKey : @"new@email.com",
    } inContext:context];

    sendUpdateNotification(partner);

    expect([defaults stringForKey:ARPartnerID]).to.equal(@"testing_partner_id");
});

it(@"handles a partner details being updated", ^{
    [ARDefaults registerDefaults:defaults context:context];

    expect([defaults objectForKey:ARPartnerID]).to.beNil();

    Partner *partner = [Partner modelFromJSON:@{
        ARFeedIDKey : @"testing_partner_id",
        ARFeedHasLimitedPartnerToolAccessKey : @YES,
        ARFeedEmailKey : @"new@email.com",
    } inContext:context];

    sendUpdateNotification(partner);
    expect([defaults objectForKey:ARPartnerID]).to.equal(@"testing_partner_id");

    Partner *partner2 = [Partner modelFromJSON:@{
        ARFeedIDKey : @"new_testing_partner_id",
        ARFeedHasLimitedPartnerToolAccessKey : @NO,
        ARFeedEmailKey : @"new@email.com",
    } inContext:context];

    sendUpdateNotification(partner2);
    expect([defaults objectForKey:ARPartnerID]).to.equal(@"new_testing_partner_id");
});

it(@"does not overwrite a partner's email if it was set", ^{
    [ARDefaults registerDefaults:defaults context:context];

    Partner *partner = [Partner modelFromJSON:@{
        ARFeedIDKey : @"testing_partner_id",
        ARFeedHasLimitedPartnerToolAccessKey : @YES,
        ARFeedEmailKey : @"hello@email.com",
    } inContext:context];

    sendUpdateNotification(partner);
    expect([defaults objectForKey:AREmailCCEmail]).to.equal(@"hello@email.com");

    [defaults setObject:@"this_email_shouldnt_change@email.com" forKey:AREmailCCEmail];

    Partner *partner2 = [Partner modelFromJSON:@{
        ARFeedIDKey : @"new_testing_partner_id",
        ARFeedHasLimitedPartnerToolAccessKey : @YES,
        ARFeedEmailKey : @"new@email.com",
    } inContext:context];

    sendUpdateNotification(partner2);
    expect([defaults objectForKey:AREmailCCEmail]).to.equal(@"this_email_shouldnt_change@email.com");

    // And calling register again won't change it
    [ARDefaults registerDefaults:defaults context:context];
    expect([defaults objectForKey:AREmailCCEmail]).to.equal(@"this_email_shouldnt_change@email.com");
});


SpecEnd

    void
    sendUpdateNotification(Partner *partner)
{
    [[NSNotificationCenter defaultCenter] postNotificationName:ARPartnerUpdatedNotification object:partner userInfo:@{ARPartnerKey : partner}];
}
