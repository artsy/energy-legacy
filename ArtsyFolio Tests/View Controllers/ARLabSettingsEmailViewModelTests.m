#import "ARLabSettingsEmailViewModel.h"
#import "ARDefaults.h"


SpecBegin(ARLabSettingsEmailViewModel);

__block ARLabSettingsEmailViewModel *subject;
__block ForgeriesUserDefaults *mockDefaults;


describe(@"working with defaults", ^{
   it(@"retrieves email defaults", ^{
       mockDefaults = [ForgeriesUserDefaults defaults:@{ AREmailCCEmail : @"email@gallery.com"}];
       subject = [[ARLabSettingsEmailViewModel alloc] initWithDefaults:(id)mockDefaults];
       
       expect([subject savedStringForEmailDefault:AREmailCCEmail]).to.equal(@"email@gallery.com");
   });
    
    it(@"sets email defaults", ^{
        mockDefaults = [ForgeriesUserDefaults defaults:@{ AREmailGreeting : @"Hello!"}];
        subject = [[ARLabSettingsEmailViewModel alloc] initWithDefaults:(id)mockDefaults];
        
        [subject setEmailDefault:@"Hallo!" WithKey:AREmailGreeting];
        
        expect([mockDefaults stringForKey:AREmailGreeting]).to.equal(@"Hallo!");
    });
});

describe(@"email subject types", ^{
    it(@"returns the right title for each subject type", ^{
        subject = [[ARLabSettingsEmailViewModel alloc] init];
        expect([subject titleForEmailSubjectType:AREmailSubjectTypeOneArtwork]).to.equal(@"One Artwork");
        expect([subject titleForEmailSubjectType:AREmailSubjectTypeMultipleArtworksMultipleArtists]).to.equal(@"Multiple Artworks And Artists");
        expect([subject titleForEmailSubjectType:AREmailSubjectTypeMultipleArtworksSameArtist]).to.equal(@"Multiple Artworks By Same Artist");
    });
});

SpecEnd
