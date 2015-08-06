#import "ARFileUtils.h"


@interface ARFileUtils (FolioAdditions)

+ (void)removeCurrentPartnerDocumentsWithCompletion:(dispatch_block_t)completion;

+ (NSString *)coreDataStoreFileName;

+ (NSString *)coreDataStorePath;

+ (NSString *)pre15CoreDataStorePath;

+ (BOOL)pre15CoreDataStoreExists;

@end
