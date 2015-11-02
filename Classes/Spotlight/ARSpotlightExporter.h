#import "ARSync.h"

// This only compiles on iOS9 SDKs and above
// but they are still in beta, so no CI.

// This ensures that it compiles on travis for the moment

#if __has_include(<CoreSpotlight/CoreSpotlight.h>)

#import <CoreSpotlight/CoreSpotlight.h>

/// Imports Artists and Artworks from a NSManagedObjectcontext into the Spotlight database on iOS9


@interface ARSpotlightExporter : NSObject <ARSyncPlugin>

- (instancetype)initWithIndex:(CSSearchableIndex *)index;

/// Resets local cache then updates with all artists and artworks, runs work on a background thread.
- (void)updateCache;

/// Empties the Spotlight cache in anticipation of new results
- (void)emptyLocalSpotlightCacheCompletion:(void (^)(NSError *error))completionHandler;

/// Adds an array of CSSearchableItems to add to the spotlight index
- (void)addResultsToCache:(NSArray *)results completion:(void (^)(NSError *error))completionHandler;

/// Converts all artists in the managed object context into CSSearchableItems
- (NSArray<CSSearchableItem *> *)artistResults;

/// Converts all artworks in the managed object context into CSSearchableItems
- (NSArray<CSSearchableItem *> *)artworkResults;

@end

#endif
