#import "ARSyncStatusViewModel.h"


@interface ARLabSettingsNavigationController : UINavigationController

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSUserDefaults *defaults;
@property (nonatomic, strong) ARSync *sync;

@end
