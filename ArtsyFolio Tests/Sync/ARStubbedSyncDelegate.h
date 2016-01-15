#import <Foundation/Foundation.h>
#import "ARSync.h"

/// A generic sync delegate; it will run the onSyncCompletion block within its syncDidFinish method
@interface ARStubbedSyncDelegate : NSObject <ARSyncDelegate>

@property (nonatomic, copy) void (^onSyncCompletion)(void);

@end
