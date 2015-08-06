#import "ARTileUnzipper.h"
#import "ARTileArchive.h"
#import <ZipArchive/ZipArchive.h>
#import "ARFileUtils.h"
#import "NSFileManager+SimpleDeletion.h"
#import "NSFileManager+SkipBackup.h"


@implementation ARTileUnzipper

- (void)operationTree:(DRBOperationTree *)tree objectsForObject:(id)object completion:(void (^)(NSArray *))completion
{
    completion(@[ object ]);
}

- (NSOperation *)operationTree:(DRBOperationTree *)node
            operationForObject:(ARTileArchive *)tileArchive
                  continuation:(void (^)(id, void (^)()))continuation
                       failure:(void (^)())failure
{
    __weak typeof(self) weakSelf = self;
    NSOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        [weakSelf unzipTilesAtPath:tileArchive.path forImage:tileArchive.image];
    }];

    operation.completionBlock = ^{
        continuation(nil, nil);
    };
    return operation;
}

- (BOOL)unzipTilesAtPath:(NSString *)path forImage:(Image *)image
{
    NSString *tempPath = [NSTemporaryDirectory() stringByAppendingPathComponent:image.slug];
    ZipArchive *zip = [[ZipArchive alloc] init];
    if (![zip UnzipOpenFile:path]) {
        // As this is a terminal error, kill the process
        // and return NO.
        ARSyncLog(@"Error unzipping file %@", path);
        [[NSFileManager defaultManager] deleteFileAtPath:path];
        return NO;
    }

    // Never seen this crash on a device, but can do so on sim, covering bases
    // just in case.

    @try {
        if (![zip UnzipFileTo:tempPath overWrite:YES]) return NO;
    }
    @catch (NSException *exception) {
        ARSyncLog(@"Error unzipping file at %@", path);
        return NO;
    }

    //_zipContentsSize = [[NSFileManager defaultManager] sizeOfFoldersContents:tempPath];

    // Move the files out into their correct folders for the app
    for (NSInteger i = ARTiledZoomMinLevel; i <= [image maxLevel]; i++) {
        NSString *levelPath = [tempPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", @(i)]];
        NSString *baseFilename = [NSString stringWithFormat:@"%@_tile_%@_", image.slug, @(i)];

        for (NSString *file in [[NSFileManager defaultManager] enumeratorAtPath:levelPath]) {
            NSString *extention = [[file pathComponents] lastObject];
            NSString *imageName = [baseFilename stringByAppendingString:extention];
            NSString *destination = [ARFileUtils filePathWithFolder:ImageDirectoryName documentFileName:imageName];

            NSError *error = nil;
            [[NSFileManager defaultManager] copyItemAtPath:[levelPath stringByAppendingPathComponent:file]
                                                    toPath:destination
                                                     error:&error];
            if (error) {
                // Having a mis-copied file isn't a terminal issue
                ARSyncLog(@"Error copying tile to %@ [error]: %@ ", destination, error.localizedDescription);
                continue;
            }
        }
    }

    // Delete the zip
    [[NSFileManager defaultManager] deleteFileAtPath:path];

    // Delete the extracted files
    [[NSFileManager defaultManager] deleteFileAtPath:tempPath];

    return YES;
}

@end
