#import "Show.h"
#import "InstallShotImage.h"

SpecBegin(Show);

__block Show *subject;
__block NSManagedObjectContext *context;

it(@"returns its installation shots via installationShotsFetchRequest", ^{
    context = [CoreDataManager stubbedManagedObjectContext];
    subject = [Show objectInContext:context];
    InstallShotImage *image = [InstallShotImage objectInContext:context];
    [subject addInstallationImagesObject:image];

    NSArray *installationImages = [context executeFetchRequest:[subject installationShotsFetchRequestInContext:context] error:nil];
    expect(installationImages).to.equal(@[image]);
});

it(@"returns correct presentable name", ^{
    context = [CoreDataManager stubbedManagedObjectContext];
    subject = [Show objectInContext:context];
    Partner *partner = [Partner objectInContext:context];
    partner.name = @"Gallery";
    subject.name = [NSString stringWithFormat:@"%@ at An Art Fair", [Partner currentPartnerInContext:context].name];
    
    expect([subject presentableName]).to.equal(@"An Art Fair");

});

SpecEnd
