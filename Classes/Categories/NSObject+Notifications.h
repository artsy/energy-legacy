// a smallers, more elegant version of
// [[NSNotificationCenter defaultCenter] addObserver:self selector:notificationSelector name:notificationName object:nil];


@interface NSObject (Notifications)
- (void)observeNotification:(NSString *)notificationName globallyWithSelector:(SEL)notificationSelector;

- (void)observeNotification:(NSString *)notificationName onObject:(NSObject *)object withSelector:(SEL)notificationSelector;

- (void)stopObservingNotification:(NSString *)notificationName;

- (void)stopObservingNotification:(NSString *)notificationName onObject:(NSObject *)object;
@end
