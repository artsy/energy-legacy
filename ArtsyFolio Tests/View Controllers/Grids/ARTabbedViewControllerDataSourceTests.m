#import "ARTabbedViewControllerDataSource.h"
#import "InstallShotImage.h"
#import "AROptions.h"

SpecBegin(ARTabbedViewControllerDataSource);

__block ARTabbedViewControllerDataSource *subject;
__block NSManagedObjectContext *context;

before(^{
    context = [CoreDataManager stubbedManagedObjectContext];
});

it(@"gets expected titles", ^{
    Artist *artist = [Artist objectInContext:context];
    subject = [[ARTabbedViewControllerDataSource alloc] initWithRepresentedObject:artist managedObjectContext:context selectionHandler:nil];
    expect(subject.potentialTitles).to.equal(@[@"Works", @"Shows", @"Albums",  @"Documents"]);

    Show *show = [Show objectInContext:context];
    subject = [[ARTabbedViewControllerDataSource alloc] initWithRepresentedObject:show managedObjectContext:context selectionHandler:nil];
    expect(subject.potentialTitles).to.equal(@[@"Works", @"Documents", @"Installs"]);

    Album *album = [Album objectInContext:context];
    subject = [[ARTabbedViewControllerDataSource alloc] initWithRepresentedObject:album managedObjectContext:context selectionHandler:nil];
    expect(subject.potentialTitles).to.equal(@[@"Works", @"Documents"]);
});


describe(@"only showing what is needed", ^{
    it(@"always presents artworks", ^{
        Artist *artist = [Artist objectInContext:context];
        subject = [[ARTabbedViewControllerDataSource alloc] initWithRepresentedObject:artist managedObjectContext:context selectionHandler:nil];
        expect([subject tabView:nil canPresentViewControllerAtIndex:0]).to.equal(YES);
    });

    it(@"skips shows when there are no shows featuring the object", ^{
        Artist *artist = [Artist objectInContext:context];
        subject = [[ARTabbedViewControllerDataSource alloc] initWithRepresentedObject:artist managedObjectContext:context selectionHandler:nil];
        expect([subject tabView:nil canPresentViewControllerAtIndex:1]).to.equal(NO);
    });

    it(@"shows shows when there are shows featuring the object", ^{
        Artist *artist = [Artist objectInContext:context];
        Show *show = [Show objectInContext:context];
        artist.showsFeaturingArtist = [NSSet setWithObject:show];

        subject = [[ARTabbedViewControllerDataSource alloc] initWithRepresentedObject:artist managedObjectContext:context selectionHandler:nil];
        expect([subject tabView:nil canPresentViewControllerAtIndex:1]).to.equal(YES);
    });

    it(@"skips albums when there are no albums featuring the object", ^{
        Artist *artist = [Artist objectInContext:context];
        subject = [[ARTabbedViewControllerDataSource alloc] initWithRepresentedObject:artist managedObjectContext:context selectionHandler:nil];
        expect([subject tabView:nil canPresentViewControllerAtIndex:1]).to.equal(NO);
    });

    it(@"shows albums when there are albums featuring the object", ^{
        Artist *artist = [Artist objectInContext:context];
        Album *album = [Album objectInContext:context];
        artist.albumsFeaturingArtist = [NSSet setWithObject:album];

        subject = [[ARTabbedViewControllerDataSource alloc] initWithRepresentedObject:artist managedObjectContext:context selectionHandler:nil];
        expect([subject tabView:nil canPresentViewControllerAtIndex:2]).to.equal(YES);
    });

    it(@"skips docs when there are no docs on the object", ^{
        Artist *artist = [Artist objectInContext:context];
        subject = [[ARTabbedViewControllerDataSource alloc] initWithRepresentedObject:artist managedObjectContext:context selectionHandler:nil];
        expect([subject tabView:nil canPresentViewControllerAtIndex:3]).to.equal(NO);
    });

    pending(@"shows docs when there are albums featuring the object", ^{
        Artist *artist = [Artist objectInContext:context];
        Document *doc = [Document objectInContext:context];
        doc.hasFile = @(YES);
        doc.artist = artist;
        artist.documents = [NSSet setWithObject:doc];

        subject = [[ARTabbedViewControllerDataSource alloc] initWithRepresentedObject:artist managedObjectContext:context selectionHandler:nil];
        expect([subject tabView:nil canPresentViewControllerAtIndex:3]).to.equal(YES);
    });

    it(@"skips install shots when there are no installation images on the object", ^{
        Show *show = [Show objectInContext:context];
        subject = [[ARTabbedViewControllerDataSource alloc] initWithRepresentedObject:show managedObjectContext:context selectionHandler:nil];
        expect([subject tabView:nil canPresentViewControllerAtIndex:2]).to.equal(NO);
    });

    it(@"shows install shots when there are installation images on the object", ^{
        Show *show = [Show objectInContext:context];
        InstallShotImage *installationShot = [InstallShotImage objectInContext:context];
        show.installationImages = [NSSet setWithObject:installationShot];

        subject = [[ARTabbedViewControllerDataSource alloc] initWithRepresentedObject:show managedObjectContext:context selectionHandler:nil];
        expect([subject tabView:nil canPresentViewControllerAtIndex:2]).to.equal(YES);
    });

});

SpecEnd
