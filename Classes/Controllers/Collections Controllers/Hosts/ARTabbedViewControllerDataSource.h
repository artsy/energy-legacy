#import "ARTabContentView.h"

@class ARSelectionHandler;

/// Generates the data for the Tab controller for models that host collections of
/// other models


@interface ARTabbedViewControllerDataSource : NSObject <ARTabViewDataSource>

- (instancetype)initWithRepresentedObject:(id)representedObject managedObjectContext:(NSManagedObjectContext *)context selectionHandler:(ARSelectionHandler *)selectionHandler;

@property (readonly, nonatomic, copy) NSArray *potentialTitles;

@end
