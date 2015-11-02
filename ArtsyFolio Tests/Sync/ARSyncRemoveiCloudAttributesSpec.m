#import "ARSyncRemoveiCloudAttributes.h"
#import "ARSync+TestsExtension.h"


@interface ARSyncRemoveiCloudAttributes (Private)
@property (nonatomic, strong, readwrite) NSFileManager *fileManager;
@end


@interface ARFakeFileManager : NSObject
@property (nonatomic, assign) BOOL setBackupAttributes;

- (void)backgroundAddSkipBackupAttributeToDirectoryAtPath:(NSString *)path;
@end


@implementation ARFakeFileManager

- (void)backgroundAddSkipBackupAttributeToDirectoryAtPath:(NSString *)path
{
    self.setBackupAttributes = YES;
}

@end

SpecBegin(ARSyncRemoveiCloudAttributes);

__block ARSyncRemoveiCloudAttributes *sut;

beforeEach(^{
    sut = [[ARSyncRemoveiCloudAttributes alloc] init];
    sut.fileManager = (id)[[ARFakeFileManager alloc] init];
});

it(@"Triggers the NSFileManager addSkipAttributes", ^{
    ARFakeFileManager *manager = (id)sut.fileManager;

    expect(manager.setBackupAttributes).to.beFalsy();

    [sut syncDidFinish:nil];
    expect(manager.setBackupAttributes).to.beTruthy();
});

it(@"gets created on a sync", ^{
    ARSync *sync = [ARSync syncForTesting];
    expect([sync createsPluginInstanceOfClass:ARSyncRemoveiCloudAttributes.class]).to.beTruthy();
});

SpecEnd
