#import "ARSync.h"

/// Takes the `artworkSlugs` from a class, and looks up each artwork
/// via the slug and then sets the relationship with found objects


@interface ARSlugResolver : NSObject <ARSyncPlugin>

@end
