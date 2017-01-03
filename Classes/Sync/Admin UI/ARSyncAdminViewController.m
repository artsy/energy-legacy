#import <AFNetworking/AFJSONRequestOperation.h>
#import <DRBOperationTree/DRBOperationTree.h>
#import "ARSyncAdminViewController.h"
#import "ARAppDelegate.h"
#import "ARSync.h"

// We want to hook into the main sync object


@interface ARAppDelegate (Private)
@property (nonatomic, strong) ARSync *sync;
@end

// In order to traverse the tree we need to be able to dig into the sync's private API


@interface ARSync (Private)
@property (nonatomic, strong) NSMutableArray *operationQueues;
@property (nonatomic, strong) DRBOperationTree *rootOperation;
@end


@interface DRBOperationTree (Private)
@property (nonatomic, strong) NSMutableSet *children;
@end


@interface ARSyncAdminViewController ()

@property (readwrite, nonatomic, strong) NSMutableString *treeDescription;

@property (readwrite, nonatomic, weak) IBOutlet UITextView *adminTextView;
@property (readwrite, nonatomic, weak) IBOutlet UITextView *activeTextView;

@property (readwrite, nonatomic, weak) IBOutlet UILabel *operationCountLabel;

@property (readwrite, nonatomic, strong) NSTimer *refreshTimer;
@property (assign, nonatomic) NSInteger operationCount;
@property (strong, nonatomic) NSCountedSet *operationBag;
@property (strong, nonatomic) NSMutableArray *trees;
@property (strong, nonatomic) NSMutableArray *activeOperations;

@end


@implementation ARSyncAdminViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    _refreshTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTextView) userInfo:nil repeats:YES];
    _operationBag = [[NSCountedSet alloc] init];
    _trees = [[NSMutableArray alloc] init];
    _activeOperations = [[NSMutableArray alloc] init];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_refreshTimer invalidate];
}

- (ARSync *)activeSync
{
    ARAppDelegate *appDelegate = (id)[UIApplication sharedApplication].delegate;
    return appDelegate.sync;
}

- (IBAction)exitButtonTapped:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)updateTextView
{
    self.treeDescription = [NSMutableString string];
    self.operationCount = 0;

    [self.operationBag removeAllObjects];
    [self.trees removeAllObjects];
    [self.activeOperations removeAllObjects];

    [self getInfoForOperationTree:self.activeSync.rootOperation indentation:0];

    self.adminTextView.text = self.treeDescription;

    [self.treeDescription appendString:@"Trees \n\n"];
    for (NSString *treeDescription in self.trees) {
        [self.treeDescription appendFormat:@"%@ \n", treeDescription];
    }

    [self.treeDescription appendString:@"\n\nOperations \n\n"];
    for (Class klass in self.operationBag) {
        [self.treeDescription appendFormat:@"%@ - %@ \n", klass, @([self.operationBag countForObject:klass])];
    }

    NSString *activeOps = [[self.activeOperations map:^id(id operation) {
        return [self descriptionForOperation:operation];
    }] join:@"\n"];

    self.activeTextView.text = [@"Active Ops:\n\n" stringByAppendingString:activeOps];

    self.adminTextView.text = self.treeDescription;
    self.adminTextView.font = [UIFont fontWithName:@"Courier" size:14];
    self.operationCountLabel.text = [NSString stringWithFormat:@"%@ operations", @(self.operationCount)];
}

- (void)getInfoForOperationTree:(DRBOperationTree *)tree indentation:(NSInteger)indentation
{
    self.operationCount += tree.operationQueue.operationCount;

    NSArray *classes = [tree.operationQueue.operations map:^id(id object) {
        return [object class];
    }];

    NSString *indentationString = [@"" stringByPaddingToLength:indentation withString:@"  " startingAtIndex:0];
    NSString *treeInfo = [NSString stringWithFormat:@"%@ - %@ - %@",
                                                    indentationString,
                                                    NSStringFromClass(tree.provider.class),
                                                    @(tree.operationQueue.operationCount)];

    NSArray *activeOperations = [tree.operationQueue.operations select:^BOOL(NSOperation *operation) {
        return operation.isExecuting;
    }];

    [self.trees addObject:treeInfo];
    [self.operationBag addObjectsFromArray:classes];
    [self.activeOperations addObjectsFromArray:activeOperations];

    for (DRBOperationTree *subtree in tree.children.copy) {
        [self getInfoForOperationTree:subtree indentation:indentation + 1];
    }
}

- (NSString *)descriptionForOperation:(NSOperation *)operation
{
    if ([operation isKindOfClass:AFURLConnectionOperation.class]) {
        AFURLConnectionOperation *op = (id)operation;
        return [NSString stringWithFormat:@"%@ - %@", NSStringFromClass([operation class]), op.request.URL.path];
    } else {
        return NSStringFromClass([operation class]);
    }
}

@end
