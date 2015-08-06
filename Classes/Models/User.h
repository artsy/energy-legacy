#import "_User.h"
#import "ARManagedObject.h"


@interface User : _User

/// Deprecated
+ (User *)currentUser;

/// Use this one!
+ (User *)currentUserInContext:(NSManagedObjectContext *)context;

- (BOOL)isAdmin;

@end
