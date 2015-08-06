#import "ARStubbedCoreData.h"
#import "ARModelFactory.h"


@interface ARStubbedCoreData ()
@property (readwrite, nonatomic, strong) NSManagedObjectContext *context;

@property (readwrite, nonatomic, strong) Artist *artist1;
@end


@implementation ARStubbedCoreData

+ (instancetype)stubbedCoreDataInstance
{
    ARStubbedCoreData *instance = [[ARStubbedCoreData alloc] init];

    NSManagedObjectContext *context = [CoreDataManager stubbedManagedObjectContext];
    instance.context = context;

    instance.artist1 = [ARModelFactory filledArtistInContext:context];

    Artwork *artwork1 = [ARModelFactory partiallyFilledArtworkInContext:context];
    Image *image = [Image modelFromJSON:@{} inContext:context];
    artwork1.images = [NSSet setWithObject:image];

    Artwork *artwork2 = [ARModelFactory partiallyFilledArtworkInContext:context];
    Artwork *artwork3 = [ARModelFactory partiallyFilledArtworkInContext:context];

    instance.artist1.artworks = [NSSet setWithObjects:artwork1, artwork2, artwork3, nil];
    return instance;
}

@end
