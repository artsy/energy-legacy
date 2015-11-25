#import "ARLabSettingsEmailViewModel.h"
#import "ARDefaults.h"

@interface ARLabSettingsEmailViewModel()
@property (nonatomic, strong) NSUserDefaults *defaults;
@end

@implementation ARLabSettingsEmailViewModel

- (NSString *)savedStringForEmailDefault:(NSString *)key
{
    return [self.defaults stringForKey:key];
}

- (void)setEmailDefault:(NSString *)string WithKey:(NSString *)key
{
    [self.defaults setObject:string forKey:key];
}

- (NSString *)signatureExplanatoryText
{
    return NSLocalizedString(@"This signature will be displayed together with any signature you specified in your iOS mail settings.", @"Explanatory text for email signature field");
}

- (NSUserDefaults *)defaults
{
    return _defaults ?: [NSUserDefaults standardUserDefaults];
}

@end
