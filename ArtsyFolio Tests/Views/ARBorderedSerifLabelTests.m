#import "ARBorderedSerifLabel.h"
#import "AROptions.h"
#import <FLKAutoLayout/UIView+FLKAutoLayout.h>
#import <Artsy_UILabels/ARLabelSubclasses.h>

SpecBegin(ARBorderedSerifLabel);

__block ARBorderedSerifLabel *sut;

before(^{
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:AROptionsUseWhiteFolio];
    sut = [[ARBorderedSerifLabel alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
    sut.label.text = @"Example Text";
});

it(@"looks right", ^{
    [sut constrainWidth:@"320"];
    sut.frame = CGRectMake(0, 0, 320, sut.intrinsicContentSize.height);
    expect(sut).to.haveValidSnapshot();
});

SpecEnd
