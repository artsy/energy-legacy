#import "ARDeleter.h"


@interface ARDeleter ()
@property (nonatomic, strong) NSMutableSet *set;
@property (nonatomic, strong, readwrite) NSManagedObjectContext *context;
@end


@implementation ARDeleter

- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext *)context
{
    self = [super init];
    if (!self) return nil;

    _set = [NSMutableSet set];
    _context = context;

    return self;
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
