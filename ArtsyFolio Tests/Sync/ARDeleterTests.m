#import "ARDeleter.h"
#import "Artwork.h"

SpecBegin(ARDeleter);

describe(@"Adding objects", ^{
    __block ARDeleter *sut;

    beforeAll(^{
        sut = [[ARDeleter alloc] initWithManagedObjectContext:[CoreDataManager stubbedManagedObjectContext]];
    });

    it(@"adds an object via markObjectForDeletion", ^{
        Artwork *artwork = [Artwork objectInContext:sut.context];
        [sut markObjectForDeletion:artwork];
        expect(sut.markedObjects).to.contain(artwork);
    });

    it(@"adds all objects of a class via markAllObjectsInClassForDeletion", ^{
        Artwork *artwork = [Artwork objectInContext:sut.context];
        Artwork *artwork2 = [Artwork objectInContext:sut.context];

        [sut markAllObjectsInClassForDeletion:Artwork.class];

        expect(sut.markedObjects).to.contain(artwork);
        expect(sut.markedObjects).to.contain(artwork2);
    });

});

describe(@"Removing objects", ^{
    __block ARDeleter *sut;

    it(@"removes an object via unmarkObjectForDeletion", ^{

        sut = [[ARDeleter alloc] initWithManagedObjectContext:[CoreDataManager stubbedManagedObjectContext]];

        Artwork *artwork = [Artwork objectInContext:sut.context];
        [sut markObjectForDeletion:artwork];
        expect(sut.markedObjects).to.contain(artwork);

        [sut unmarkObjectForDeletion:artwork];
        expect(sut.markedObjects).toNot.contain(artwork);
    });

    it(@"deletes tries to delete all objects ", ^{
        NSManagedObjectContext *context = [CoreDataManager stubbedManagedObjectContext];
        id mock = [OCMockObject partialMockForObject:context];
        [[mock expect] deleteObject:[OCMArg any]];

        ARDeleter *sut = [[ARDeleter alloc] initWithManagedObjectContext:context];
        Artwork *artwork = [Artwork objectInContext:context];

        [sut markObjectForDeletion:artwork];
        [sut deleteObjects];

        [mock verify];
    });

});


SpecEnd
