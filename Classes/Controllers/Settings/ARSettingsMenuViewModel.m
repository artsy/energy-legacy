#import "ARSettingsMenuViewModel.h"
#import "ARAppDelegate.h"
#import "AROptions.h"
#import "Partner+InventoryHelpers.h"


@interface ARSettingsMenuViewModel ()
@property (nonatomic, strong) NSUserDefaults *defaults;
@property (nonatomic, strong) ARAppDelegate *appDelegate;
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, assign) BOOL didInitializePresentationMode;
@end


@implementation ARSettingsMenuViewModel

- (instancetype)initWithDefaults:(NSUserDefaults *)defaults context:(NSManagedObjectContext *)context appDelegate:(ARAppDelegate *)appDelegate
{
    self = [super init];
    if (!self) return nil;

    _defaults = defaults;
    _appDelegate = appDelegate;
    _context = context;

    return self;
}

- (BOOL)shouldShowSyncNotification
{
    return [self.defaults boolForKey:ARRecommendSync];
}

- (void)initializePresentationMode
{
    if ([self.defaults boolForKey:ARHasInitializedPresentationMode]) return;

    Partner *partner = [Partner currentPartnerInContext:self.context];
    NSMutableArray *relevantPresentationModeSettings = [NSMutableArray arrayWithArray:@[ ARHasInitializedPresentationMode, ARHideConfidentialNotes, ARHideArtworkEditButton, ARHideArtworkAvailability ]];

    if ([partner hasWorksWithPrice]) {
        [relevantPresentationModeSettings addObject:ARHideAllPrices];
    }

    if ([partner hasSoldWorksWithPrices]) {
        [relevantPresentationModeSettings addObject:ARHidePricesForSoldWorks];
    }

    if ([partner hasUnpublishedWorks] && [partner hasPublishedWorks]) {
        [relevantPresentationModeSettings addObject:ARHideUnpublishedWorks];
    }

    if ([partner hasNotForSaleWorks] && [partner hasForSaleWorks]) {
        [relevantPresentationModeSettings addObject:ARHideWorksNotForSale];
    }

    [relevantPresentationModeSettings each:^(NSString *settingKey) {
        [self.defaults setBool:YES forKey:settingKey];
    }];
}

- (NSString *)buttonTitleForSettingsSection:(ARSettingsSection)section
{
    switch (section) {
        case ARSettingsSectionSync:
            return NSLocalizedString(@"Sync Content", @"Title for sync settings button");
        case ARSettingsSectionPresentationMode:
            return NSLocalizedString(@"Presentation Mode", @"Title for presentation mode toggle button");
        case ARSettingsSectionEditPresentationMode:
            return NSLocalizedString(@"Presentation Mode Settings", @"Title for edit presentation mode settings button");
        case ARSettingsSectionBackground:
            return NSLocalizedString(@"Background", @"Title for background settings button");
        case ARSettingsSectionEmail:
            return NSLocalizedString(@"Email", @"Title for email settings button");
        case ARSettingsSectionSupport:
            return NSLocalizedString(@"Support", @"Title for support button");
        case ARSettingsSectionLogout:
            return NSLocalizedString(@"Logout", @"Title for logout button");
    }
}

- (NSString *)presentationModeExplanatoryText
{
    if (self.shouldEnablePresentationMode) {
        return NSLocalizedString(@"Presentation Mode hides sensitive information when showing artworks to clients.", @"Explanatory text for presentation mode when it's enabled");
    } else {
        return NSLocalizedString(@"Presentation Mode hides sensitive information when showing artworks to clients. To use presentation mode, turn on one or more options in Presentation Mode Settings.", @"Explanatory text for presentation mode when it's disabled");
    }
}

- (BOOL)presentationModeOn
{
    return [self.defaults boolForKey:ARPresentationModeOn];
}

- (void)togglePresentationMode
{
    BOOL on = ![self presentationModeOn];
    [self.defaults setBool:on forKey:ARPresentationModeOn];
}

- (void)disablePresentationMode
{
    [self.defaults setObject:nil forKey:ARPresentationModeOn];
}

- (BOOL)shouldEnablePresentationMode
{
    return [self.defaults boolForKey:ARHideAllPrices] || [self.defaults boolForKey:ARHidePricesForSoldWorks] || [self.defaults boolForKey:ARHideUnpublishedWorks] || [self.defaults boolForKey:ARHideWorksNotForSale] || [self.defaults boolForKey:ARHideConfidentialNotes] || [self.defaults boolForKey:ARHideArtworkEditButton] || [self.defaults boolForKey:ARShowAvailability];
}

- (UIImage *)settingsButtonImage
{
    return [[UIImage imageNamed:@"settings_btn_whiteborder"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

- (void)logout
{
    [self.appDelegate startLogout];
    [[NSNotificationCenter defaultCenter] postNotificationName:ARDismissAllPopoversNotification object:nil];
}

#pragma mark -
#pragma mark dependency injection

- (NSUserDefaults *)defaults
{
    return _defaults ?: [NSUserDefaults standardUserDefaults];
}

- (ARAppDelegate *)appDelegate
{
    return _appDelegate ?: (ARAppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (NSManagedObjectContext *)context
{
    return _context ?: [CoreDataManager mainManagedObjectContext];
}

@end
