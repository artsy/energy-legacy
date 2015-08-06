#import <QuickLook/QuickLook.h>

/// The ARDocumentPreviewViewController cannot be a subclass of ARBaseViewController.
/// :(
/// As such we have to unDRY a bunch of the UI layer from the BaseVC and move it into here.

/// Other than that the DocumentPreviewVC is a custom quicklook preview view controller
/// whose job is to mangle the Apple quicklook preview view into a format that is acceptable
/// to our design senses. Warning, not a class to be trifled with.


@interface ARDocumentPreviewViewController : QLPreviewController <QLPreviewControllerDelegate, QLPreviewControllerDataSource>
- (instancetype)initWithDocument:(Document *)document;
@end
