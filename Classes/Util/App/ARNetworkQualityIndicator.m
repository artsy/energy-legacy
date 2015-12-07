#import "ARNetworkQualityIndicator.h"
#import "ARRouter.h"


@interface ARNetworkQualityIndicator ()
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, copy) void (^pingBlock)(ARNetworkQuality quality);
@end


@implementation ARNetworkQualityIndicator

- (void)pingArtsy:(void (^)(BOOL connected, NSTimeInterval timeToConnect))completion;
{
    NSURLRequest *request = [ARRouter newArtsyPing];
    [self performRequest:request completion:completion];
}

- (void)pingApple:(void (^)(BOOL connected, NSTimeInterval timeToConnect))completion;
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.apple.com/"] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0];
    [self performRequest:request completion:completion];
}

- (void)performRequest:(NSURLRequest *)request completion:(void (^)(BOOL connected, NSTimeInterval timeToConnect))completion
{
    NSURLSession *session = [NSURLSession sharedSession];
    NSTimeInterval start = [NSDate timeIntervalSinceReferenceDate];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSTimeInterval time = [NSDate timeIntervalSinceReferenceDate] - start;

        if (error) { return completion(NO, time); }
        completion(YES, time);
    }];

    [task resume];
}

- (void)beginObservingNetworkQuality:(void (^)(ARNetworkQuality quality))intervalPing
{
    self.pingBlock = intervalPing;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(ping) userInfo:nil repeats:YES];
    [self.timer fire];
}

- (void)ping
{
    __block NSTimeInterval artsyTime, appleTime;
    __block BOOL artsyConnected, appleConnected;

    dispatch_group_t serviceGroup = dispatch_group_create();
    dispatch_group_enter(serviceGroup);
    [self pingArtsy:^(BOOL connected, NSTimeInterval timeToConnect) {
        artsyTime = timeToConnect;
        artsyConnected = connected;
        dispatch_group_leave(serviceGroup);
    }];

    dispatch_group_enter(serviceGroup);
    [self pingArtsy:^(BOOL connected, NSTimeInterval timeToConnect) {
        appleTime = timeToConnect;
        appleConnected = connected;

        dispatch_group_leave(serviceGroup);
    }];

    dispatch_group_notify(serviceGroup, dispatch_get_main_queue(), ^{
        if (appleConnected == false) {
            self.pingBlock(ARNetworkQualityOffline);
            return;
        }

        // In the office this averages at around 0.15
        NSTimeInterval totalTime = artsyTime + appleTime;

        if (totalTime < 1) {
            self.pingBlock(ARNetworkQualityGood);
        } else if (totalTime < 2) {
            self.pingBlock(ARNetworkQualityOK);
        } else {
            self.pingBlock(ARNetworkQualitySlow);
        }
    });
}

- (void)stopObservingNetworkQuality;
{
    [self.timer invalidate];
}

@end
