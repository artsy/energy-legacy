#import "ARSelectionHandler.h"
#import "NSArray+ObjectsOfClass.h"


@interface ARSelectionHandler ()

@property (nonatomic, strong) NSMutableSet *internalSelectedObjects;
@property (nonatomic, strong) Album *selectedAlbum;
@property (nonatomic, assign) BOOL selectingForEmail;
@property (nonatomic, assign) BOOL selectingForAddingToAlbums;

@end


@implementation ARSelectionHandler

#pragma mark -
#pragma mark Setup

+ (ARSelectionHandler *)sharedHandler
{
    static ARSelectionHandler *_sharedManager = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedManager = [[self alloc] init];
    });

    return _sharedManager;
}

- (BOOL)isSelecting
{
    return (self.internalSelectedObjects != nil);
}

- (BOOL)isSelectingForEmail
{
    return [self selectingForEmail];
}

- (BOOL)isSelectingForAlbum
{
    return [self selectingForAddingToAlbums];
}

- (NSSet *)selectedObjects
{
    return [NSSet setWithSet:self.internalSelectedObjects];
}

- (void)startSelecting:(BOOL)selecting
{
    if (selecting) {
        [self startSelecting];
    } else {
        [self finishSelection];
    }
}

- (void)startSelecting
{
    self.internalSelectedObjects = [NSMutableSet set];
}

- (void)startSelectingForEmail
{
    self.selectingForEmail = YES;
    [self startSelecting];
}

- (void)startSelectingForAlbum:(Album *)album
{
    self.selectedAlbum = album;
    [self startSelecting];
    [self selectObjects:album.artworks];
}

- (void)startSelectingForAnyAlbum
{
    self.selectingForAddingToAlbums = YES;
    [self startSelecting];
}

#pragma mark -
#pragma mark Saving / Cancelling

- (void)commitSelection
{
    [self endSelectingAlbumWithSave:YES];
}

- (void)cancelSelection
{
    [self finishSelection];
}

- (void)finishSelection
{
    [self endSelectingAlbumWithSave:NO];
}

- (void)endSelectingAlbumWithSave:(BOOL)save
{
    _selectingForEmail = NO;
    _selectingForAddingToAlbums = NO;

    if (save) {
        self.selectedAlbum.artworks = [self.internalSelectedObjects setWithOnlyObjectsOfClass:Artwork.class];
        self.selectedAlbum.documents = [self.internalSelectedObjects setWithOnlyObjectsOfClass:Document.class];

        [self.selectedAlbum updateArtists];
        [self.selectedAlbum saveManagedObjectContextLoggingErrors];
        [[NSNotificationCenter defaultCenter] postNotificationName:ARAlbumDataChanged object:nil];
    }

    self.internalSelectedObjects = nil;
    self.selectedAlbum = nil;
}

#pragma mark -
#pragma mark Selection

- (void)selectObject:(ARManagedObject *)object
{
    if ([object conformsToProtocol:@protocol(ARMultipleSelectionItem)]) {
        [self.internalSelectedObjects addObject:object];
        [self postChangeNotification];
    }
}

- (void)deselectObject:(ARManagedObject *)object
{
    if ([object conformsToProtocol:@protocol(ARMultipleSelectionItem)]) {
        [self.internalSelectedObjects removeObject:object];
        [self postChangeNotification];
    }
}

- (void)selectObjects:(NSSet *)objects
{
    for (ARManagedObject *object in objects) {
        if ([object conformsToProtocol:@protocol(ARMultipleSelectionItem)]) {
            [self.internalSelectedObjects addObject:object];
        }
    }
    [self postChangeNotification];
}

- (void)deselectAllObjects
{
    [self.internalSelectedObjects removeAllObjects];
    [self postChangeNotification];
}

- (void)postChangeNotification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:ARGridSelectionChangedNotification object:self];
}

@end
