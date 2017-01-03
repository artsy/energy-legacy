#import <QuickLook/QuickLook.h>
#import "ARModernDocumentPreviewViewController.h"
#import "UIViewController+SimpleChildren.h"


@interface ARModernDocumentPreviewViewController () <QLPreviewControllerDataSource>

@property (readonly, nonatomic, copy) NSArray<Document *> *documents;
@property (readwrite, nonatomic, assign) NSInteger index;
@end


@implementation ARModernDocumentPreviewViewController


- (instancetype)initWithDocumentSet:(NSArray<Document *> *)documents index:(NSInteger)index
{
    self = [super init];
    if (!self) return nil;

    _documents = documents;
    _index = index;

    NSString *source = [self.documents.firstObject isKindOfClass:[ArtistDocument class]] ? ARArtistPage : ARShowPage;
    [ARAnalytics event:ARDocumentViewEvent withProperties:@{ @"from" : source }];

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor artsyBackgroundColor];

    QLPreviewController *controller = [[QLPreviewController alloc] init];
    controller.dataSource = self;
    controller.currentPreviewItemIndex = self.index;

    [self ar_addModernChildViewController:controller];
    [controller.view alignToView:self.view];
}

- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller
{
    return self.documents.count;
}

- (id<QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index
{
    return self.documents[index];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}


@end
