//getting around Obj-C's lack of protected methods
#import "ARGridViewController.h"

// This will expose the instance vars for the ARMainViewController to it's subclass
@interface ARGridViewController () {
   @public

    ARManagedObject *_representedObject;
    NSObject<ARDocumentContainer> *_currentDocumentContainer;
    ARManagedObject<ARArtworkContainer> *_currentArtworkContainer;
}

- (void)reloadContent;

- (void)startSelecting;

- (void)endSelecting;

- (void)addActionButton;

- (void)emailArtworks:(id)sender;

- (NSDictionary *)dictionaryForAnalytics;

@end
