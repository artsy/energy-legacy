#import "ARSync.h"


@interface ARSync (Tests)

/// This is a test-code smell in theory, as
/// to pull it off you need to dig into the priate
/// methods of ARSync, however it's a really powerful
/// way to check a really important thing.

- (BOOL)createsPluginInstanceOfClass:(Class) class;

/// Creates an ARSync with a stubbed MOC
/// and a Forgeries NSUserDefaults

+ (instancetype)syncForTesting;

/// Creates an ARSync with a set MOC
/// with a Forgeries NSUserDefaults

+ (instancetype)syncForTesting:(NSManagedObjectContext *)context;

/// Sets up a sync with your own MOC + defaults
+ (instancetype)syncForTesting:(NSManagedObjectContext *)context defaults:(NSUserDefaults *)defaults;

@end
