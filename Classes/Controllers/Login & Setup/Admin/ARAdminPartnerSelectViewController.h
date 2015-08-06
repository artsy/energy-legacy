#import "ARPartnerSelectViewController.h"


@interface ARAdminPartnerSelectViewController : UIViewController <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>

- (void)searchForQuery:(NSString *)searchText;

// Reuse the callback type from ARPartnerSelectVC
@property (strong) partnerCallbackBlock callback;

@end
