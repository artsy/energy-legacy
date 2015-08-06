#import "ARDocumentPreviewViewController.h"


@interface ARDocumentPreviewViewController ()
@property (readwrite, nonatomic, strong) id previewObject;
@end

SpecBegin(ARDocumentPreviewViewController);

__block ARDocumentPreviewViewController *sut;
__block NSManagedObjectContext *context;

itHasSnapshotsForViewControllerWithDevicesAndColorStates(@"default visuals", ^{
    context = [CoreDataManager stubbedManagedObjectContext];

    ArtistDocument *document = [ArtistDocument objectInContext:context];
    document.filename = @"File Name";
    
    sut = [[ARDocumentPreviewViewController alloc] initWithDocument:document];
    
    NSURL *imagePath = [[NSBundle bundleForClass:self.class] URLForResource:@"example-image" withExtension:@"png"];
    sut.previewObject = imagePath;
    
    return sut;
});

SpecEnd
