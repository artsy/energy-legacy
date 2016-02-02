#import "AREmailSettingsViewModel.h"
#import "ARDefaults.h"


@interface AREmailSettingsViewModel ()
@property (nonatomic, strong) NSUserDefaults *defaults;
@end


@implementation AREmailSettingsViewModel

- (instancetype)initWithDefaults:(NSUserDefaults *)defaults
{
    self = [super init];
    if (!self) return nil;

    _defaults = defaults;

    return self;
}

- (NSString *)savedStringForEmailDefault:(NSString *)key
{
    return [self.defaults stringForKey:key];
}

- (NSString *)savedStringForSubjectType:(AREmailSubjectType)type
{
    switch (type) {
        case AREmailSubjectTypeOneArtwork:
            return [self.defaults objectForKey:AREmailSubject];
        case AREmailSubjectTypeMultipleArtworksMultipleArtists:
            return [self.defaults objectForKey:ARMultipleEmailSubject];
        case AREmailSubjectTypeMultipleArtworksSameArtist:
            return [self.defaults objectForKey:ARMultipleSameArtistEmailSubject];
    }
}

- (void)setEmailDefault:(NSString *)defaultName WithKey:(NSString *)key
{
    [self.defaults setObject:defaultName forKey:key];
}

- (NSString *)titleForEmailSubjectType:(AREmailSubjectType)type
{
    switch (type) {
        case AREmailSubjectTypeOneArtwork:
            return NSLocalizedString(@"One Artwork", @"Type of subject line for emails with one artwork");
        case AREmailSubjectTypeMultipleArtworksMultipleArtists:
            return NSLocalizedString(@"Multiple Artworks And Artists", @"Type of subject line for emails with multiple artworks by multiple artists");
        case AREmailSubjectTypeMultipleArtworksSameArtist:
            return NSLocalizedString(@"Multiple Artworks By Same Artist", @"Type of subject line for emails with multiple artworks by one artist");
    }
}

- (NSString *)explanatoryTextForSubjectType:(AREmailSubjectType)type
{
    switch (type) {
        case AREmailSubjectTypeOneArtwork:
            return NSLocalizedString(@"In this field, you can use the first %@ to indicate where you want the artwork title to be placed, and the second for the artist's name.", @"Explanatory text for editing the email subject for emails with one artwork");
        case AREmailSubjectTypeMultipleArtworksMultipleArtists:
            return @"";
        case AREmailSubjectTypeMultipleArtworksSameArtist:
            return NSLocalizedString(@"In this field, you can use %a to indicate where you want the artist's name to be placed.", @"Explanatory text for editing the email subject for emails with multiple artworks from one artist");
    }
}

- (void)saveSubjectLine:(NSString *)line ForType:(AREmailSubjectType)type
{
    switch (type) {
        case AREmailSubjectTypeOneArtwork:
            [self.defaults setObject:line forKey:AREmailSubject];
            break;

        case AREmailSubjectTypeMultipleArtworksMultipleArtists:
            [self.defaults setObject:line forKey:ARMultipleEmailSubject];
            break;
        case AREmailSubjectTypeMultipleArtworksSameArtist:
            [self.defaults setObject:line forKey:ARMultipleSameArtistEmailSubject];
    }
}

- (NSString *)signatureExplanatoryText
{
    return NSLocalizedString(@"This signature will be displayed together with any signature you specified in your iOS Mail settings.", @"Explanatory text for email signature field");
}

- (NSUserDefaults *)defaults
{
    return _defaults ?: [NSUserDefaults standardUserDefaults];
}

@end
