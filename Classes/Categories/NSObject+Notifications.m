

@implementation NSObject (Notifications)

- (void)observeNotification:(NSString *)notificationName globallyWithSelector:(SEL)notificationSelector
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:notificationSelector name:notificationName object:nil];
}

- (void)observeNotification:(NSString *)notificationName onObject:(NSObject *)object withSelector:(SEL)notificationSelector
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:notificationSelector name:notificationName object:object];
}

- (void)stopObservingNotification:(NSString *)notificationName
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:notificationName object:nil];
}

- (void)stopObservingNotification:(NSString *)notificationName onObject:(NSObject *)object
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:notificationName object:object];
}

@end
