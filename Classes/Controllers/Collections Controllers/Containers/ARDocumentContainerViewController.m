#import <MacTypes.h>
#import "ARGridViewController+ForSubclasses.h"
#import "ARDocumentContainerViewController.h"


@implementation ARDocumentContainerViewController

- (instancetype)initWithDocumentContainer:(ARManagedObject<ARDocumentContainer> *)container
{
    if (self = [super initWithDisplayMode:ARDisplayModeDocuments]) {
        _currentDocumentContainer = container;
        _representedObject = container;

        self.title = container.name;

        [self reloadContent];
    }
    return self;
}

- (void)reloadContent
{
    self.results = [_currentDocumentContainer sortedDocumentsFetchRequestInContext:self.managedObjectContext];
    [self reloadData];
}
@end
