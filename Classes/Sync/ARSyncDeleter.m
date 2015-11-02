#import "ARSyncDeleter.h"
#import "ARSyncBackgroundedCheck.h"


@interface ARSyncDeleter ()
@property (nonatomic, strong, readwrite) NSMutableSet *set;
@property (nonatomic, strong, readwrite) NSManagedObjectContext *context;
@end


@implementation ARSyncDeleter

- (instancetype)init
{
    self = [super init];
    if (!self) return nil;

    _set = [NSMutableSet set];

    return self;
}

- (void)syncDidStart:(ARSync *)sync
{
    // TODO: DI the context instead of using a property
    self.context = sync.config.managedObjectContext;

    NSArray *allClassesToRemoveIfNeeded = @[ Artwork.class, Artist.class, Image.class, Document.class, Show.class, Location.class ];
    [allClassesToRemoveIfNeeded each:^(Class klass) {
        [self markAllObjectsInClassForDeletion:klass];
    }];

    // Local albums & all albums should be skipped by the deleter
    [[Album downloadedAlbumsInContext:self.context] each:^(Album *album) {
        [self markObjectForDeletion:album];
    }];
}

- (void)syncDidFinish:(ARSync *)sync
{
    if (self.backgroundCheck.applicationHasGoneIntoTheBackground) {
        return;
    }
    [self deleteObjects];
}

- (void)markAllObjectsInClassForDeletion:(Class)klass
{
    NSEntityDescription *description = [NSEntityDescription entityForName:NSStringFromClass(klass) inManagedObjectContext:self.context];
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass(klass)];
    request.entity = description;

    @synchronized(self)
    {
        NSArray *objects = [self.context executeFetchRequest:request error:nil];
        if (objects) {
            [self.set addObjectsFromArray:objects];
        }
    }
}

- (void)markObjectForDeletion:(NSManagedObject *)object
{
    @synchronized(self)
    {
        [self.set addObject:object];
    }
}

- (void)unmarkObjectForDeletion:(NSManagedObject *)object
{
    @synchronized(self)
    {
        [self.set removeObject:object];
    }
}

- (void)deleteObjects
{
    NSManagedObjectContext *context = self.context;
    NSSet *objects = self.set;

    ARSyncLog(@"Removing %@ objects", @(objects.count));

    @synchronized(self)
    {
        for (NSManagedObject *object in objects) {
            [context deleteObject:object];
        }
    }
}

- (NSSet *)markedObjects
{
    return [NSSet setWithSet:self.set];
}

@end
