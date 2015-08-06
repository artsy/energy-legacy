#import "ARGridViewController.h"
#import <QuickLook/QuickLook.h>


@interface ARDocumentContainerViewController : ARGridViewController
- (instancetype)initWithDocumentContainer:(ARManagedObject<ARDocumentContainer> *)container;
@end
