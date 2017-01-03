#import "ARModernDocumentPreviewViewController.h"


@interface ARModernDocumentPreviewViewController () <QLPreviewControllerDataSource>
@end

SpecBegin(ARDocumentPreviewViewController);

__block ARModernDocumentPreviewViewController *sut;
__block NSManagedObjectContext *context;
__block QLPreviewController *controller;

before(^{
    controller = [[QLPreviewController alloc] init];
    context = [CoreDataManager stubbedManagedObjectContext];
});

it(@"conforms to QL quicklook", ^{
    ArtistDocument *document = [ArtistDocument objectInContext:context];
    document.filename = @"File Name";

    sut = [[ARModernDocumentPreviewViewController alloc] initWithDocumentSet:@[ document ] index:0];

    expect([sut previewController:controller previewItemAtIndex:0]).to.conformTo(@protocol(QLPreviewItem));
    expect([sut previewController:controller previewItemAtIndex:0]).to.beKindOf(ArtistDocument.class);
});

it(@"handles multiple documents", ^{
    ArtistDocument *document = [ArtistDocument objectInContext:context];
    document.filename = @"File Name";
    ArtistDocument *document2 = [ArtistDocument objectInContext:context];
    document.filename = @"File Name";

    sut = [[ARModernDocumentPreviewViewController alloc] initWithDocumentSet:@[ document, document2 ] index:0];

    expect([sut previewController:controller previewItemAtIndex:0]).to.equal(document);
    expect([sut previewController:controller previewItemAtIndex:1]).to.equal(document2);

    expect([sut numberOfPreviewItemsInPreviewController:controller]).to.equal(2);
});

SpecEnd
