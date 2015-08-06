#import "ARHostSelectionController.h"
#import "ARSelectionHandler.h"


@interface ARHostSelectionController (Testing)
- (void)selectionStateChanged;
@property (nonatomic, strong) ARSelectionHandler *selectionHandler;
@end

SpecBegin(ARHostSelectionController);

__block ARSelectionHandler *selectionHandler;
__block ARHostSelectionController *sut;

before(^{
    sut = [[ARHostSelectionController alloc] init];
    selectionHandler = [[ARSelectionHandler alloc] init];
    sut.selectionHandler = selectionHandler;
});

describe(@"notifications", ^{
    it(@"listens for selection notifications", ^{
        [sut startListening];
        id sutMock = [OCMockObject partialMockForObject:sut];
        
        [[sutMock expect] selectionStateChanged];
        [[NSNotificationCenter defaultCenter] postNotificationName:ARGridSelectionChangedNotification object:selectionHandler];
        [sutMock verify];
    });
    
    it(@"stops listening for selection notifications", ^{
        [sut startListening];
        id sutMock = [OCMockObject partialMockForObject:sut];
        [sut stopListening];
        
        [[sutMock reject] selectionStateChanged];
        [[NSNotificationCenter defaultCenter] postNotificationName:ARGridSelectionChangedNotification object:selectionHandler];
        [sutMock verify];
    });
});


SpecEnd
