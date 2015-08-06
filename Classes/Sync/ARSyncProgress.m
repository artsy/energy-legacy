#import "ARSyncProgress.h"


@interface ARSyncProgress ()
@property (readonly, nonatomic, strong) NSMutableArray *samples;
@property (readwrite, nonatomic, assign) CGFloat movingAverage;
@property (readwrite, nonatomic, assign) unsigned long long numBytesDownloaded;
@end

const NSUInteger ARSyncProgressNumSamples = 5;


@implementation ARSyncProgress

- (void)start
{
    _startDate = [NSDate date];
    _samples = [NSMutableArray array];
}

- (void)downloadedNumBytes:(unsigned long long)numBytes
{
    self.numBytesDownloaded += numBytes;
    [self.delegate syncDidProgress:self];
}

- (CGFloat)bytesPerSecond
{
    NSTimeInterval time = [[NSDate date] timeIntervalSinceDate:_startDate];
    CGFloat bytesPerSecond = _numBytesDownloaded / time;
    return [self addSample:bytesPerSecond];
}

- (CGFloat)addSample:(CGFloat)sample
{
    NSUInteger n = [_samples count];
    if (n < ARSyncProgressNumSamples) {
        [_samples addObject:@(sample)];
        CGFloat sum = 0;
        for (id sampleObj in _samples) {
            sum += [sampleObj floatValue];
        }
        self.movingAverage = sum / (n + 1);
    } else {
        id sampleObj = [_samples firstObject];
        [_samples removeObject:sampleObj];
        [_samples addObject:@(sample)];
        self.movingAverage = self.movingAverage - [sampleObj floatValue] / ARSyncProgressNumSamples + sample / ARSyncProgressNumSamples;
    }
    return self.movingAverage;
}

- (NSTimeInterval)estimatedTimeRemaining
{
    unsigned long long numBytesRemaining = _numEstimatedBytes - _numBytesDownloaded;
    return numBytesRemaining / [self bytesPerSecond];
}

- (CGFloat)percentDone
{
    return self.numEstimatedBytes == 0 ? 0 : (CGFloat)self.numBytesDownloaded / self.numEstimatedBytes;
}

@end
