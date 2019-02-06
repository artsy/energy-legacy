#import <GRMustache/GRMustache.h>
#import "AREmailComposer.h"
#import "ARTheme.h"


@interface AREmailComposer ()
@property (nonatomic, strong) UIViewController<MFMailComposeViewControllerDelegate> *parentViewController;
@property (nonatomic, strong) MFMailComposeViewController *mailController;

@property (readwrite, nonatomic, strong) AREmailSettings *options;
@property (readwrite, nonatomic, copy) NSArray *documents;
@property (readwrite, nonatomic, copy) NSString *subject;
@property (readwrite, nonatomic, copy) NSArray *artworks;

@property (nonatomic, strong) NSUserDefaults *defaults;
@end


@implementation AREmailComposer

+ (void)emailArtworksFromViewController:(UIViewController<MFMailComposeViewControllerDelegate> *)hostviewController withEmailSettings:(AREmailSettings *)options
{
    AREmailComposer *composer = [[self alloc] init];
    composer.parentViewController = hostviewController;
    composer.options = options;
    composer.mailController = [[MFMailComposeViewController alloc] init];
    composer.artworks = options.artworks;
    composer.documents = options.documents;
    composer.subject = [composer subject];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {

        [composer attachDocumentsToEmail];

        dispatch_async(dispatch_get_main_queue(), ^(void) {
            [composer presentToUser];
        });
    });
}

- (NSString *)subject
{
    NSString *key = nil;
    if (self.artworks.count == 1) {
        key = AREmailSubject;
    } else if (self.artworks.count > 1 && [self artworksHaveSameArtist]) {
        key = ARMultipleSameArtistEmailSubject;
    } else {
        key = ARMultipleEmailSubject;
    }

    NSString *subjectFormat = [self.defaults objectForKey:key];
    NSInteger tokenCount = [subjectFormat componentsSeparatedByString:@"%@"].count - 1;

    if (tokenCount == 0) {
        return subjectFormat;
    }

    NSString *formatValue = nil;
    if (tokenCount == 1) {
        if (self.artworks.count == 1) {
            Artwork *artwork = self.artworks.firstObject;
            formatValue = [artwork titleForEmail];

        } else {
            if ([self artworksHaveSameArtist]) {
                formatValue = [self.artworks.firstObject artistDisplayString];

            } else {
                // This is likely the partner added it by accident
                formatValue = @"";
            }
        }

        return [NSString stringWithFormat:subjectFormat, formatValue];
    }

    NSString *formatValue2 = nil;
    if (tokenCount == 2) {
        if (self.artworks.count == 1) {
            Artwork *artwork = self.artworks.firstObject;
            formatValue = [artwork titleForEmail];
            formatValue2 = artwork.artistDisplayString;

        } else {
            // This is likely the partner added it by accident
            formatValue = @"";
            formatValue2 = @"";
        }
        return [NSString stringWithFormat:subjectFormat, formatValue, formatValue2];
    }

    // Shrug, can't predict everything.
    return subjectFormat;
}

- (void)presentToUser
{
    NSString *body = [self body];
    [self.mailController setMessageBody:body isHTML:YES];
    [self.mailController setSubject:self.subject];

    NSString *emailCC = [self.defaults objectForKey:AREmailCCEmail];
    if (emailCC && [emailCC length]) {
        [self.mailController setCcRecipients:[self generateCCEmails:emailCC]];
    }
    [self generateAnalyticEvent];

    self.mailController.mailComposeDelegate = self.parentViewController;
    [self.mailController.navigationBar setTintColor:[UIColor blackColor]];

    // White window tint causes the fields in the mailController to
    // behave strangely - this forces the tint to black and is reversed
    // in the delegate.
    [ARTheme setWindowTint:[UIColor blackColor]];
    [self.parentViewController presentViewController:self.mailController animated:YES completion:nil];
}

- (void)generateAnalyticEvent
{
    NSDictionary *properties = @{
        @"artworks" : @(self.artworks.count),
        @"price" : @(self.options.priceType > 0),
        @"using_exact_pricing" : @(self.options.priceType == AREmailSettingsPriceTypeBackend),
        @"additional_images" : @(self.options.additionalImages.count),
        @"installation_shots" : @(self.options.installationShots.count),
        @"documents" : @(self.documents.count),
        @"info" : @(self.options.showSupplementaryInformation),
        @"inventory" : @(self.options.showInventoryID)
    };

    [ARAnalytics event:AREmailComposeEvent withProperties:properties];
    [ARAnalytics incrementUserProperty:@"Total Emails Sent" byInt:1];
}

