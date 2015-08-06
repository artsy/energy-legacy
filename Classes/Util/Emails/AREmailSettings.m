#import "AREmailSettings.h"

// Just a container for properties really.


@implementation AREmailSettings

- (BOOL)showBackendPrice
{
    return self.priceType == AREmailSettingsPriceTypeBackend;
}

- (BOOL)showPrice
{
    return self.priceType > AREmailSettingsPriceTypeNoPrice;
}

@end
