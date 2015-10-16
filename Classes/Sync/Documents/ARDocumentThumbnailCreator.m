#import "ARDocumentThumbnailCreator.h"
#import "ARThumbnailCreationOperation.h"
#import "ARPDFThumbnailCreationOperation.h"


@implementation ARDocumentThumbnailCreator

- (void)operationTree:(DRBOperationTree *)tree objectsForObject:(id)object completion:(void (^)(NSArray *))completion
{
    completion(@[ object ]);
}

- (NSOperation *)operationTree:(DRBOperationTree *)node
            operationForObject:(Document *)document
                  continuation:(void (^)(id, void (^)()))continuation
                       failure:(void (^)())failure
{
    NSOperation *operation = nil;
    if ([document.filename hasSuffix:@"pdf"]) {
        operation = [ARPDFThumbnailCreationOperation operationWithPDFSourcePath:document.filePath andDestinationPath:document.customThumbnailFilePath];
    } else {
        operation = [ARThumbnailCreationOperation operationWithDocument:document];
    }

    operation.completionBlock = ^{
        ARSyncLog(@"Created thumbnail for document %@", document.filename);
        continuation(nil, nil);
    };
    return operation;
}

@end
