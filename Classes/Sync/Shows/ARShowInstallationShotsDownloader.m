#import "ARShowInstallationShotsDownloader.h"
#import "ARPagingDownloaderOperation.h"
#import "ARRouter.h"
#import "ARFeedTranslator.h"
#import "InstallShotImage.h"


@interface ARShowInstallationShotsDownloader ()
@property (nonatomic, strong, readonly) NSManagedObjectContext *context;
@property (nonatomic, strong) ARDeleter *deleter;

@end


@implementation ARShowInstallationShotsDownloader

- (instancetype)initWithContext:(NSManagedObjectContext *)context deleter:(ARDeleter *)deleter
{
    if ((self = [super init])) {
        _context = context;
        _deleter = deleter;
    }
    return self;
}

- (void)operationTree:(DRBOperationTree *)tree objectsForObject:(Show *)show completion:(void (^)(NSArray *))completion
{
    completion(@[ show ]);
}

- (NSOperation *)operationTree:(DRBOperationTree *)node
            operationForObject:(Show *)show
                  continuation:(void (^)(id, void (^)()))continuation
                       failure:(void (^)())failure
{
    ARPagingDownloaderOperation *downloaderOperation = [[ARPagingDownloaderOperation alloc] init];

    @weakify(self);
    downloaderOperation.requestWithPage = ^NSURLRequest *(NSInteger page)
    {
        return [ARRouter newInstallationImagesRequestForShowWithID:show.showSlug page:page];
    };

    downloaderOperation.onCompletionWithJSONDictionaries = ^(NSSet *images) {
        @strongify(self);

        [ARFeedTranslator backgroundAddOrUpdateObjects:images.allObjects withClass:InstallShotImage.class inContext:self.context saving:NO completion:^(NSArray *objects) {

            [show.managedObjectContext performBlockAndWait:^{

                for (id object in objects) {
                    [self.deleter unmarkObjectForDeletion:object];
                }

                show.installationImages = [NSSet setWithArray:objects];
            }];
            continuation(show, nil);

        }];
    };

    downloaderOperation.failure = failure;
    return downloaderOperation;
}

@end