- (NSString *)body
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"email_artwork_template" ofType:@"html"];

    NSString *signature = [self.defaults objectForKey:AREmailSignature];
    NSString *greeting = [self.defaults objectForKey:AREmailGreeting];
    NSMutableArray *artworkDicts = [NSMutableArray array];

    signature = [signature stringByReplacingOccurrencesOfString:@"\n" withString:@"<br/>"];
    greeting = [greeting stringByReplacingOccurrencesOfString:@"\n" withString:@"<br/>"];

    if (self.artworks.count > 1) {
        greeting = [greeting stringByReplacingOccurrencesOfString:@" artwork " withString:@" artworks "];
    }

    NSArray *additionalImages = [self generateAdditionalImageURLs];

    for (Artwork *artwork in self.artworks) {
        NSString *artworkThumbnailURL = [[artwork.mainImage imageURLWithFormatName:ARFeedImageSizeLargeKey] absoluteString];

        if (artworkThumbnailURL) {
            NSDictionary *artworkDict = @{
                @"artwork" : artwork,
                @"additionalImages" : additionalImages,
                @"thumbnailImagePath" : artworkThumbnailURL,
            };
            [artworkDicts addObject:artworkDict];
        }
    }

    NSArray *installationShowAddresses = [self.options.installationShots map:^id(Image *image) {
        return [[image imageURLWithFormatName:ARFeedImageSizeLargeKey] absoluteString];
    }];

    NSDictionary *inputs = @{
        AREmailSignature : signature ?: @"",
        AREmailGreeting : greeting ?: @"",
        @"artworks" : artworkDicts,
        @"options" : self.options,
        @"installation_shots" : installationShowAddresses ?: @[],
        @"partner" : [Partner currentPartnerIDInDefaults:self.defaults],
    };

    GRMustacheConfiguration *configuration = [GRMustacheConfiguration defaultConfiguration];
    configuration.baseContext = [configuration.baseContext contextWithUnsafeKeyAccess];

    NSError *error = nil;
    GRMustacheTemplate *template = [GRMustacheTemplate templateFromContentsOfFile:filePath error:&error];
    NSString *body = [template renderObject:inputs error:&error];

    if (error) {
        [ARAnalytics event:@" Email Composer Error in Mustache" withProperties:@{ @"error" : error.localizedDescription }];
        return @"";
    }
    return body;
}

#pragma mark -
#pragma mark Handle Artworks

- (void)setArtworks:(NSArray *)artworks
{
    NSComparisonResult (^comparator)(id, id) = ^(Artwork *left, Artwork *right) {
        return ([left.artistDisplayString compare:right.artistDisplayString]);
    };

    _artworks = [artworks sortedArrayUsingComparator:comparator];
}

- (BOOL)artworksHaveSameArtist
{
    if (self.artworks.count == 0) return NO;

    // Any random artist is fine
    Artist *firstArtist = [self.artworks.firstObject artists].anyObject;

    // Look through all artworks comparing their artists to
    // the first one, if it's different, then return NO.
    for (Artwork *anotherArtistArtwork in self.artworks) {
        for (Artist *artist in anotherArtistArtwork.artists) {
            if (artist.slug != firstArtist.slug) {
                return NO;
            }
        }
    }
    return YES;
}

#pragma mark -
#pragma mark Additional Images

- (NSArray *)generateAdditionalImageURLs
{
    NSArray *images = [self.options.additionalImages map:^id(Image *image) {
        return [image imageURLWithFormatName:ARFeedImageSizeLargeKey];
    }];

    return images ?: @[];
}

- (void)attachDocumentsToEmail
{
    [self.documents each:^(Document *document) {
        @try {
            NSData *fileData = [NSData dataWithContentsOfFile:document.filePath];
            [self.mailController addAttachmentData:fileData mimeType:document.mimeType fileName:document.emailableFileName];
        } @catch (NSException *exception) {
            NSLog(@"Could not add the file %@ for %@", document.filename, document.artist.name);
            NSLog(@"Error: %@", exception);
        }
    }];
}

- (NSArray *)generateCCEmails:(NSString *)emailCCString
{
    return [emailCCString componentsSeparatedByString:@","];
}

- (NSUserDefaults *)defaults
{
    return _defaults ?: [NSUserDefaults standardUserDefaults];
}

@end
