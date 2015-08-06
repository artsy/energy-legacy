#import "ARGridView.h"
#import "ARGridViewCell.h"
#import "ARModelFactory.h"
#import "ARSelectionHandler.h"
#import "ARSimpleImageGridViewDataSource.h"
#import "ARImageGridViewItem.h"
#import "ARHighlightableImageView.h"


@interface ARGridView (Private) <UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) UICollectionView *gridView;
@property (nonatomic, strong) ARSelectionHandler *selectionHandler;
@property (readwrite, nonatomic, strong) ARGridViewDataSource *dataSource;

- (void)setImageAsyncAtPath:(NSString *)imageAddress backupURL:(NSURL *)backupURL forGridCell:(ARGridViewCell *)cell asButton:(BOOL)asButton;

@end


@interface ARGridViewCell (Private)
@property (assign, nonatomic, readonly) BOOL isVisuallySelected;
@property (strong, nonatomic, readonly) ARHighlightableImageView *imageView;
@end

SpecBegin(ARGridView);

__block ARGridView *sut;
__block ARSelectionHandler *selectionHandler;
__block ARSimpleImageGridViewDataSource *dataSource;

before(^{
    [ARTestContext setContext:ARTestContextDeviceTypePad];

    selectionHandler = [[ARSelectionHandler alloc] init];

    ARImageGridViewItem *item = [[ARImageGridViewItem alloc] init];
    ARImageGridViewItem *item2 = [[ARImageGridViewItem alloc] init];
    dataSource = [[ARSimpleImageGridViewDataSource alloc] init];
    dataSource.imageItems = @[item, item2];

    sut = [[ARGridView alloc] initWithDisplayMode:ARDisplayModeAllAlbums];
    sut.frame = CGRectMake(0, 0, 1024, 1024);
    sut.dataSource = dataSource;

    sut.selectionHandler = selectionHandler;
    [sut setResults:nil];
});

after(^{
    [ARTestContext endContext];
});

describe(@"in selection mode", ^{

    it(@"should look right", ^{
        expect(sut).to.haveValidSnapshot();
    });

    it(@"should turn off visual state when stopping multi selection ", ^{
        [sut drawViewHierarchyInRect:sut.bounds afterScreenUpdates:YES];

        ARGridViewCell *cell = (id)sut.gridView.visibleCells.firstObject;
        expect(cell.isVisuallySelected).to.equal(NO);

        [cell setVisuallySelected:YES animated:NO];
        expect(cell.isVisuallySelected).to.equal(YES);

        [sut setIsSelectable:NO animated:NO];
        expect(cell.isVisuallySelected).to.equal(NO);
    });

    // I'm planning to re-work the selection handling of grid views to be less reliant
    // on singletons one of these days, so for now these can be pending.

    pending(@"should select an item", ^{
    });

    pending(@"should deselect an item", ^{
    });

    pending(@"should select all items", ^{
    });

    pending(@"should deselect all items", ^{
    });

    it(@"triggers a async download of an image if the local one can't be turned into an image ", ^{
        NSString *badPath = @"file://asdasdasd";
        NSURL *imageURL = [[NSBundle bundleForClass:self.class] URLForResource:@"example-image" withExtension:@"png"];
        
        ARGridViewCell *cell = [[ARGridViewCell alloc] initWithFrame:CGRectMake(0, 0, 240, 240)];

        cell.imagePath = badPath;
        [sut setImageAsyncAtPath:badPath backupURL:imageURL forGridCell:cell asButton:NO];

        expect(cell.imageView.image).toNot.beNil();
    });
});

SpecEnd
