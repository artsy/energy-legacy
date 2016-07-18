#import "ARSyncDeleter.h"
#import "Artwork.h"


@interface ARSyncDeleter (Private)
@property (nonatomic, strong, readwrite) NSManagedObjectContext *context;
@end

SpecBegin(ARDeleter);

describe(@"Adding objects", ^{
    __block ARSyncDeleter *sut;

    beforeAll(^{
        sut = [[ARSyncDeleter alloc] init];
        sut.context = [CoreDataManager stubbedManagedObjectContext];
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
    __block ARSyncDeleter *sut;

    it(@"removes an object via unmarkObjectForDeletion", ^{

        sut = [[ARSyncDeleter alloc] init];
        sut.context = [CoreDataManager stubbedManagedObjectContext];

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

        ARSyncDeleter *sut = [[ARSyncDeleter alloc] init];
        sut.context = context;

        Artwork *artwork = [Artwork objectInContext:context];

        [sut markObjectForDeletion:artwork];
        [sut deleteObjects];

        /// So, the delay is because the deletion is now happening
        /// on whatever thread the NSManagedObjectContext wants.
        [mock verifyWithDelay:0.1];
    });

});


SpecEnd
