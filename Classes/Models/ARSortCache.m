#import "ARSortCache.h"
#import "ARFileUtils.h"

#define SORT_CACHE_FILENAME @"sort_cache"

static NSString *cachePath;
static NSMutableDictionary *cache;


@implementation ARSortCache

+ (void)initialize
{
    if (self == [ARSortCache class]) {
        NSString *library = [ARFileUtils userLibraryDirectoryPath];
        cachePath = [library stringByAppendingPathComponent:SORT_CACHE_FILENAME];

        if ([[NSFileManager defaultManager] fileExistsAtPath:cachePath]) {
            cache = [[NSKeyedUnarchiver unarchiveObjectWithFile:cachePath] mutableCopy];
        } else {
            cache = [NSMutableDictionary dictionary];
        }
    }
}

+ (void)serialize
{
    if (!cache) {
        return;
    }
    [NSKeyedArchiver archiveRootObject:cache toFile:cachePath];
}

+ (enum ARArtworkSortOrder)sortOrderForObjectWithSlug:(NSString *)slug
{
    NSNumber *order = [cache objectForKey:slug];
    if (!order) {
        return ARArtworksSortOrderNotFound;
    }
    return (enum ARArtworkSortOrder)[order integerValue];
}

+ (void)setOrder:(enum ARArtworkSortOrder)order forObjectWithSlug:(NSString *)slug
{
    [cache setObject:[NSNumber numberWithInteger:order] forKey:slug];
    [ARSortCache serialize];
}

@end
