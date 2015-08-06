#import "ARFileUtils+FolioAdditions.h"

static NSString *CoreDataStorePath;
static NSString *CoreDataStoreLibraryCachesPath;


@implementation ARFileUtils (FolioAdditions)

+ (void)removeCurrentPartnerDocumentsWithCompletion:(dispatch_block_t)completion
{
    [ARFileUtils removeContentsOfFolder:[ARFileUtils userDocumentsDirectoryPath]];
    [ARFileUtils removeContentsOfFolder:NSTemporaryDirectory()];
    [ARFileUtils removeContentsOfFolder:[ARFileUtils userLibraryDirectoryPath]];

    if (completion) {
        completion();
    }
}

+ (NSString *)coreDataStoreFileName
{
    return @"ArtsyPartner.sqlite";
}

+ (NSString *)coreDataStorePath
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *storeDirectory = [ARFileUtils userDocumentsDirectoryPath];
        CoreDataStorePath = [storeDirectory stringByAppendingPathComponent:[ARFileUtils coreDataStoreFileName]];
    });

    return CoreDataStorePath;
}

+ (NSString *)pre15CoreDataStorePath
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *storeDirectory = [ARFileUtils applicationCachesDirectoryPath];
        CoreDataStoreLibraryCachesPath = [storeDirectory stringByAppendingPathComponent:[ARFileUtils coreDataStoreFileName]];
    });

    return CoreDataStoreLibraryCachesPath;
}

+ (BOOL)pre15CoreDataStoreExists
{
    NSString *path = [ARFileUtils pre15CoreDataStorePath];
    NSFileManager *manager = [NSFileManager defaultManager];
    return [manager fileExistsAtPath:path];
}

@end
