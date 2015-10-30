#import "ARLabSettingsSplitViewController.h"
#import "ARStoryboardIdentifiers.h"
#import "ARLabSettingsDetailViewManager.h"
#import "ARSyncStatusViewModel.h"

id mockSyncViewModel(void);

SpecBegin(ARLabSettingsViewController);

__block ARLabSettingsSplitViewController *controller;
__block id mockManager;

beforeEach(^{
    ARLabSettingsDetailViewManager *manager = [[ARLabSettingsDetailViewManager alloc] init];
    mockManager = [OCMockObject partialMockForObject:manager];
    id mockViewModel = mockSyncViewModel();
    [[[mockManager stub] andReturn:(ARSyncStatusViewModel *)mockViewModel] viewModelForSection:ARLabSettingsSectionSync];
});

afterEach(^{
    [mockManager stopMocking];
});

describe(@"visuals", ^{
    it(@"looks right by default", ^{
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"ARLabSettings" bundle:nil];
        controller = [storyboard instantiateInitialViewController];
        controller.delegate = mockManager;
        expect(controller).to.haveValidSnapshot();
    });
});

SpecEnd

id mockSyncViewModel(void)
{
    ARSyncStatusViewModel *viewModel = [[ARSyncStatusViewModel alloc] init];
    id mockViewModel = [OCMockObject partialMockForObject:viewModel];
    [[[mockViewModel stub] andReturnValue:@(1)] syncLogCount];
    NSArray *arr = @[ @"October 32, 2015" ];
    [[[mockViewModel stub] andReturn:arr] previousSyncDateStrings];
    return mockViewModel;
};
