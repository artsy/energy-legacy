#import "PartnerOption.h"

SpecBegin(PartnerOptionModelTests);

__block NSSet *partnerOptions;
__block NSManagedObjectContext *context;

before(^{
    NSDictionary *dictionary = @{
        @"key1": @"value1",
        @"key2": @45,
        @"key3": @[@1,@2,@3],
        @"key4": @{ @"hi" : @"OK" }
    };

    context = [CoreDataManager stubbedManagedObjectContext];
    partnerOptions = [PartnerOption optionsWithDictionary:dictionary inContext:context];
});

it(@"generates only valid options", ^{
    expect(partnerOptions.count).to.equal(2);
});

it(@"generates partner options in the context", ^{
    expect([PartnerOption countInContext:context error:nil]).to.equal(2);
});

it(@"gets a partner option called key1", ^{
    NSArray *selectedOption = [partnerOptions select:^BOOL(PartnerOption* option) {
        return [[option key] isEqualToString:@"key1"];
    }];
    expect(selectedOption.count).to.equal(1);
});

it(@"gets a partner option called key2", ^{
    NSArray *selectedOption = [partnerOptions select:^BOOL(PartnerOption* option) {
        return [[option key] isEqualToString:@"key2"];
    }];
    expect(selectedOption.count).to.equal(1);
});

it(@"ignores array and hash options", ^{
    NSArray *selectedOption = [partnerOptions select:^BOOL(PartnerOption* option) {
        return [[option key] isEqualToString:@"key3"] || [[option key] isEqualToString:@"key4"];;
    }];
    expect(selectedOption.count).to.equal(0);
});

SpecEnd
