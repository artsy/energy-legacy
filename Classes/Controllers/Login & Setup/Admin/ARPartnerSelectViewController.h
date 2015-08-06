#import <UIKit/UIKit.h>

typedef void (^partnerCallbackBlock)(NSDictionary *);

/// The ARPartnerSelectViewController is a view that pops up if you
/// are associated with more than one Partner. It lets you choose from
/// a list of partners for the sync.


@interface ARPartnerSelectViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong) partnerCallbackBlock callback;
@property (strong) NSArray *partners;
@end
