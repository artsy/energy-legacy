#import "ARSyncProgress.h"
#import "SyncLog.h"


@interface ARSyncProgress ()
@property (readonly, nonatomic, assign) NSTimeInterval lastSyncTime;
@property (readonly, nonatomic, strong) NSMutableArray *samples;
@property (readwrite, nonatomic, assign) CGFloat movingAverage;
@property (readwrite, nonatomic, assign) unsigned long long numBytesDownloaded;
@end

const NSUInteger ARSyncProgressNumSamples = 5;


@implementation ARSyncProgress

- (void)startWithLastSyncLog:(NSTimeInterval)lastSyncTime
{
    _startDate = [NSDate date];
    _samples = [NSMutableArray array];
    _lastSyncTime = lastSyncTime;
}

- (void)downloadedNumBytes:(unsigned long long)numBytes
{
    self.numBytesDownloaded += numBytes;
    [self.delegate syncDidProgress:self];
}

- (CGFloat)bytesPerSecond
{
    NSTimeInterval time = [[NSDate date] timeIntervalSinceDate:self.startDate];
    CGFloat bytesPerSecond = self.numBytesDownloaded / time;
    return [self addSample:bytesPerSecond];
}

- (CGFloat)addSample:(CGFloat)sample
{
    NSUInteger n = [self.samples count];
    if (n < ARSyncProgressNumSamples) {
        [self.samples addObject:@(sample)];
        CGFloat sum = 0;
        for (id sampleObj in _samples) {
            sum += [sampleObj floatValue];
        }
        self.movingAverage = sum / (n + 1);
    } else {
        id sampleObj = [_samples firstObject];
        [self.samples removeObject:sampleObj];
        [self.samples addObject:@(sample)];
        self.movingAverage = self.movingAverage - [sampleObj floatValue] / ARSyncProgressNumSamples + sample / ARSyncProgressNumSamples;
    }
    return self.movingAverage;
}

- (NSTimeInterval)estimatedTimeRemaining
{
    unsigned long long numBytesRemaining = self.numEstimatedBytes - self.numBytesDownloaded;
    NSTimeInterval currentEstimate = numBytesRemaining / [self bytesPerSecond];

    if (self.lastSyncTime != 0) {
        return (currentEstimate + self.lastSyncTime) / 2;
    }

    return currentEstimate;
}

- (CGFloat)percentDone
{
    return self.numEstimatedBytes == 0 ? 0 : (CGFloat)self.numBytesDownloaded / self.numEstimatedBytes;
}

@end
